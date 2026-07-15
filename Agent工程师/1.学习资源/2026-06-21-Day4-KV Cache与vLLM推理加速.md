---
date: 2026-06-21
tags: [agent, kv-cache, vllm, paged-attention, continuous-batching, speculative-decoding, flash-attention, interview, day4]
source: AI面试学习系统
audio: "[[Day4-KV Cache与vLLM推理加速.mp3]]"
status: completed
day: Day4
difficulty: 🟡
related:
  - "[[Day1-Transformer与Attention机制]]"
  - "[[Day3-Tokenization分词]]"
  - "[[KV Cache（键值缓存）]]"
  - "[[PagedAttention（分页注意力）]]"
  - "[[MLA（多头隐空间注意力）]]"
---

# Day 4 — KV Cache 与 vLLM 推理加速

## 🎯 核心概念

| 概念 | 一句话 | 等级 |
|------|--------|:--:|
| **KV Cache** | 缓存前面算过的 K/V，避免每步重算 | 🟡 |
| **Prefill/Decode** | Prefill=一次性算完输入，Decode=逐 token 生成 | 🟡 |
| **PagedAttention** | 把 KV Cache 像 OS 内存分页一样管理 | 🟡 |
| **Continuous Batching** | 不等整批完成，谁完谁退、空位即补 | 🟠 |
| **Speculative Decoding** | 小模型猜候选 → 大模型一次性验证 | 🟠 |
| **FlashAttention** | 分块在 SRAM 内完成，提速 2-3× | 🟡 |
| **MLA** | DeepSeek 把 K/V 压缩到低维隐空间再缓存 | 🟠 |

## 🔄 KV Cache 本质

> **用线性增长的存储代价，换掉二次方增长的计算代价。**

### 两个阶段

| 阶段 | 做什么 | 瓶颈 | GPU 利用率 |
|------|--------|------|:---:|
| **Prefill** | 一次性算完整个输入的 K/V | 算力（compute-bound） | 高 |
| **Decode** | 每步只算一个新 token 的 K/V | 显存带宽（memory-bound） | 低 |

### KV Cache 计算量级
- 无缓存：每步重算全部 Attention → **O(N²)** 总计算量
- 有缓存：每步只算一个新 token → 计算量恒定，瓶颈变内存带宽

### ⚠️ 面试陷阱
> KV Cache 的**存储**是 O(N) 线性的，不是 O(N²)。二次方增长的是 Attention **计算量**。面试官常用这个当陷阱。

## 📐 KV Cache 大小速算

- 单个 token 缓存 ≈ `2 × d_model × n_layers × (KV头数/总头数) × 2 bytes`
- LLaMA-7B @ 4K 序列：KV Cache ≈ **2GB**（模型权重才 13GB）
- 128K 序列：KV Cache ≈ **64GB**（A100 80GB 快满了！）

## 🧩 PagedAttention（vLLM 核心）

### 解决的三个问题
1. **内部碎片**：传统预分配按最大长度，利用率 20-40% → PagedAttention 按需分配，90%+
2. **外部碎片**：不同请求释放大小不一，零散无法用 → 固定 page 大小，任意组合
3. **共享冗余**：相同 system prompt 重复存 → Copy-on-Write 共享物理 page

### 核心类比
> 传统做法：一次划一块连续 2000 座区域，你只坐 200 个，1800 空着别人不能坐。
> PagedAttention：来一个人就在空小格安插，分散在各处，系统有映射表记住。

### 效果
- 显存利用率 20-40% → **90%+**
- 推理吞吐 **2-4×** 提升
- vLLM 已成为业界推理部署标准

## ⚙️ 其他推理优化

| 技术 | 作用 | 一句话 |
|------|------|--------|
| **Continuous Batching** | GPU 永不空等 | 谁答完谁退、空位立即补新请求 |
| **Prefix Caching** | 复用前缀 KV | 相同 prompt 开头的 K/V 共享 |
| **Speculative Decoding** | 小模型猜 N 个，大模型一次验证 | 精度无损，加速 1.5-3× |
| **FlashAttention** | 分块在 SRAM 算完再写回 | 提速 2-3×，长上下文使能技术 |

## 🔗 知识全景：推理请求全过程

```
Tokenizer → Embedding → RoPE → Attention(带 KV Cache) → FFN → LM Head → Decoding → 输出
                                  ↑         ↑
                             KV Cache     FlashAttention
                            （省计算）     （省显存带宽）
```

## ⚡ 面试高频考点

1. KV Cache 为什么能加速？（避免重复计算，O(N²)→常数）
2. Prefill 和 Decode 阶段的区别？（计算密集 vs 内存密集）
3. PagedAttention 解决哪三个问题？（内部碎片/外部碎片/共享冗余）
4. KV Cache 存储是 O(N) 还是 O(N²)？（O(N) 线性的！）
5. vLLM 吞吐提升的核心原因？（PagedAttention + Continuous Batching）

## 📚 专业术语

- `[[KV Cache（键值缓存）]]` — Key-Value Cache（键值缓存）
- `[[PagedAttention（分页注意力）]]` — PagedAttention（分页注意力）
- `[[Continuous Batching]]` — Continuous Batching（持续批处理）
- `[[Speculative Decoding]]` — Speculative Decoding（推测式解码）
- `[[FlashAttention]]` — FlashAttention（闪存注意力）
- `[[MLA（多头隐空间注意力）]]` — Multi-head Latent Attention（多头隐空间注意力）
