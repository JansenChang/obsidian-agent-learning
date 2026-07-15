---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day1
difficulty: 🟡
aliases: ['Multi-Head Attention', '多头注意力']
related: ['[[Attention机制]]', '[[MQA（多查询注意力）]]', '[[GQA（分组查询注意力）]]']
---
# MHA（多头注意力）

> 一句话：把 Attention 复制多份（多个头），每个头关注不同的语义子空间，最后拼接融合。

## 核心机制

- **Multi-Head Attention（多头注意力）**：标准 Transformer 的做法
- 8 个头 = 8 组独立的 Q、K、V 权重矩阵
- 每个头计算完自己的 Attention 后，所有头的结果拼接起来
- 好处：不同头可以关注不同粒度（有的关注语法，有的关注语义，有的关注位置关系）

## 代价

- 每个头独立存储 K 和 V → KV Cache 很大（8 头 = 8 份 K/V）
- 这是后续 MQA/GQA 要优化的核心问题

## 关联概念