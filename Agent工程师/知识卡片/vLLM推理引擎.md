---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day4
difficulty: 🟡
aliases: ['vLLM']
related: ['[[PagedAttention（分页注意力）]]', '[[Continuous Batching]]', '[[KV Cache（键值缓存）]]']
---
# vLLM 推理引擎

> 一句话：基于 PagedAttention 的高吞吐 LLM 推理引擎，已成为业界部署标准。

## 核心创新

1. **PagedAttention**：分页管理 KV Cache
2. **Continuous Batching**：不等整批，动态调度
3. **Prefix Caching**：共享相同前缀的 K/V

## 对比 HuggingFace

| 维度 | HuggingFace | vLLM |
|------|:---:|:---:|
| 显存利用率 | 20-40% | **90%+** |
| 并发能力 | 低 | **2-4×** |
| 部署复杂度 | 低 | 中 |

## 关联概念