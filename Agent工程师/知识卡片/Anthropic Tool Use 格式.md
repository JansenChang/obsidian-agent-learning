---
created: 2026-07-20
tags: [knowledge-card, agent-interview, agent-core]
day: Day16
difficulty: 🔴
aliases: [Anthropic Tool Use, tool_use block, Claude工具调用]
related: ["[[OpenAI Function Calling 格式]]", "[[适配器模式（多模型FC）]]"]
---
# Anthropic Tool Use 格式

> 一句话：Anthropic 的工具调用机制——工具定义用 `input_schema`（非 `parameters`），调用指令以 `tool_use` block 嵌入 `content` 数组，结果通过 `tool_result` block 以 **user 角色**回传。

## 核心机制

### 工具定义（请求侧）

```json
{
  "tools": [{
    "name": "get_weather",
    "description": "查询指定城市的天气",
    "input_schema": {
      "type": "object",
      "properties": {
        "city": {"type": "string", "description": "城市名"}
      },
      "required": ["city"]
    }
  }]
}
```

⚠️ 字段名是 **`input_schema`**，不是 OpenAI 的 `parameters`——代码里写死 `parameters` 就会找不到。

### 工具调用返回（响应侧）

```json
{
  "content": [
    {"type": "text", "text": "我来查一下天气。"},
    {
      "type": "tool_use",
      "id": "toolu_abc123",
      "name": "get_weather",
      "input": {"city": "Beijing"}
    }
  ]
}
```

✅ **友好点**：`input` 已经是 JSON 对象，不需要 `JSON.parse()`。

### 工具结果回传

```json
{
  "role": "user",
  "content": [{
    "type": "tool_result",
    "tool_use_id": "toolu_abc123",
    "content": "北京今天晴，25°C"
  }]
}
```

🔴 **最大坑**：工具结果用 **`role: "user"`** 回传，不是 `role: "tool"`！这是让 OpenAI 开发者崩溃的头号差异。

### 消息角色交替规则

Anthropic 强制要求 `user` 和 `assistant` 严格交替：

```
user → assistant(tool_use) → user(tool_result) → assistant → ...
```

连续两条同角色消息会直接报错。

## 面试要点

1. **`input_schema` vs `parameters`**——字段名差异是适配层必须处理的转换
2. **工具结果用 user 角色**——这是 Anthropic 与 OpenAI 最本质的格式差异，面试高频考点
3. **input 已是 JSON 对象**——比 OpenAI 的 JSON 字符串更友好，但适配层需统一
4. **严格交替规则**——user/assistant 不能连续出现，工具调用被视为 assistant 的一部分
5. **多 tool_use 在 content 中**——需要遍历 content 数组识别所有 `type: "tool_use"` 的 block

## 关联概念

- 适配器模式：将 tool_use block 解析为内部标准 ToolCall{id, name, arguments}
- Day15：Claude 对 tool description 依赖度最高，写清楚提升明显
- 并行工具调用：Anthropic 原生支持同一响应中多个 tool_use block
