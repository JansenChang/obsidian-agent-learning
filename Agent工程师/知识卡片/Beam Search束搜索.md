---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - decoding
day: Day2
difficulty: 🟠
aliases: ['Beam Search', '束搜索']
related: ['[[Temperature温度参数]]', '[[Top-K与Top-P采样]]']
---
# Beam Search（束搜索）

> 一句话：同时维护 N 条候选路径，每步从所有路径扩展后整体排序，选全局最优序列。

## 核心机制

- 贪婪解码：每步选概率最高的**一个**词 → 局部最优陷阱
- Beam Search：每步保留概率最高的 **N 条完整路径** → 全局最优
- N 越大，效果越好但越慢（N 倍计算量）

## 适用场景

| 适合 | 不适合 |
|------|--------|
| 机器翻译 | 开放对话（容易重复） |
| 语音识别 | 创意写作（需要多样性） |
| 文本摘要 | 聊天机器人 |

## 关联概念