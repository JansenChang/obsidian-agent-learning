---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day1
difficulty: 🟠
aliases: ['Multi-Query Attention', '多查询注意力']
related: ['[[MHA（多头注意力）]]', '[[GQA（分组查询注意力）]]', '[[KV Cache（键值缓存）]]']
---
# MQA（多查询注意力）

> 一句话：所有 Query 头共享同一组 K 和 V，KV Cache 缩到 MHA 的 1/8，但表达能力受限。

## 核心机制

- **Multi-Query Attention（多查询注意力）**：Google 早期方案
- 所有头共享同一份 K 和 V，只保留多组 Query
- KV Cache 从 8 份 → 1 份，显存需求极低
- 代价：所有头只能从一个信息源提取内容，表达多样性受限

## 为什么少用

> 太极端了——省显存省得太过，表达能力下降明显。GQA 是在 MHA 和 MQA 之间的折中。

## 关联概念