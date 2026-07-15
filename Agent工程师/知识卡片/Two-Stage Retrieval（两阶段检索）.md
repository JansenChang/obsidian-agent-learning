---
created: 2026-06-28
tags: [knowledge-card, agent-interview, rag]
day: Day10
difficulty: 🟡
aliases: [两阶段检索, 粗排精排, Two-Stage Retrieval]
related: ["[[Re-ranking（重排序）]]", "[[Bi-Encoder与Cross-Encoder]]", "[[RAG（检索增强生成）]]"]
---

# Two-Stage Retrieval（两阶段检索）

## 一句话定义

将检索过程拆为粗排和精排两个阶段：粗排用快速模型从海量文档中高召回，精排用精确模型在候选池中选最优。

## 两阶段分工

| 阶段 | 模型 | 目标 | 候选规模 | 速度 |
|------|------|------|----------|------|
| 粗排 | Bi-Encoder / BM25 | 高召回 | 百万级 → Top-20~50 | 快 |
| 精排 | Cross-Encoder | 高精度 | Top-20~50 → Top-3~5 | 慢 |

## 为什么这样设计

- 全量 Cross-Encoder 扫描百万级文档不可行（延迟爆炸）
- 全量 Bi-Encoder 定 Top-3 精度不够（容易漏掉真正答案）
- 两阶段取各自优势：用快的筛，用准的排

## 面试要点

- 🟡 解释两阶段检索的设计动机和工程权衡
- 🟡 粗排用什么？精排用什么？
