# 验收对照（跨平台补充规格 §10）

图例：**已验证** = 本机有可复核证据；**待设备** = 代码就绪、需真机/真包验证。

| # | 验收项 | 实现位置 | 状态 | 证据 |
|---|---|---|---|---|
| 1 | Android 长按 / Windows 右键选中均弹出意图菜单，菜单项按类型过滤 | `features/practice/practice_page.dart`（`SelectionArea.contextMenuBuilder`）、`selection_menu.dart`、`core/selection/selection_intent.dart` | 待设备 | `test/hint_guard_test.dart` 覆盖分类与过滤规则（8 例）；菜单渲染需真机点验 |
| 2 | 一级提示答案泄露率 <1%（代理 + 客户端双重过滤抽检） | `server/app/guards.py` 的 `filter_answer_leak`；客户端 `HintLeakGuard.check` + `maskLive` | 已验证（逻辑层） | 代理 10 条断言自检通过；Dart 6 例；`GET /v1/admin/audit` 的 `filtered` 比例即抽检口径 |
| 3 | 同题 ≥3 次请求被拦截并进入讲解模式；assisted 与 independent 无串账 | `PracticeService.submitAttempt` + `CalibrationEngine.apply`（`explainModeHintThreshold`）、`node_states.assisted/explain_attempts`、成就 `independentOnly` | 已验证 | `test/calibration_test.dart`「三次提示 → 讲解模式、θ 不推进」「看过提示 → 有效分 0.28、不计独立」 |
| 4 | 断网时做题/复习/等级/成就可用；攻略给出离线提示 | `AppServices.bootstrap` 全本地装配；`HintService.offlineEvent` / `ProxyException(offline)` | 待设备 | 代码路径无网络依赖；离线文案与 `served_offline` 落库可查 |
| 5 | 安装包可独立安装；MSIX 签名有效；APK 签名一致可覆盖升级 | `tools/release.ps1`、`android/app/build.gradle` 签名配置、`msix_config` | 部分 | APK/AAB 已出包：`com.kadian.app` / versionCode 5 / versionName 3.0.0 / minSdk 24 / targetSdk 35 / 应用名「卡点」；签名证书 SHA-256 `50f47fbf…41ee`（release keystore）；dex 内启动类为 `com/kadian/app/MainActivity`。MSIX 待 CI（本机 `flutter build windows` 报 "Unable to find suitable Visual Studio toolchain"） |
| 6 | 内容包 OTA 失败可回滚；最低客户端版本校验生效 | `core/content_pack/loader.dart`：`installZip` 临时目录 + 原子改名 + 指针；`compareSemver`；`rollback()` | 已验证 | `test/content_pack_test.dart`「校验和不匹配」「最低客户端版本不足」「引用不存在的节点只告警」 |
| 7 | 本地数据库迁移可从前一版升级不丢证据 | `core/db/database.dart`：`_upgradeV1ToV2` 只 `createTable` / `addColumn`，先探测表名列名 | 已验证 | `test/db_integration_test.dart` 手工造 v1 库（user_version=1）→ 打开后旧证据仍在，`hint_events`/`attempts` 等新表可用，`effective_score` / `cluster_id` 等新列补齐 |
| 8 | 后端代理不持久化等级数据；审计日志可查 | `server/app/main.py` 请求内用完即弃；`audit.py` 只存元数据（text 默认不落库，存长度 + sha256 前缀）；`GET /v1/admin/audit` | 已验证 | `server/tests/test_guards.py`、`test_auth.py`；审计字段表见 `server/README.md` |

## 单学科实例验收（产品修正案 §8）

