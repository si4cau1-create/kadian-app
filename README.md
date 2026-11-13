# 卡点 Kadian 3.0 · 本地优先的跨平台学习客户端

> 做题 → 不会 → 就地精讲 → 学会。全程不跳页。
>
> Android + Windows 单代码库（Flutter 3.24），等级/证据/校准/成就全部跑在本地 SQLite，
> 大模型只作为「在线服务」被调用，且必须经自建代理转发。

本仓库从 2.x 的 PWA + WebView 壳，改为**本地优先的跨平台客户端 + 轻量 LLM 代理**。
旧版仍在 `kadian-computer`（PWA）与 `kadian-phone`（WebView 壳）两个仓库。

---

## 1. 这一版的关键决策

| 决策 | 落地方式 |
|---|---|
| 等级必须在本地算 | `lib/core/calibration/`，纯 Dart，断网照常更新 |
| 客户端不持有 Provider Key | 全部攻略请求走 `server/`（FastAPI 代理），Key 只在服务端环境变量 |
| 内容与算法分离 | 题库/图谱/成就/校准参数打包成 ZIP，可 OTA；IRT/BKT 算法随客户端发版 |
| 长按/右键即问 | `SelectionArea` + 自定义 `contextMenuBuilder`，按选中类型过滤意图 |
| 不替用户做题 | 服务端提示词硬约束 + 一二级答案泄露过滤（客户端再过滤一遍） |
| 辅助与独立分轨 | `attempts.mode` / `evidence_events.independent`，成就分独立区/辅助区 |

---

## 2. 目录

```
kadian-app/
├─ lib/
│  ├─ app/                     # 启动、主题、壳层、Riverpod provider
│  ├─ core/
│  │  ├─ calibration/          # IRT + BKT + 规则层 + 等级聚合 + 选题信息量
│  │  ├─ content_pack/         # 内容包模型、解析、校验、OTA 安装与回滚
│  │  ├─ db/                   # drift 表与 DAO（schema v2，含 v1→v2 迁移）
│  │  ├─ llm/                  # 代理客户端（SSE）、数据契约
│  │  ├─ selection/            # 选中类型分类、意图菜单过滤、防泄漏
│  │  ├─ services/             # 做题闭环（开题→作答→证据→校准）
│  │  └─ settings/             # 代理地址、设备令牌、BYOK、隐私开关
│  ├─ features/
│  │  ├─ today/ practice/ hints/ level/ achievements/ vocab_review/ settings/
│  └─ main.dart
├─ assets/content_pack/        # 内置内容包（graph/items/vocab/achievements/params）
├─ server/                     # FastAPI LLM 代理 + Docker
├─ tools/
│  ├─ build_content_pack.py    # 打 OTA 包并写校验和
│  └─ release.ps1              # analyze→test→APK/AAB→EXE/MSIX→dist+sha256
├─ test/                       # 47 个 Dart 测试（含 DB 端到端与迁移）
└─ .github/workflows/build.yml # CI：测试、Android、Windows、后端镜像、内容包
```

---

## 3. 架构

```
┌──────────────── 客户端（Flutter，Android / Windows）────────────────┐
│ UI：今日 / 做题 / 复习 / 等级 / 成就 / 设置                          │
│ 本地服务：证据写入、IRT+BKT 校准、选题、成就结算、SM-2 排期          │
│ 本地存储：SQLite（evidence_events / node_states / item_difficulty …）│
│ 内容包：graph / items / vocab / achievements / calibration_params     │
└───────────────┬──────────────────────────────────────────────────────┘
                │ HTTPS（仅攻略、出题、归因、成就解读）
┌───────────────▼──────────────────────────────────────────────────────┐
│ 代理：鉴权（HMAC 设备令牌）· 限流 · 审计 · 角色提示词 · 防泄漏过滤    │
│ 不存等级数据，不参与等级计算                                          │
└───────────────┬──────────────────────────────────────────────────────┘
                │ OpenAI 兼容
        LLM Provider（诊断官 / 出题官 / 攻略官 / 归因官 / 成就官）
```

### 数据表（schema v2）

| 表 | 作用 |
|---|---|
| `evidence_events` | 一切「学过」的事实：分数、有效分、预测正确率、提示层级、是否独立、能力/掌握度快照 |
| `node_states` | 节点聚合：θ、掌握度、独立/辅助/讲解次数、连胜、引擎版本 |
| `item_difficulty` | 题目 IRT b 与曝光次数（本地自适应） |
| `attempts` | 一次作答会话：模式（独立/辅助/讲解）、提示次数、是否揭示答案 |
| `hint_events` | 每次长按/右键请求：选中文本、类型、意图、层级、是否过滤、是否离线 |
| `vocab_states` | 词卡：盒子、ease、到期时间、遗忘次数 |
| `achievement_states` | 成就三段式进度与 XP |
| `content_pack_versions` | 已安装内容包与当前激活版本 |
| `sync_queue` | 预留云同步（首期不外发） |
| `daily_stats` | 每日证据/提示/复习/分钟数，用于连续天数 |

