---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - decoding
day: Day2
difficulty: 🟡
aliases: ['Greedy Decoding', '贪婪解码']
related: ['[[Temperature温度参数]]', '[[Beam Search束搜索]]']
---
# Greedy Decoding（贪婪解码）

> 一句话：每步都选概率最高的词。简单、确定、快，但缺乏多样性，容易陷入重复循环。

## 核心机制

- 拿到 softmax 输出的概率分布后，直接选概率最高的那个词
- T=0 时等价于贪婪解码

## 缺点

1. **缺乏多样性**：同样输入永远同样输出
2. **容易重复**：「很开心→真的很开心→非常开心…」
3. **局部最优 ≠ 全局最优**

## 什么时候用

- 确定性任务（翻译/代码补全）
- 调试/测试阶段
- 需要复现结果的场景

## 关联概念