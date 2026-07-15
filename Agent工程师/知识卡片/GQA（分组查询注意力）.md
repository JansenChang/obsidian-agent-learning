---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day1
difficulty: 🟡
aliases: ['Grouped Query Attention', '分组查询注意力']
related: ['[[MHA（多头注意力）]]', '[[MQA（多查询注意力）]]', '[[KV Cache（键值缓存）]]', '[[MLA（多头隐空间注意力）]]']
---
# GQA（分组查询注意力）

> 一句话：MHA 和 MQA 之间的最优折中——质量接近 MHA、成本接近 MQA。LLaMA 2/3、DeepSeek V2/V3、Qwen 2.5 全部采用。

## 核心机制

- **Grouped Query Attention（分组查询注意力）**
- 8 个头分成 4 组，组内共享 K 和 V
- KV Cache：8 份 → **4 份**（省 1/2，不是 1/4！）
- 对比 MQA（1 份，视角单一）保留了多个独立信息源

## 面试话术

> 「GQA 在多头注意力的质量和多查询注意力的效率之间找到了工业界公认的最优平衡点。面试官如果问你为什么今天所有新模型都用 GQA，答案就是三个字：省 KV Cache。」

## 关联概念