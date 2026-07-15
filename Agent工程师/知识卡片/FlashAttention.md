---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day1
difficulty: 🟡
aliases: ['Flash Attention', '闪存注意力']
related: ['[[Attention机制]]', '[[KV Cache（键值缓存）]]', '[[GQA（分组查询注意力）]]']
---
# FlashAttention

> 一句话：把 Attention 计算拆成小块在芯片 SRAM 缓存里完成，减少 HBM 读写，提速 2-3 倍，是长上下文的使能技术。

## 核心机制

**问题：** GPU 计算单元很快，但显存（HBM）带宽跟不上。频繁读写中间矩阵 → GPU 空等。

**解决：** 
1. **Tiling（分块）**：把大矩阵切成小块，每块在 SRAM 里算完
2. **Online Softmax**：不用等所有块算完再做归一化，边算边维护统计量
3. **Recomputation（重算）**：反向传播时不存中间矩阵，需要时重新算（用计算换显存）

## 和 KV Cache 的关系

> FlashAttention 和 KV Cache 是互补的：
> - KV Cache 解决 Key/Value **不需要重复计算**
> - FlashAttention 解决算 Attention 时**少读写显存**
> - 两者叠加效果最好

## 关联概念