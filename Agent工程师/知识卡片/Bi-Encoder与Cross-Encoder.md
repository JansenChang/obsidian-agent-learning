---
created: 2026-06-28
tags: [knowledge-card, agent-interview, rag, embedding]
day: Day10
difficulty: 🟡
aliases: [Bi-Encoder, Cross-Encoder, 双塔编码器, 交叉编码器]
related: ["[[Re-ranking（重排序）]]", "[[Embedding（嵌入-向量化）]]", "[[Two-Stage Retrieval（两阶段检索）]]"]
---

# Bi-Encoder 与 Cross-Encoder

## 一句话定义

两种编码器架构。Bi-Encoder 独立编码 Query 和 Document 后算相似度（快但粗）；Cross-Encoder 将 Query 和 Document 拼接后联合编码打分（慢但精）。

## 核心对比

| 维度 | Bi-Encoder | Cross-Encoder |
|------|-----------|---------------|
| 编码方式 | Q 和 D 独立编码 | Q + D 拼接联合编码 |
| 交互 | 互相不知道对方存在 | 同时看到两端 |
| 速度 | 快（向量可缓存） | 慢（每对跑一次模型） |
| 角色 | 检索（粗排） | Re-ranking（精排） |
| 类比 | 简历筛选 | 针对性面试 |

## 为什么这样设计

- 不能让 Cross-Encoder 直接检索百万级文档——太慢
- 不能让 Bi-Encoder 做最终排序——太粗
- 两阶段配合是最优工程折中

## 面试要点

- 🟡 必考：两者区别、各自适用场景
- 🟡 为什么检索和重排用不同架构
