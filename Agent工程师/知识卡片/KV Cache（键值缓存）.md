---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day4
difficulty: 🟡
aliases: ['Key-Value Cache', '键值缓存']
related: ['[[Attention机制]]', '[[GQA（分组查询注意力）]]', '[[PagedAttention（分页注意力）]]', '[[MLA（多头隐空间注意力）]]']
---
# KV Cache（键值缓存）

> 一句话：用线性增长的存储代价，换掉二次方增长的计算代价。把每步算出的 K/V 缓存复用，避免重复计算。

## 核心机制

- **Prefill**：一次性算完整个输入的 K/V，计算密集型
- **Decode**：每步只算新 token 的 K/V，从缓存读老的，内存带宽密集型

## 显存量级

| 序列长度 | LLaMA-7B KV Cache |
|:---:|------|
| 4K | ~2GB |
| 32K | ~16GB |
| 128K | ~64GB |

## ⚠️ 面试陷阱

> KV Cache **存储**是 O(N) 线性的，不是 O(N²)！二次方增长的是 Attention **计算量**。

## 关联概念