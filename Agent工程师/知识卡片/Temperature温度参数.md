---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - decoding
day: Day2
difficulty: 🟡
aliases: ['Temperature', '温度参数']
related: ['[[Top-K与Top-P采样]]', '[[Beam Search束搜索]]', '[[Greedy Decoding]]']
---
# Temperature（温度参数）

> 一句话：控制概率分布的陡峭程度。来自统计物理的玻尔兹曼分布——温度越高，分布越平，模型越"冒险"。

## 核心机制

| T 值 | 效果 | 场景 |
|:---:|------|------|
| **0** | 确定性算法（永远选概率最高的） | 调试/测试/合规审计 |
| **0.2~0.3** | 很保守，几乎不冒险 | 代码生成/数学推理 |
| **0.7** | 适度创造力 | ChatGPT 默认值 |
| **0.8~0.95** | 愿意冒险 | 创意写作 |
| **>1.5** | 开始胡说八道 | — |

## 面试话术

> 「Temperature 是 softmax 之前在 logits 上除以的一个标量。T=1 不做任何改变；T<1 让分布更尖锐，高概率词被放大；T>1 让分布更平坦，低概率词也有了机会。」

## 关联概念