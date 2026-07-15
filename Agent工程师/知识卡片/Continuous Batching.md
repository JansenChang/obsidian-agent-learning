---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day4
difficulty: 🟠
aliases: ['Continuous Batching', '持续批处理']
related: ['[[PagedAttention（分页注意力）]]', '[[vLLM推理引擎]]']
---
# Continuous Batching（持续批处理）

> 一句话：不等整批完成，谁答完谁退、空位立即补新请求。GPU 永不空等。

## 传统批处理的问题

- 8 个请求一批，A 50 token 半秒完成，B 2000 token 要几十秒
- A 完成后 GPU 干等 B，A 的显存也占着不释放

## Continuous Batching 解决

- 同一个 iteration 内，不同请求可处于不同阶段
- 谁完成立刻释放，空位立即补新请求
- GPU 利用率始终维持高位

## 与 PagedAttention 的关系

> PagedAttention 提供灵活内存管理，Continuous Batching 提供高效请求调度。两者配合使用。

## 关联概念