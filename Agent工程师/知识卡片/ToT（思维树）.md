---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - prompt
day: Day5
difficulty: 🟠
aliases: ['Tree-of-Thought', '思维树']
related: ['[[CoT（思维链）]]', '[[ReAct（推理-行动循环）]]']
---
# ToT（思维树）

> 一句话：CoT 是单链推理，ToT 是多分支树搜索。每步生成多个候选，用搜索策略探索，可回溯。

## 与 CoT 对比

| 维度 | CoT | ToT |
|------|:---:|:---:|
| 结构 | 单链 | 多分支树 |
| 回溯 | ❌ 不行 | ✅ 可以 |
| 计算量 | 1× | 10-100× |
| 适用 | 常规推理 | 需要探索的任务（24点/创意） |

## 关联概念