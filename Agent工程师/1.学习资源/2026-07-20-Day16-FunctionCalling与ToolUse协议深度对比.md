---
date: 2026-07-20
tags: [agent, function-calling, tool-use, openai, anthropic, deepseek, interview, day16]
source: AI面试学习系统
audio: "[[Day16-FunctionCalling与ToolUse协议深度对比.mp3]]"
status: completed
day: Day16
difficulty: 🔴
related:
  - "[[2026-07-16-Day14-从零手写ReAct Agent循环]]"
  - "[[2026-07-20-Day15-ReAct原理深挖与面试穿透]]"
  - "[[2026-06-23-Day6-Prompt Injection防御]]"
---

# Day 16 — Function Calling / Tool Use 协议深度对比

## 🎯 核心概念

| 概念 | 一句话 | 等级 |
|------|--------|:---:|
| **OpenAI tool_calls** | choices[0].message.tool_calls 数组，arguments 是 JSON 字符串 | 🔴 |
| **Anthropic tool_use** | content 数组中的 type:tool_use block，input 是 JSON 对象 | 🔴 |
| **DeepSeek 兼容性** | OpenAI 格式但更严格——tool_call_id 必须回传，消息角色不可偏离 | 🔴 |
| **适配器模式** | 三层转换（定义→解析→回溯），统一内部格式 | 🟠 |
| **工具注册三模式** | 装饰器 / 配置文件 / 动态注册 | 🟠 |
| **并行工具调用** | 多 tool_calls 同时执行，线程池+结果合并 | 🔴 |
| **指数退避** | 重试间隔翻倍（1s→2s→4s）的容错策略 | 🟠 |
| **幂等性** | 同样参数调两次结果一致——查询类天然幂等，写操作需设计 | 🟠 |

---

## 🔄 三家格式对比

### OpenAI

```
请求 tools 参数 → 每个工具 {type:"function", function:{name,description,parameters}}
响应 tool_calls 数组 → [{id, type:"function", function:{name, arguments: "JSON字符串"}}]
回传 role:"tool" + tool_call_id + content
```

### Anthropic

```
请求 tools 参数 → 每个工具 {name, description, input_schema}
响应 content 数组 → [..., {type:"tool_use", id, name, input: {JSON对象}}]
回传 role:"user" + content:[{type:"tool_result", tool_use_id, content}]
```

### DeepSeek

```
兼容 OpenAI 格式，但：
- tool_call_id 必须回传（不传→400）
- role 必须为 "tool"（不能是 user/assistant）
- 多 tool 消息的 tool_call_id 必须与 LLM 返回一一对应
- deepseek-chat（标准）vs deepseek-reasoner（带 CoT 输出）
```

---

## 🔌 适配层三层转换

| 层 | 方向 | 职责 |
|----|------|------|
| **工具定义转换** | 内部 → 模型 | 统一 Schema → OpenAI tools 或 Anthropic tools |
| **响应解析** | 模型 → 内部 | tool_calls / tool_use → 统一 ToolCall{id, name, arguments} |
| **消息回溯** | 内部 → 模型 | 统一结果 → role:tool 或 tool_result block |

---

## 🛠 工具注册三种模式

| 模式 | 做法 | 优点 | 缺点 |
|------|------|------|------|
| **装饰器** | @tool 装饰函数 | 直观，Python 原生 | 语言绑定 |
| **配置文件** | JSON/YAML 定义 | 逻辑分离，非技术人员可编辑 | 易与代码脱节 |
| **动态注册** | 运行时 add/remove | 灵活 | 安全风险大，需 HITL |

---

## ⚡ 并行工具调用

```
LLM 返回 [tool_1, tool_2, tool_3]
  → 线程池并行执行
  → 结果按 tool_call_id 排序合并
  → 一次性发回 LLM
```

**部分失败处理：** 成功的结果正常回传 + 失败的标记错误信息 → LLM 自决

---

## 🛡️ 容错设计

| 策略 | 说明 |
|------|------|
| **超时** | 每个工具设置 timeout，超时→标记失败 |
| **指数退避** | 1s → 2s → 4s → 最大次数 |
| **幂等性** | 读操作天然幂等，写操作需要去重 |
| **全或无** | 并行批次任一失败全部作废（最保守） |
| **部分成功** | 成功能回传 + 失败带错误（最常用） |

---

## 🐛 DeepSeek 400 错误排查

按优先级依次检查：
1. role 拼写是否正确（"tool" 而非 "Tool"/"function"）
2. tool_call_id 是否存在且与 LLM 返回一致
3. 消息顺序是否正确（tool 消息紧跟 assistant 之后）
4. 多 tool_call 的 id 是否一一匹配

---

## 🔗 知识连接

| 连接 | 内容 |
|------|------|
| **× Day14 ReAct** | FC 是 Action 层的工程实现，适配层封装了 while 循环中的解析逻辑 |
| **× Day15 ReAct 原理** | tool description 在不同模型中的影响力不同：Claude 依赖度最高，DeepSeek 更重 name 直观性 |
| **× Day6 间接注入** | Neutral Observation 模板应统一写在适配层而非每个工具里 |

---

## 🎯 明天预告

Day17 — Agent Memory 系统设计：短期记忆/长期记忆/工作记忆的架构与工程实现
