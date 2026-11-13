# 卡点 LLM 代理（Kadian Proxy）

只做四件事：**鉴权、限流、审计、转发**。等级、证据、校准、成就全部在客户端本地算，代理不存、不碰、不参与。

```
客户端 ──HTTPS──> 本服务 ──HTTPS──> OpenAI 兼容上游（DeepSeek / OpenAI / 自建）
                     │
                     └─ 审计 sqlite（只记元数据）
```

## 为什么需要它

| 问题 | 这里的答案 |
|---|---|
| 客户端不能存 Provider Key | Key 只在服务端环境变量 |
| 单设备被刷爆额度 | 每令牌每小时限流 |
| 提示词被改坏、答案被泄露 | 角色提示词集中在服务端；一二级提示强制过滤 |
| 出问题查不到 | 审计表可查（不含作答原文） |
| 等级数据外泄 | 请求里只有局部等级摘要，用完即弃 |

## 快速启动

```bash
cp .env.example .env          # 填 LLM_API_KEY / TOKEN_SECRET / INTERNAL_KEY
docker compose up -d --build
curl http://127.0.0.1:8080/healthz
```

本地裸跑：

```bash
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8080
```

## 接口

| 方法 | 路径 | 说明 | 鉴权 |
|---|---|---|---|
| GET | `/healthz` | 健康检查（含上游是否配置） | 无 |
| POST | `/v1/auth/anonymous` | 用 device_id 换设备令牌 | 无（可关） |
| POST | `/v1/hints` | 攻略，SSE 流式 | 设备令牌 |
| POST | `/v1/diagnose/next` | 诊断选题（给候选让模型排序） | 设备令牌 |
| POST | `/v1/items/generate` | 出题（内部权限） | 设备令牌 + `X-Internal-Key` |
| POST | `/v1/attribute` | 错因归类，返回 JSON | 设备令牌 |
| POST | `/v1/achievements/explain` | 成就解读，返回 JSON | 设备令牌 |
| GET | `/v1/admin/audit` | 审计查询 | `X-Internal-Key` |

### 换令牌

```bash
curl -s -X POST http://127.0.0.1:8080/v1/auth/anonymous \
  -H 'Content-Type: application/json' \
  -d '{"device_id":"demo-device-001"}'
```

### 攻略（SSE）

```bash
curl -N -X POST http://127.0.0.1:8080/v1/hints \
  -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d '{
    "request_id":"r1","item_id":"ja.i.te1","node_id":"ja.g.te",
    "selected_text":"磨いて","selection_kind":"phrase","intent":"grammar",
    "hint_level":1,"hint_request_count":1,"subject":"ja",
    "learner_level_summary":{"overall":{"level":2}},
    "question":"毎朝、歯を＿＿から、顔を洗います。",
    "options":["磨く","磨いて","磨いた","磨き"],
    "answer_keywords":["磨いて"],"answer_label":"磨いて"
  }'
```

返回：

```
data: {"type":"meta","level":1,"remaining":59}
data: {"type":"delta","delta":"先看空格后面是「から」⋯"}
data: {"type":"done","done":true,"level":1,"filtered":false}
```

**一、二级提示不边流边出**：服务端先攒齐整段，按句过滤掉含答案原文的句子，再分片发出。客户端还会再过滤一次（双重执行）。

## 合规与隐私

- `selected_text` 默认**不落库**：审计只存长度与 sha256 前 16 位。排障时才开 `LOG_ANSWER_TEXT=true`。
- 审计记录：时间、令牌指纹、端点、题目 id、提示层级、是否过滤、超纲命中数、耗时。
- 超纲检查：低等级学习者的输出里若出现 N1/N2 语法术语或 C2 学术词，计入 `scope_warnings`（提示词里已强制降阶，这里是监控）。
- 代理不接收、不存储任何账号身份；`device_id` 由客户端本地生成。

## 部署建议

1. 前面挂 Nginx/Caddy 做 TLS，`proxy_buffering off`（SSE 必需）。
2. `TOKEN_SECRET`、`INTERNAL_KEY` 用密钥管理注入，不要写进镜像。
3. 多实例时把 `SlidingWindowLimiter` 换成 Redis 实现（接口不变），审计换成集中式日志。
4. 定期 `GET /v1/admin/audit?limit=200` 抽查 `filtered` 比例；一级提示泄露率验收线是 <1%。

## 测试

```bash
pip install -r requirements-dev.txt
pytest -q
```

覆盖：防泄漏过滤、超纲判定、JSON 校验、令牌签发/验签/过期/篡改、提示词层级规则。
