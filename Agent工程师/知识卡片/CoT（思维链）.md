---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - prompt
day: Day5
difficulty: 🟡
aliases: ['Chain-of-Thought', '思维链']
related: ['[[ReAct（推理-行动循环）]]', '[[ToT（思维树）]]', '[[Prompt Engineering]]']
---
# CoT（思维链）

> 一句话：让模型在给出答案之前先写出推理过程。2022 年 Google 提出，最强大的单 Prompt 技术。

## 三种变体

| 变体 | 做法 | 优点 | 代价 |
|------|------|:---:|:---:|
| **Zero-shot CoT** | 加「让我们一步步思考」 | 零成本，直接触发 | 效果不稳定 |
| **Few-shot CoT** | 给 1-3 个完整示例 | 引导格式+推理模式 | 需精选示例 |
| **Self-Consistency** | 多次采样→投票选最一致 | 准确率飙升(70%→90%+) | **10 倍**计算量 |

## 为什么有效

1. 拆成简单步骤 → 分而治之
2. Attention 路径聚焦到推理链上
3. 推理过程可验证可调试

## 关联概念