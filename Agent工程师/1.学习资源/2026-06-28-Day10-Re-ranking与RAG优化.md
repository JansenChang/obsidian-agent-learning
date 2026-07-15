---
date: 2026-06-28
tags: [agent, rag, re-ranking, cross-encoder, bi-encoder, reranker, interview, day10]
source: AI面试学习系统
status: completed
day: Day10
difficulty: 🟡
related:
  - "[[2026-06-25-Day8-RAG基础流程与Embedding]]"
  - "[[2026-06-27-Day9-Chunking策略与Hybrid Search]]"
  - "[[Day11-Agentic RAG与GraphRAG]]"
---

# Day 10 — Re-ranking 与 RAG 优化

## 🎯 核心概念

| 概念 | 一句话 | 等级 |
|------|--------|:---:|
| **Re-ranking（重排序）** | 检索粗排后用精确模型对候选集二次排序，提升 Top-K 精准度 | 🟡 |
| **Bi-Encoder（双塔编码器）** | Query 和 Document 独立编码后算相似度，快但不精细 | 🟡 |
| **Cross-Encoder（交叉编码器）** | Query + Document 拼接后一起编码，逐对打分，慢但精准 | 🟡 |
| **Two-Stage Retrieval（两阶段检索）** | 粗排（高召回）→ 精排（高精度），工业标准范式 | 🟡 |
| **BGE-Reranker** | 开源中文重排序模型，BAAI 出品，与 BGE Embedding 配套 | 🟡 |
| **Cohere Rerank** | API 调用式重排序服务，多语言支持，开箱即用 | 🟡 |
| **HyDE**（Hypothetical Document Embedding） | 先让 LLM 编假答案，用假答案向量检索——「答案长什么样」比「问题长什么样」更准 | 🟠 |
| **Query Rewriting** | 用户问得不清楚时，用 LLM 改写查询再检索 | 🟠 |
| **Small-to-Big** | 检索用小块（精准），喂 LLM 用大块（上下文完整） | 🟠 |
| **Self-RAG** | 模型检索后自行判断「这段有用吗」「需要再搜吗」 | 🟢 |

---

## 🧱 为什么需要 Re-ranking

Hybrid Search 解决了召回率（该找到的都找到了），但精准排序仍有问题：

- **BM25 只看关键词** → 「memory」命中 RAM、GPU 显存、Agent Memory，全拉回来
- **Dense Embedding 只看语义方向** → 语义相近 ≠ 能回答问题

> **Re-ranking 的核心价值**：在粗排 Top-20~50 的候选池上，用更精准（也更慢）的模型重新打分排序。

---

## 🏗️ Bi-Encoder vs Cross-Encoder

这是理解 Re-ranking 最关键的一对概念：

| 维度 | Bi-Encoder | Cross-Encoder |
|------|-----------|---------------|
| **编码方式** | Query 和 Doc 独立编码 | Query + Doc 拼接后联合编码 |
| **交互** | 编码时互相不知道对方存在 | 编码时同时看到两端 |
| **速度** | 快（向量可预计算缓存） | 慢（每对都要跑一次模型） |
| **精度** | 粗 | 精 |
| **角色** | 检索（粗排） | Re-ranking（精排） |
| **类比** | 简历筛选（只看简历打分） | 面试（针对岗位逐条评估） |

> 一句话：Bi-Encoder 判断「他们像不像」，Cross-Encoder 判断「这段话真能回答问题吗」。

---

## 🔄 Pipeline 全景

```
用户问题
  │
  ▼
检索阶段（Bi-Encoder，快）
  ├── Dense：问题向量 → ANN → Top-50
  └── Sparse：BM25 → Top-50
  │
  ▼
融合（RRF）→ Top-20
  │
  ▼
Re-ranking（Cross-Encoder，精）  ← Day 10
  (query, doc) 逐对打分 → 重排 → Top-5
  │
  ▼
送入 LLM 生成
```

---

## 🛠️ BGE-Reranker 调用示例

```python
from FlagEmbedding import FlagReranker
reranker = FlagReranker('BAAI/bge-reranker-v2-m3')

pairs = [[query, doc] for doc in top_20_docs]
scores = reranker.compute_score(pairs)

ranked = sorted(zip(scores, top_20_docs), reverse=True)
top_5 = [doc for _, doc in ranked[:5]]
```

---

## 📊 RAG 优化全景图

| 阶段 | 技术 | Day | 解决什么 |
|------|------|:---:|------|
| 索引 | Chunking（递归/语义） | Day 9 | 块语义完整性 |
| 索引 | Embedding（BGE/E5） | Day 8 | 文本→向量 |
| 检索-粗排 | Hybrid Search（Dense+BM25+RRF） | Day 9 | 召回率 |
| 检索-精排 | **Re-ranking（Cross-Encoder）** | **Day 10** | 精准度 |
| 生成 | Prompt 模板 + 源标注 | Day 8 | 答案可信度 |

### 其他 RAG 优化技术

| 技术 | 做什么 | 等级 |
|------|--------|:---:|
| Query Rewriting | LLM 改写模糊查询 | 🟠 |
| HyDE | 先编假答案，用假答案向量检索 | 🟠 |
| Multi-Query | 同问题生成多变体各自检索合并 | 🟠 |
| Small-to-Big | 检索小块，喂 LLM 大块 | 🟠 |
| Self-RAG | 模型自判检索质量，决定是否再搜 | 🟢 |

---

## 🔗 知识连接

### Re-ranking × Day 9 Hybrid Search

Hybrid Search 负责「找全」，Re-ranking 负责「找对」——两者互补，不是替代关系。RRF 融合后取 Top-20，然后 Re-ranking 压到 Top-5。

### Re-ranking × Day 8 Embedding

Bi-Encoder 本质就是 Embedding 模型的双塔架构。Cross-Encoder 是另一种范式——不做向量化，直接给相关性打分。

### Re-ranking × Day 4 KV Cache

Re-ranking 的计算开销（每个 query-doc 对跑一次模型）是工程挑战。优化方向：
- 候选池缩小到 Top-20~50（太多没意义）
- 模型量化（int8）
- 批量推理（一次跑多对）

---

## 💬 面试要点

- 🟡 **Re-ranking 是什么？为什么需要？** → 粗排精度不够，精排补刀
- 🟡 **Bi-Encoder vs Cross-Encoder 区别？** → 独立编码 vs 联合编码，速度 vs 精度
- 🟡 **Two-Stage Retrieval 范式？** → 粗排高召回 + 精排高精度
- 🟠 **用过哪些 Re-ranker？** → BGE-Reranker / Cohere Rerank
- 🟠 **RAG 还有哪些优化手段？** → HyDE / Query Rewriting / Small-to-Big
