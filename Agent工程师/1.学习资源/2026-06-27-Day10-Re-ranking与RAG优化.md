---
date: 2026-06-27
tags: [agent, rag, re-ranking, cross-encoder, bi-encoder, mrr, ndcg, interview, day10]
source: AI面试学习系统
audio: "[[Day10-Re-ranking与RAG优化.mp3]]"
status: completed
day: Day10
difficulty: 🟡
related:
  - "[[Day8-RAG基础流程与Embedding]]"
  - "[[Day9-Chunking策略与Hybrid Search]]"
  - "[[Day5-Prompt工程与思维链]]"
  - "[[Day2-Decoding策略与推理优化]]"
  - "[[Day6-Prompt Injection防御与Guardrails]]"
---

# Day 10 — Re-ranking 与 RAG 优化

## 🎯 核心概念

| 概念 | 一句话 | 等级 |
|------|--------|:---:|
| **Re-ranking（重排序）** | 在粗筛结果之上再做一轮精排，提升排序质量 | 🟡 |
| **Bi-encoder（双塔模型）** | 问题和文档各自独立编码成向量再算相似度，速度快但不精 | 🟡 |
| **Cross-encoder（交叉编码器）** | 问题和文档拼接后一起输入模型读一遍再打分，准但慢 | 🟡 |
| **Hit Rate（命中率）** | Top-K 里有没有正确答案？最简单的检索评估指标 | 🟡 |
| **MRR（Mean Reciprocal Rank）** | 正确答案排第几？排越靠前分越高。1/排名 | 🟡 |
| **NDCG** | 多级相关性标注下的排序质量评估 | 🟠 |
| **查询改写（Query Rewrite）** | 先让轻量模型把模糊问题变清晰，再拿去检索 | 🟠 |
| **查询分解（Query Decomposition）** | 把复合问题拆成多个子问题分别检索再合并 | 🟠 |

---

## 🧱 核心架构：两步走

```
用户查询 → Bi-encoder 粗筛（Top-50） → Cross-encoder 精排（Top-5） → LLM 生成
               ↑ 快，毫秒级                  ↑ 准，几百毫秒
```

### Bi-encoder（双塔模型）
- 问题和文档各自独立编码 → 算余弦相似度
- 文档向量可提前算好存向量库 → 快
- **局限：** 看不到问题和文档的交互，分不清语义相近但语境不同的话题

### Cross-encoder（交叉编码器）
- 把问题和文档拼接成一个长串，一起输入模型读一遍再打分
- 精度高，能看到 Bi-encoder 看不到的细微区别
- **局限：** 不能预计算，每对都要实时算 → 慢

**关系：** 不是替代，是串联。Bi-encoder 做粗筛，Cross-encoder 做精排。

---

## 📊 三种评估指标

| 指标 | 衡量什么 | 一句话 |
|------|---------|--------|
| **Hit Rate** | 最相关文档在 Top-K 里吗？ | 不看排序，只看有没有 |
| **MRR** | 最相关文档排第几？ | 排越靠前分越高，1/排名 |
| **NDCG** | 多级相关性下排序好不好 | 有折损的累计增益，归一化到 0-1 |

---

## ⚡ 延迟优化三板斧

| 策略 | 做法 | 效果 |
|------|------|------|
| **缓存** | 常见查询的检索结果直接缓存 | 60-70% 查询零延迟 |
| **分级检索** | 常见→缓存；中等→仅粗筛；复杂→完整链路 | 平均延迟 <100ms |
| **查询改写** | 模糊问题→清晰查询再检索 | 检索质量提升 20-30% |

---

## 🔗 知识连接

| 连接 | 内容 |
|------|------|
| **× Day8 Bi-encoder** | 你 Day 8 学的 Embedding 检索就是 Bi-encoder。今天补上精排第二步 |
| **× Day9 Hybrid Search** | 串行关系：Hybrid Search 粗筛拉回候选 → Re-ranking 精排输出 |
| **× Day6 Prompt Injection** | 查询改写附带去简单注入（不能替代 Guardrails） |
| **× Day2 分级解码** | 共享工程哲学——不同复杂度走不同路径 |

---

## ❓ 面试高频考点

1. **Bi-encoder 和 Cross-encoder 的区别？** → 独立编码 vs 拼接编码，快 vs 准，不能互相替代
2. **RAG 系统怎么评估检索质量？** → Hit Rate + MRR，有多级标注再加 NDCG
3. **加了 Cross-encoder 延迟怎么办？** → 缓存 + 分级检索 + 批量推理
4. **什么是查询改写？为什么有效？** → 模糊→清晰，用户真实查询往往不够精准

---

## 🏷️ 术语表

| 术语 | 全称 | 一句话 |
|------|------|--------|
| Re-ranking | 重排序 | 粗筛后再精排一轮 |
| Bi-encoder | 双塔编码器 | 问题和文档各自独立编码 |
| Cross-encoder | 交叉编码器 | 问题和文档拼接后一起编码 |
| MRR | Mean Reciprocal Rank | 平均倒数排名，看排位好不好 |
| NDCG | Normalized Discounted Cumulative Gain | 归一化折损累计增益 |
| ANN | Approximate Nearest Neighbor | 近似最近邻搜索 |
| RRF | Reciprocal Rank Fusion | 倒数排名融合 |

---

## 📖 明日预告

**Day 11 — Agentic RAG 与 GraphRAG**
- 多轮检索：模型先搜一次 → 根据结果再搜一次 → 越搜越精准
- GraphRAG：把文档之间的实体关系也建进索引
- 从「一次性检索」到「对话式检索」的进化路径
