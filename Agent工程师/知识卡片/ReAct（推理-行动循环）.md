---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - agent-core
day: Day5
difficulty: 🟡
aliases: ['ReAct', 'Reasoning and Acting']
related: ['[[CoT（思维链）]]', '[[ToT（思维树）]]']
---
# ReAct（推理-行动循环）

> 一句话：CoT + 工具调用 = Agent 核心模式。Thought → Action → Observation 循环。

## 核心循环

```
Thought（思考）: 我需要查天气
    ↓
Action（行动）: 调用天气 API
    ↓
Observation（观察）: 返回 "北京 25°C"
    ↓
Thought: 根据温度给出穿衣建议
    ↓
Action: 输出最终回答
```

## 与 CoT 的关系

> CoT 是 ReAct 的**子组件**（推理部分）。CoT 只会思考，ReAct 会思考+行动。

## 关联概念