v1→v2 迁移只加表加列（`m.addColumn` / `m.createTable`），不重建表，证据不丢。

---

## 4. 校准是怎么算的

```
有效分 = 原始分 × (独立 ? 1 : 0.35) × 提示层级因子(1.0/0.8/0.55/0.30) × 速度修正
θ' = clamp(θ + 0.35 × (有效分 − 预测正确率), −3, 3)      // Rasch 增量
b' = clamp(b − 0.20 × (有效分 − 预测正确率), −3, 3)      // 题目难度反向更新
BKT：后验 + 学习转移，答错时不允许掌握度反升
掌握度 = 0.5 × BKT + 0.5 × sigmoid(θ + logit(先验))      // θ=0 恰好等于先验 0.15
```

- **提示折减**：辅助证据按 35% 计入，一级提示再乘 0.8。
- **讲解模式**：同题请求 ≥3 次 → 不计成功率、不推进 θ，只留「真的在弄懂」的记录。
- **遗忘衰减**：35 天半衰期，展示与结算时先衰减再加权。
- **超纲证据**：不推进能力，只记录。
- **参数热更新**：`calibration_params.json` 随内容包下发，算法版本写在 `engineVersion`。

等级带：陌生 / 认得 / 半会 / 会用 / 熟练 / 自动化（0–5）。

---

## 5. 长按攻略（Android / Windows 同一套）

1. 语篇、题干、选项都包在同一个 `SelectionArea` 里，跨控件连续选择。
2. `onSelectionChanged` 记录选中文本；`contextMenuBuilder` 用自定义菜单替换系统工具栏
   （Android 13+ 不会出现双菜单）。
3. 选中类型判定：命中选项原文→选项；等于题干片段→题干；否则按字符数/标点/分词启发式分
   单词 / 短语 / 句子 / 段落。
4. 菜单项按类型过滤：段落不给「辨析」，选项不给「翻译」，单词不给「解题思路」。
5. 选意图 → `POST /v1/hints`（SSE）→ 就地展开精讲卡（桌面端右侧检查器，移动端语篇下方）。
6. 每次请求写 `hint_events`，并更新 `attempts` 的 `assisted` / `hint_level` / `hint_request_count`。
7. **一二级防泄漏双保险**：服务端先攒齐再按句剔除含答案的句子；客户端流式阶段再把答案词
   遮蔽成 `＿`，收尾再整句过滤一遍，UI 标「已过滤答案」。
8. 离线时明确提示「当前离线」，不做假装流式。

---

## 6. 成就与 XP

- 8 个成就，三段式（铜/银/金），全部本地结算，可在成就页重算。
- **独立区**只认 `independent=true`（无提示、无揭示、非讲解）；辅助区单列，不串账。
- **XP 只发给诊断**（`diagnostic_sessions`），刷题、看提示、复习都不发 XP。
- 连续天数：每天至少一条证据，断一天归零。

---

## 7. 内容包与 OTA

```json
manifest.json          // packId / version / minAppVersion / engineVersion / checksum / fileHashes
graph.json             // subjects / tracks / clusters / nodes（含前置关系）
items.json             // passages + items（answerIndex / answerKeywords / difficulty / explain）
vocab.json             // 词条（词簇 × 维度）
achievements.json      // 成就定义与三段阈值
calibration_params.json// BKT/IRT 参数、提示因子、衰减半衰期、等级带
```

- 校验和 = 按路径排序后逐文件 sha256，再对整串 sha256（**不含 manifest 自身**）。
- 安装：解压到 `<support>/content_packs/<packId>/<version>.tmp` → 校验 → 原子改名 → 写指针。
  任何一步失败都不动旧指针，因此天然回滚；设置页也可手动「回滚到内置」。
- `minAppVersion` 低于当前客户端会拒绝安装并提示升级。
- 内置包在 `assets/content_pack/`；打 OTA 包：`python tools/build_content_pack.py`。

---

## 8. 构建与打包

### 前置

| 目标 | 需要 |
|---|---|
| Android | Flutter 3.24.5、JDK 17、Android SDK（platform 35 / build-tools 35） |
| Windows | Flutter 3.24.5 + **Visual Studio 2022 的「使用 C++ 的桌面开发」工作负载** |
| 后端 | Docker（或 Python 3.11+） |

国内网络建议：

```bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

### 一键出包

```powershell
pwsh tools/release.ps1                 # 全量
pwsh tools/release.ps1 -AndroidOnly    # 只出 APK/AAB
pwsh tools/release.ps1 -SkipTests      # 跳过测试（不建议）
```

脚本会先校验 `pubspec.yaml` 与 `lib/core/app_info.dart` 的版本一致，再 analyze/test/build，
产物落到 `dist/` 并生成 `checksums-sha256.txt`。

### Android

```bash
flutter build apk --release        # build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle --release  # 上架用
```

签名：`android/key.properties` + `android/keystore/kadian-release.jks`（均在 `.gitignore`）。
缺失时自动退回 debug 签名，便于内测；正式分发前必须换成你自己的 keystore 并妥善备份
（换签名后无法覆盖安装）。包名 `com.kadian.app`，minSdk 24，targetSdk 35。
权限只申请 `INTERNET` 与 `POST_NOTIFICATIONS`。

### Windows

```bash
flutter build windows --release
dart run msix:create               # 生成 MSIX（支持自动更新与签名）
```

`pubspec.yaml` 里的 `msix_config` 已配好显示名、identity、语言与 `internetClient`。
未签名 MSIX 会触发 SmartScreen，内测可接受；正式分发请用 EV/OV 证书签名。
另附 `dist/kadian-3.0.0-windows-x64.zip` 作为免安装分发。

### 后端

```bash
cd server && cp .env.example .env   # 填 LLM_API_KEY / TOKEN_SECRET / INTERNAL_KEY
docker compose up -d --build
curl http://127.0.0.1:8080/healthz
```

---

## 9. 测试

```bash
flutter analyze                        # 0 issue
flutter test                           # 47 passed
cd server && pytest -q                 # 防泄漏/超纲/JSON/令牌/提示词
```

Dart 侧覆盖：IRT+BKT 校准（含「答错不能涨」「三次提示转讲解」「超纲不推进」「遗忘衰减」）、
一级/二级防泄漏与流式遮蔽、选中类型分类与菜单过滤、内容包解析/校验和/版本门槛/引用告警、
等级聚合与摘要脱敏、SM-2 排期。

---

## 10. 已知边界（诚实清单）

| 项 | 现状 |
|---|---|
| Windows 安装包 | 工程与脚本齐备，CI 在 `windows-latest` 上产出；**本机无 MSVC，`flutter build windows` 直接报 "Unable to find suitable Visual Studio toolchain"**，未本地出包 |
| 本地通知 | 权限已声明、排期逻辑在复习页，但未接 `flutter_local_notifications`（避免引入 desugaring 依赖拖累当前构建）；当前为应用内提醒 |
| 音频（听力） | 尚无音频资产与播放器；`media_kit` 未接入 |
| 数据库加密 | 设置项存在，实际仍是明文 SQLite；需换 SQLCipher 构建 |
| 云同步 | 只有 `sync_queue` 表与导出/清空接口，未做上传 |
| BYOK 密钥 | 存 SharedPreferences 明文（设置页有风险提示）；分发版应换 Keystore/DPAPI |
| 写作（M7）/实验报告（M8） | 未实现 |
| 点词即讲 | 未做（本版按规格走长按/右键选中） |

## 11. 版本

- 客户端 `3.0.0+5`，包名 `com.kadian.app`
- 校准引擎 `1.0.0`，数据库 schema `v2`
- 内容包 `kadian.base@2026.11.1`（18 节点 / 7 簇 / 20 题 / 3 语篇 / 22 词条 / 8 成就）

## 12. 许可

GPL-3.0（沿用项目既有许可）。

---

## 13. 本机实测产物（2026-11-08）

```
dist/
├─ kadian-3.0.0-universal.apk      56.9 MB   通用包（arm64 + armeabi-v7a + x86_64）
├─ kadian-3.0.0-arm64.apk          21.9 MB   大多数手机用这个
├─ kadian-3.0.0-armeabi-v7a.apk    19.6 MB   老设备
├─ kadian-3.0.0.aab                27.7 MB   上架备用
├─ content_pack/kadian.base-2026.11.1.zip  10.6 KB   OTA 内容包
└─ checksums-sha256.txt
```

核验结果：

- 包名 `com.kadian.app`，versionCode `5`，versionName `3.0.0`，minSdk 24，targetSdk 35，compileSdk 35
- 应用名「卡点」；权限仅 `INTERNET` / `POST_NOTIFICATIONS`（外加 Flutter 自动生成的动态广播权限）
- 签名：`CN=Kadian, OU=Mobile, O=Kadian, L=Guangzhou, ST=Guangdong, C=CN`，SHA-256 `50f47fbfe85057fe709b0de94a0fca7505565302dc448b76f1c88d457d9241ee`
- 启动类：dex 中为 `com/kadian/app/MainActivity`（已修掉脚手架的旧包名，否则启动即崩）
- `flutter analyze` 0 issue；`flutter test` 47 passed（含真实内容包、OTA ZIP、端到端闭环与 v1→v2 迁移）
