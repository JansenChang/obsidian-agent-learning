---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - decoding
day: Day2
difficulty: 🟡
aliases: ['Top-K Sampling', 'Top-P Sampling', 'Nucleus Sampling']
related: ['[[Temperature温度参数]]', '[[Beam Search束搜索]]']
---
# Top-K 与 Top-P 采样

> 一句话：Top-K 固定保留前 K 个最高概率词（硬限制），Top-P 动态累加概率直到达到 P（软限制）。两者通常组合使用。

## Top-K

- 只保留概率最高的 **K** 个词，其余全部归零
- K=40 是常见默认值
- **缺点**：K 固定，分布集中时太大（引入噪声），分布分散时太小（砍掉合理候选）

## Top-P (Nucleus Sampling)

- 从概率最高的词开始累加，直到累积概率 ≥ **P**
- P=0.9 是常见默认值
- **优点**：候选数动态适配，分布集中时只保留 2-3 个，分散时保留 15-20 个

## 执行顺序

```
Top-K（砍尾部噪声）→ Top-P（动态剪裁）→ Temperature（调节分布）→ 采样选词
```

## 关联概念