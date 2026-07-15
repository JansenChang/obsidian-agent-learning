---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day4
difficulty: 🟠
aliases: ['Multi-head Latent Attention', '多头隐空间注意力']
related: ['[[GQA（分组查询注意力）]]', '[[KV Cache（键值缓存）]]', '[[Attention机制]]']
---
# MLA（多头隐空间注意力）

> 一句话：DeepSeek-V2/V3 的核心创新。把 K/V 先压缩到低维隐空间再缓存，KV Cache 缩到 MHA 的 ~1/64。

## 核心思路

- 标准：K 和 V 是 4096 维向量，全量缓存
- **MLA**：下投影压缩到 64 维隐空间 → 缓存 → 计算时上投影还原
- 缓存的是**压缩后的潜在向量**而非全量 K/V

## 对比

| 方案 | 每 token 缓存 | 4K 序列 |
|------|:---:|:---:|
| MHA | 0.5MB | 2GB |
| GQA (8→4组) | 0.125MB | 0.5GB |
| **MLA** | **15KB** | **60MB** |

## 面试话术

> 「GQA 在头维度压缩（多头共享），MLA 在向量维度压缩（降维缓存）。两者思想互补，理论上可以同时使用。」

## 关联概念