---
date: 2026-06-25
tags: [agent, rag, embedding, vector-db, retrieval, llm, interview, day8]
source: AI面试学习系统
audio: "[[Day8-RAG基础流程与Embedding预习.mp3]]"
script: "[[Day8-RAG基础流程与Embedding预习文稿.md]]"
status: completed
day: Day8
difficulty: 🟡
related:
  - "[[Day1-Transformer与Attention机制]]"
  - "[[Day4-KV Cache与vLLM推理加速]]"
  - "[[Day6-Prompt Injection防御与Guardrails]]"
  - "[[2026-02-28 记忆系统]]"
---

# Day 8 — RAG 基础流程与 Embedding

## 🎯 核心概念

| 概念                                             | 一句话                                 | 等级  |
| ---------------------------------------------- | ----------------------------------- | :-: |
| **RAG**（Retrieval-Augmented Generation，检索增强生成） | 不让模型凭空回答，先从外部知识库检索相关信息，再基于参考资料生成答案  | 🟡  |
| **幻觉（Hallucination）**                          | 模型在面对未知问题时倾向于编造看似合理但错误的内容           | 🟡  |
| **Chunking（分块）**                               | 将长文档切成适当大小的段落，是 RAG 索引的第一步          | 🟡  |
| **Embedding（嵌入/向量化）**                          | 把文本转成固定长度向量，语义相近的文本向量距离也相近          | 🟡  |
| **ANN**（Approximate Nearest Neighbor，近似最近邻搜索）  | 用轻微精度损失换取巨大速度提升的向量搜索算法              | 🟠  |
| **Top-K**                                      | 检索时取最相似的前 K 个文档块（通常 3~5）            | 🟡  |
| **Cosine Similarity（余弦相似度）**                   | 衡量两个向量方向相似度的指标，RAG 检索的核心度量          | 🟡  |
| **Lost in the Middle（迷失在中间）**                  | LLM 对上下文中间位置关注度天然衰减，RAG 通过缩小检索范围来规避 | 🟠  |

## 🧱 为什么需要 RAG

三大驱动力：

1. **知识截止日期** — 模型训练完成后新产生的知识，模型不知道 → 幻觉
2. **私有数据不可见** — 企业文档、客服 FAQ 等内部数据模型没学过
3. **参数化知识不可靠** — 训练是把知识压缩进参数，压缩必有损失

> **RAG 核心思想**：把闭卷考试变成开卷考试。模型不需要记住所有知识，只需知道怎么查资料。

## 🔄 RAG 三段式 Pipeline

```
索引（Indexing）  →  检索（Retrieval）  →  生成（Generation）
文档→分块→向量化    问题→向量化→搜Top-K    问题+文档→拼Prompt→LLM
```

**三阶段环环相扣**，任一环节崩溃则全链路崩塌：
- 索引差 → 检索不准
- 检索不准 → 模型被误导
- 模型被误导 → 幻觉答案

### 第一阶段：索引构建

| 步骤            | 要点                                                |
| ------------- | ------------------------------------------------- |
| **Chunking**  | 块太大（噪声多）vs 块太小（上下文断裂）。512~1024 token 是常见起点        |
| **Embedding** | BGE（中文强）/ E5（通用）/ Jina（支持 8K token）/ OpenAI（闭源开箱） |
| **Vector DB** | Pinecone/Weaviate/Milvus/Qdrant/Chroma/PGVector   |

### 第二阶段：检索

- **Top-K = 3~5**：太小漏信息，太大引入噪声
- **相似度阈值**：检索得分低于阈值则不答（"不答"比"硬答"更重要）
- **ANN**：HNSW/IVF 等算法，O(log n) 替代 O(n) 精确搜索
- **⚠️ 必须用同一个 Embedding 模型**处理问题和文档（向量空间不兼容）

### 第三阶段：生成

Prompt 模板三要素：
1. **角色设定** — "基于参考资料回答，不是自由聊天"
2. **源标注** — [1][2] 编号，支持溯源
3. **退出机制** — "不知道就说不知道，不要编造"（最后防线）

## 🔗 知识连接

### Embedding vs Attention

| 维度 | Embedding | Attention |
|------|-----------|-----------|
| 时机 | 离线预计算 | 推理时动态算 |
| 存储 | 向量数据库 | KV Cache |
| 复杂度 | O(1) 查一次 | O(n²) 每个 token |
| 用途 | 跨文档相似度 | 序列内 token 关系 |

### RAG vs KV Cache

| 维度 | RAG | KV Cache |
|------|-----|----------|
| 解决什么 | 知识更新成本 | 重复计算成本 |
| 用什么换 | 磁盘换知识广度 | 显存换推理速度 |
| 共同哲学 | **用存储换计算** | |

### RAG vs 微调 vs 长上下文

| 方案 | 适用场景 | 代价 |
|------|---------|------|
| **RAG** | 知识库大且频繁更新、需要溯源性 | 检索链路复杂度 |
| **微调** | 领域有独特语言模式、数据质量高 | 更新慢、成本大 |
| **长上下文** | 少量长文档、低频查询 | 按 token 付费，慢 |

### RAG × Prompt Injection

RAG 天然是间接注入的最佳目标——检索内容直接拼入 Prompt。**输入过滤必须在检索后、Prompt 拼接前执行。**

## ❓ 面试三问

1. **RAG 为什么不能替代长上下文？** → 三个理由：成本、速度、Lost in the Middle
2. **Embedding 模型怎么选？** → 看 MTEB 排名 + 最大输入长度 + 向量维度 trade-off
3. **RAG 系统延迟大头在哪？** → Embedding API 网络延迟 + 向量数据库检索（PGVector 百万级可达秒级）+ LLM 推理

## 🏷️ 术语表

| 术语 | 全称 | 一句话 |
|------|------|--------|
| RAG | Retrieval-Augmented Generation | 检索增强生成：先查资料再回答 |
| ANN | Approximate Nearest Neighbor | 近似最近邻搜索：用精度换速度 |
| HNSW | Hierarchical Navigable Small World | 分层可导航小世界图：ANN 算法之一 |
| MTEB | Massive Text Embedding Benchmark | 嵌入模型评测基准 |
| BGE | BAAI General Embedding | 智源通用嵌入模型，中文表现优秀 |
| TF-IDF | Term Frequency-Inverse Document Frequency | 词频-逆文档频率：传统关键词权重算法 |

## 📖 明日预告

**Day 9 — Chunking 策略与 Hybrid Search**
- 固定长度 vs 语义分块 vs 递归分块
- 块重叠（Overlap）防止边界信息丢失
- 稀疏检索（BM25）+ 稠密检索（Embedding）= 混合搜索
- 为什么单一语义搜索有盲区
