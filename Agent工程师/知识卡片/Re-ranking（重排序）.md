---
created: 2026-06-28
tags: [knowledge-card, agent-interview, rag]
day: Day10
difficulty: 🟡
aliases: [重排序, Reranking]
related: ["[[Hybrid Search（混合搜索）]]", "[[Bi-Encoder与Cross-Encoder]]", "[[Two-Stage Retrieval（两阶段检索）]]"]
---

# Re-ranking（重排序）

## 一句话定义

检索粗排后用更精准的模型对候选文档集重新打分排序，将最相关的推到前几位喂给 LLM。

## 核心机制

1. 粗排阶段（Bi-Encoder）：用 Embedding + ANN 从百万级文档中召回 Top-20~50
2. 精排阶段（Cross-Encoder）：每对 (query, doc) 拼接后联合编码，输出相关性分数
3. 按新分数重排，取 Top-3~5 送入生成阶段

## 为什么需要

- BM25 只看关键词，Dense 只看语义方向——两者都做不到「这段话真能回答问题吗」
- Re-ranking 用更强的模型在更小的候选池上做精确判断

## 面试要点

- 🟡 必考：检索结果不准怎么办？→ 上 Re-ranking
- 🟡 Bi-Encoder vs Cross-Encoder 的区别和各自角色
- 🟠 BGE-Reranker / Cohere Rerank 的实际使用经验
