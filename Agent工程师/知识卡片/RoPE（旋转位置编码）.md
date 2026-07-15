---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day1
difficulty: 🟡
aliases: ['Rotary Position Embedding', '旋转位置编码']
related: ['[[Attention机制]]', '[[GQA（分组查询注意力）]]', '[[KV Cache（键值缓存）]]']
---
# RoPE（旋转位置编码）

> 一句话：通过旋转矩阵把位置信息融入 Q 和 K，编码相对距离，外推性好，无额外参数。

## 核心机制

- **Rotary Position Embedding（旋转位置编码）**
- 不是给 token 加一个位置向量，而是把 Q 和 K 在向量空间里**旋转**
- 旋转的角度与 token 位置成正比
- 两个 token 的旋转角度差 = 它们的相对位置
- Q·K 点积自动包含了位置信息

## 为什么好

| 对比 | 绝对位置编码 | RoPE |
|------|:---:|:---:|
| 额外参数 | 有 | **无**（数学变换） |
| 外推性 | 差（训 512 就只能 512） | **好**（可外推到更长） |
| 相对距离感知 | 间接 | **直接**（旋转角差） |

## 关联概念