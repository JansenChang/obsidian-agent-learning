---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day4
difficulty: 🟡
aliases: ['PagedAttention', '分页注意力']
related: ['[[KV Cache（键值缓存）]]', '[[Continuous Batching]]', '[[vLLM推理引擎]]']
---
# PagedAttention（分页注意力）

> 一句话：vLLM 的核心创新。把 KV Cache 像操作系统虚拟内存分页一样切成固定大小的 block 管理，显存利用率 20%→90%+。

## 解决的三个问题

1. **内部碎片**：预分配整块按最大长度 → 按需分配，利用率 20-40% → 90%+
2. **外部碎片**：不同请求释放不同大小 → 固定 page 大小，任意组合
3. **共享冗余**：相同 system prompt 重复存 → Copy-on-Write 共享

## 关键机制

- 固定 page 大小（如 16 token/page）
- **Block Table**（块映射表）：记录逻辑→物理映射
- **Copy-on-Write**：多个请求共享相同前缀的物理 page

## 效果

> 显存利用率 20% → 90%+，推理吞吐提升 2-4×

## 关联概念