| # | 验收项 | 实现位置 | 状态 | 证据 |
|---|---|---|---|---|
| 1 | 英语档案下调用日语节点报错 `subject_mismatch` | `PracticeService.ensureOwnsNode` / `requireSameSubject` | 已验证 | `test/subject_isolation_test.dart`「英语档案下调用日语节点报 subject_mismatch」 |
| 2 | 日语档案下看不到英语题 | 内容包按学科分包（`assets/content_pack/<subject>/`）+ 选题防御过滤 | 已验证 | 同上「日语档案下看不到英语题，反之亦然」（题目/节点/词条三层断言） |
| 3 | 等级摘要与成就墙只含当前学科 | `LevelAggregator` 吃本学科包；`AchievementEngine.definitions` 按 `subjectId` 过滤；`summaryForLlm` 带 `scope: <subject>-only` | 已验证 | 同上「等级摘要与成就墙只含当前学科」 |
| 4 | 跨学科前置回退被禁止 | `prerequisiteFallback` 先 `ensureOwnsNode`，图谱链再按 `ownsNode` 过滤 | 已验证 | 同上「跨学科前置回退被禁止」 |
| 5 | legacy_mixed 不计入独立成功率与核心成就 | 迁移归档不进学科库；`evidenceStats` 与成就 SQL 双重排除 `source=legacy_mixed` | 已验证 | `test/legacy_migration_test.dart`（拆分/重置/幂等 3 例）+ 同上「legacy_mixed 不进独立统计」 |
| 6 | 旧混合档案按 subject 拆分或可一键重置 | `core/db/legacy_migration.dart`：`LegacyMode.split` / `LegacyMode.reset` | 已验证 | 迁移测试：ja/en 各归各家、孤儿行进归档且 `independent=false`、旧库改名防重复、reset 零导入 |

## 补充：规格里逐条对应的实现点

| 规格条目 | 实现 |
|---|---|
| §2 本地优先架构 | 等级/选题/结算在 `core/`；网络出口只有 `core/llm/proxy_client.dart` |
| §2 BYOK 可选 | `ProxyConfig.byokEnabled` + 设置页风险提示；BYOK 直连走 `/chat/completions` |
| §3.2 新增表 | `hint_events` / `content_pack_versions` / `sync_queue` 全建；另有 `attempts`、`daily_stats` |
| §3.3 内容包格式 | `manifest/graph/items/vocab/achievements/calibration_params`，支持 `items/`、`vocab/` 分片目录 |
| §4 模块划分 | `lib/app·core·features` 与规格目录一一对应 |
| §5.1 Android 13+ 双菜单 | 用 `contextMenuBuilder` 完全接管，不叠加系统工具栏 |
| §5.2 Windows 右键/键盘 | 同一个 `SelectionArea`；桌面端另加右侧检查器 |
| §5.3 统一行为 | 逐级解锁、写 `hint_events`、`assisted=true`、≥3 次转讲解、一级前端过滤 |
| §6.1 代理职责 | 令牌鉴权、滑动窗口限流、sqlite 审计、角色提示词、SSE 转发、JSON 校验、超纲标记 |
| §6.2 接口 | `/v1/hints`(SSE) `/v1/diagnose/next` `/v1/items/generate` `/v1/attribute` `/v1/achievements/explain` + `/v1/auth/anonymous` `/v1/admin/audit` |
| §6.3 离线降级 | 攻略明确离线提示；其余功能本地照常 |
| §7.1 Android 打包 | minSdk 24 / targetSdk 35 / 仅 INTERNET+POST_NOTIFICATIONS / release keystore / APK+AAB |
| §7.2 Windows 打包 | `msix_config` + `dart run msix:create`；另出免安装 ZIP |
| §7.3 版本与更新 | 客户端版本与内容包版本分离；`minAppVersion` 强校验；MSIX 自动更新路径 |
| §7.4 CI/CD | `.github/workflows/build.yml`：测试 / Android / Windows / 后端镜像 / 内容包 |
| §8 安全与隐私 | Key 不下发；DB 加密项预留；审计脱敏；导出/清空；防泄漏双执行；BYOK 风险提示 |
| §11 风险止损 | Windows 文本选择降级方案已在代码中体现为「右侧检查器 + 浮动菜单」，不阻塞发布 |

## 未达标 / 未实现（不遮掩）

1. **Windows 本机未出包**：本机无 Visual Studio C++ 工作负载，`flutter build windows` 无法执行。工程、脚本、CI 均已就绪。
2. **本地通知未接插件**：`POST_NOTIFICATIONS` 已声明，复习页有到期队列，但未集成 `flutter_local_notifications`，因此没有系统级提醒。
3. **音频未接入**：听力题目前是文字脚本，无音频资产与播放器。
4. **SQLCipher 未接入**：设置项只是偏好开关。
5. **云同步未做**：只有 `sync_queue` 表。
6. **M7 写作 / M8 实验报告**：未实现，接口位（`/v1/attribute`、rubric 字段）留空。
7. **点词即讲**：未实现，本版按规格以长按/右键选中为主。
