---
created: 2026-07-22
tags: [knowledge-card, agent-interview, agent-core, context-engineering]
day: Day18
difficulty: 🔴
aliases: [Select Strategy, 上下文选择策略, Context Selection]
related: ["[[Context Engineering四大策略]]", "[[Compress策略]]", "[[三层记忆架构]]", "[[Two-Stage Retrieval（两阶段检索）]]"]
---

# Select 策略

> 一句话：当上下文窗口逼近上限（通常 > 70% token 用量），用三维加权排名（时间 × 重要性 × 相关性）决定哪些消息保留、哪些淘汰，是 Context Engineering 流水线的第一步。

## 核心机制

### 三维加权排名公式

```
Score(message) = w1 × TimeScore + w2 × ImportanceScore + w3 × RelevanceScore

其中：
  TimeScore      = 1 / (当前轮次 - 消息轮次 + 1)   ← 越近越高
  ImportanceScore = 来自 Memory 系统的重要性标记    ← 越重要越高
  RelevanceScore  = Embedding 相似度(消息, 当前Query) ← 越相关越高
  
  默认权重: w1=0.3, w2=0.4, w3=0.3（重要性优先）
```

### 排序与淘汰流程

```
1. 所有消息计算三维加权分数
2. 按分数降序排列
3. System Prompt + 最新用户消息 → 不可淘汰（硬保留）
4. 从最低分开始标记淘汰，直到 token 预算回到 50-60%
5. 淘汰消息送入 Compress 流水线
```

### 三维的核心价值

| 维度 | 解决什么问题 | 数据来源 |
|------|------------|---------|
| **时间** | 太旧的消息可能已过时或不再相关 | 消息序号/时间戳 |
| **重要性** | 关键决策/用户偏好不能丢 | Day17 长期记忆系统的 Importance Score |
| **相关性** | 与当前问题无关的历史是噪音 | Embedding 相似度计算 |

## 面试要点

1. **为什么是三维不是一维？**——单一时间维度会丢弃"旧但重要"的信息，单一重要性维度会在长对话中把信息密度拉满导致窗口仍然不足，三维权衡才能兼顾新旧与价值
2. **Importance 维度来自哪里？**——从 Day17 Memory 系统继承，长期记忆中标记为高重要性的信息在这一轮 Select 中也获得高权重
3. **与 Day13 Lost in the Middle 的关系**——Select 的三维加权是"Lost in the Middle"问题的直接工程解法：不只看位置（时间），还看语义相关性
4. **70% 阈值为什么不是 90%？**——预留 30% 缓冲空间给 LLM 生成输出 token，且留给 Compress 步骤处理时间
5. **Select 是流水线第一步的原因**——先决定淘汰谁，再压缩，避免对所有内容做压缩（浪费计算资源）

## 关联概念

- Compress策略：Select 标记淘汰的内容进入 Compress 流水线
- 三层记忆架构 / Day17 Memory：Importance 维度的权重来源
- Two-Stage Retrieval：Select 的 Relevance 计算借用 Embedding 检索思路
- Day13 Lost in the Middle：Select 三维加权是直接工程解法
