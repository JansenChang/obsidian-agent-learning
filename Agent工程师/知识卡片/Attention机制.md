---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day1
difficulty: 🟡
aliases: ['Self-Attention', '自注意力机制']
related: ['[[MHA（多头注意力）]]', '[[GQA（分组查询注意力）]]', '[[RoPE（旋转位置编码）]]', '[[FlashAttention]]']
---
# Attention 机制

> 一句话：注意力机制让模型在处理每个词时，动态关注上下文中的所有相关词，而不是孤立地理解。

## 核心机制

**五步流程：**
1. 输入序列乘以三个权重矩阵 → 生成 **Q（Query）、K（Key）、V（Value）**
2. **Q×K 点积** → 算出每个词和所有其他词的相关性分数（注意力分数）
3. **÷√d_k 缩放** → 把方差拉回 1，防止 Softmax 变成 one-hot（梯度消失）
4. **Softmax 归一化** → 转成权重概率分布
5. **加权求和 V** → 融合上下文语义，得到每个位置的最终表示

**类比：** 就像你在百度搜索——Query 是你的搜索词，Key 是页面标题，系统通过 Q 和 K 的匹配度给你最相关的结果，Value 就是结果页面的内容。

## 面试要点

- Attention 的 Q、K、V 分别是什么角色？（Q=查询，K=被匹配，V=实际内容）
- 为什么需要 ÷√d_k？（防止点积方差过大导致梯度消失）
- Self-Attention 和 Cross-Attention 的区别？（Self 是序列内部，Cross 是序列之间）
- Attention 的计算复杂度？（O(N²)，序列长度平方）

## 关联概念