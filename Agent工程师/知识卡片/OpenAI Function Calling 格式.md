---
created: 2026-07-20
tags: [knowledge-card, agent-interview, agent-core]
day: Day16
difficulty: 🔴
aliases: [OpenAI Function Calling, function_call, OpenAI工具调用]
related: ["[[Anthropic Tool Use 格式]]", "[[适配器模式（多模型FC）]]"]
---
# OpenAI Function Calling 格式

> 一句话：OpenAI 的函数调用协议——请求通过 `tools` 参数定义工具，响应通过 `tool_calls` 数组承载调用指令，结果通过 `role:tool` 消息回传。

## 核心机制

### 工具定义（请求侧）

```json
{
  "tools": [{
    "type": "function",
    "function": {
      "name": "get_weather",
      "description": "查询指定城市的天气",
      "parameters": {
        "type": "object",
        "properties": {
          "city": {"type": "string", "description": "城市名"}
        },
        "required": ["city"]
      }
    }
  }]
}
```

### 工具调用返回（响应侧）

```json
{
  "choices": [{
    "message": {
      "tool_calls": [{
        "id": "call_abc123",
        "type": "function",
        "function": {
          "name": "get_weather",
          "arguments": "{\"city\":\"Beijing\"}"
        }
      }]
    }
  }]
}
```

⚠️ **关键坑**：`arguments` 是 **JSON 字符串**，不是 JSON 对象。必须先 `JSON.parse()` 才能拿到参数。

### 工具结果回传

```json
{
  "role": "tool",
  "tool_call_id": "call_abc123",
  "content": "北京今天晴，25°C"
}
```

三者缺一不可——若遗漏 `tool_call_id`，API 直接返回 400 错误。

### `tool_choice` 参数

| 模式 | 含义 |
|------|------|
| `auto`（默认） | 模型自行判断是否需要调用工具 |
| `none` | 强制不调用任何工具（普通对话模式） |
| `required` | 强制必须调用至少一个工具 |

Agent 场景下 `auto` 最常用——LLM 需自行判断何时结束循环。

### Structured Outputs（Strict 模式）

开启后模型保证输出 JSON 完全符合 Schema。但要求：
- 所有字段必须定义 `additionalProperties: false`
- 嵌套深度有限制
- 复杂 Schema 可能被拒绝

## 面试要点

1. **arguments 是字符串**——这是面试中区分"看过文档"和"真写过代码"的关键细节
2. **tool_call_id 回传**——消息必须包含 `tool_call_id` 且值与 LLM 返回的原值一致
3. **Structured Outputs 限制**——strict 模式保证合规但有 Schema 子集约束，展示 API 细节理解
4. **消息顺序**——`tool` 消息必须紧跟 `assistant` 消息之后，中间不能夹其他角色

## 关联概念

- Day14 ReAct：FC 是 ReAct 循环中 Action 环节的工程实现
- Day15：tool description 在 GPT 中与 name 同等重要
- 适配器模式：将 OpenAI 格式统一为内部标准 ToolCall 对象
