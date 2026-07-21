---
created: 2026-07-20
tags: [knowledge-card, agent-interview, agent-core]
day: Day16
difficulty: 🟠
aliases: [Adapter Pattern, 多模型函数调用适配, FC适配层]
related: ["[[OpenAI Function Calling 格式]]", "[[Anthropic Tool Use 格式]]"]
---
# 适配器模式（多模型FC）

> 一句话：通过三层转换（工具定义→响应解析→消息回溯）将 OpenAI、Anthropic、DeepSeek 等不同 LLM 的工具调用格式统一为内部标准，实现模型无关的 Agent 框架。

## 核心机制

### 为什么需要适配层

三家 LLM 的工具调用格式互不兼容：

| | OpenAI | Anthropic | DeepSeek |
|---|--------|-----------|----------|
| 工具定义字段 | `parameters` | `input_schema` | `parameters` |
| 调用返回格式 | `tool_calls` 数组 | content 中 `tool_use` block | `tool_calls` 数组 |
| 结果回传角色 | `role: "tool"` | `role: "user"` | `role: "tool"` |

直接为每个模型写一套代码 → 维护噩梦。适配层封装所有差异。

### 三层转换架构

```
┌─────────────────────────────────────────┐
│          Agent 业务逻辑层                  │
│     （只与内部标准 ToolCall 交互）          │
├─────────────────────────────────────────┤
│  适配层（Adapter Layer）                   │
│                                           │
│  Layer 1: 工具定义转换                     │
│    内部 Schema → OpenAI tools 数组         │
│    内部 Schema → Anthropic tools(input_schema) │
│                                           │
│  Layer 2: 响应解析                         │
│    tool_calls 数组 → 内部 ToolCall 对象     │
│    tool_use block → 内部 ToolCall 对象     │
│                                           │
│  Layer 3: 消息回溯                         │
│    内部结果 → role:tool + tool_call_id     │
│    内部结果 → role:user + tool_result      │
├─────────────────────────────────────────┤
│  OpenAI API    Anthropic API    DeepSeek  │
└─────────────────────────────────────────┘
```

### 内部标准 ToolCall

```typescript
interface ToolCall {
  id: string       // 唯一标识符
  name: string     // 工具名
  arguments: object // 已解析的参数对象
}
```

所有上层逻辑只跟这个标准对象交互，不感知底层是哪个模型。

## 面试要点

1. **三层转换是核心论点**——面试中说"设计多模型 Agent 框架"时直接抛出这个架构
2. **LangChain / LlamaIndex 的参考**——这两个框架底层都用了适配器模式来处理多模型兼容
3. **Neutral Observation 在适配层统一注入**——工具结果回传前统一包裹安全模板，不需要在每个工具里单独写
4. **适配层的额外价值**——不是只做格式转换，还可以做：超时控制、重试策略、日志记录、参数校验

## 关联概念

- Day14 ReAct：适配层封装了 while 循环中的 tool_calls 解析和消息回溯
- Day15：适配层可以在回传前统一注入 Neutral Observation 防注入
- DeepSeek 兼容性：适配层能自动补全 DeepSeek 严格要求的 tool_call_id 回传
