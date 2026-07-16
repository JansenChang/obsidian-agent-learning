---
created: 2026-06-27
tags:
  - glossary
  - agent-interview
  - index
---

# Agent 面试术语表 — 总索引

> 按 Week 组织。每个术语包含：英文全称 + 中文 + 一句话定义 + 首次出现的 Day + 关联知识卡片。

## Week 2 · RAG 检索增强

### Day 8 — RAG 基础流程 & Embedding

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| RAG | Retrieval-Augmented Generation（检索增强生成） | 先从外部知识库检索相关文档，再基于参考资料生成答案 | — |
| Embedding | Embedding（嵌入/向量化） | 把文本转成固定长度向量，语义相近则向量也相近 | — |
| Hallucination | Hallucination（幻觉） | 模型对未知问题倾向于编造看似合理但错误的内容 | — |
| Cosine Similarity | Cosine Similarity（余弦相似度） | 衡量两个向量方向相似度的指标 | — |
| Top-K | — | 检索时取最相似的前 K 个结果 | — |
| ANN | Approximate Nearest Neighbor（近似最近邻搜索） | 用轻微精度损失换巨大速度提升的向量搜索 | — |
| HNSW | Hierarchical Navigable Small World（分层可导航小世界图） | 多层图结构实现快速近似搜索，ANN 主流算法 | — |
| IVF | Inverted File Index（倒排文件索引） | 先聚类分群再群内搜索的 ANN 算法 | — |
| MTEB | Massive Text Embedding Benchmark | 嵌入模型评测基准 | — |
| BGE | BAAI General Embedding | 智源通用嵌入模型，中文表现优秀 | — |
| Lost in the Middle | 中间信息丢失 | LLM 对上下文中间位置关注度天然衰减 | — |

### Day 9 — Chunking 策略 & Hybrid Search

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| Chunking | Chunking（分块） | 将长文档切分为适合检索的段落单元 | — |
| Overlap | Overlap（块重叠） | 相邻块共享部分内容，防止边界信息丢失 | — |
| BM25 | Best Match 25 | 基于词频×逆文档频率的关键词检索算法 | — |
| TF-IDF | Term Frequency-Inverse Document Frequency（词频-逆文档频率） | 衡量词在文档中的重要度，BM25 的前身 | — |
| Sparse Retrieval | Sparse Retrieval（稀疏检索） | 基于关键词匹配的检索方式 | — |
| Dense Retrieval | Dense Retrieval（稠密检索） | 基于 Embedding 向量的语义检索方式 | — |
| Hybrid Search | Hybrid Search（混合搜索） | 稀疏检索 + 稠密检索，互补盲区 | — |
| RRF | Reciprocal Rank Fusion（倒数排名融合） | 混合搜索中融合多路排序结果的算法 | — |
| Semantic Chunking | Semantic Chunking（语义分块） | 基于 Embedding 相似度断崖检测的智能分块 | — |
| RecursiveCharacterTextSplitter | — | LangChain 默认分块器 | — |
|| Saturation | Saturation（饱和效应） | BM25 中词频对相关度的贡献有上限，不会无限增长 | — |

### Day 10 — Re-ranking 与 RAG 优化

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| Re-ranking | 重排序 | 粗筛后再精排一轮，提升排序质量 | Day10 |
| Bi-encoder | 双塔编码器 | 问题和文档各自独立编码，快但不精 | Day10 |
| Cross-encoder | 交叉编码器 | 问题和文档拼接后一起编码，准但慢 | Day10 |
| MRR | Mean Reciprocal Rank（平均倒数排名） | 看最相关文档排第几，1/排名 | Day10 |
| NDCG | Normalized Discounted Cumulative Gain（归一化折损累计增益） | 多级相关性下的排序质量评估 | Day10 |
| **Query Rewrite** | 查询改写 | 模糊问题变清晰查询再检索 | Day10 |

### Day 14 — ReAct Agent 循环手撕

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| **ReAct** | Reasoning + Acting（推理+行动） | Agent 核心循环：Thought→Action→Observation 三步走 | Day14 |
| **Thought** | 思考 | LLM 推理当前状态，决定下一步做什么或调用什么工具 | Day14 |
| **Action** | 行动 | LLM 输出结构化工具调用指令（工具名+参数） | Day14 |
| **Observation** | 观察 | 工具执行结果写回对话，让 LLM 获取反馈信息 | Day14 |
| **Tool Registry** | 工具注册中心 | 管理所有可用工具的 Schema 定义和实现 | Day14 |
| **tool_calls** | 工具调用字段 | OpenAI API 中模型返回的结构化函数调用数据 | Day14 |
| **Function Calling** | 函数调用 | LLM 输出标准化 JSON 格式调用指令的协议 | Day14 |
| **Tool Schema** | 工具描述模式 | 工具名称、描述、参数定义的 JSON Schema 格式 | Day14 |
| **Neutral Observation** | 中立观察包装 | 工具返回结果用安全模板包装，防御间接注入 | Day14 |
| **关键上下文提升** | Key Context Promotion | 把核心信息保持在对话前端，防御 Lost in the Middle | Day14 |
| Query Decomposition | 查询分解 | 复合问题拆成多个子问题分别检索再合并 | Day10 |

### Day 11 — Agentic RAG 与 GraphRAG

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| Agentic RAG | 自主检索增强生成 | LLM 自主决定何时检索、怎么检索、要不要重检 | Day11 |
| Corrective RAG | 纠错式RAG | 检索后 LLM 自评结果质量，不够好就改写重搜 | Day11 |
| Self-RAG | 自评式RAG | 每条 chunk 做 isRel/isSup 自评，合格才纳入 context | Day11 |
| HyDE | Hypothetical Document Embeddings（假想文档嵌入） | 先假想一篇理想答案，拿假想文档去检索 | Day11 |
| Multi-Hop | 多跳检索 | 前一次检索结果作为线索，层层深入再搜 | Day11 |
| GraphRAG | 图式检索增强生成 | 从文档抽取实体关系建知识图谱，按图结构检索 | Day11 |
| Entity Extraction | 实体抽取 | 从文本中识别人物、公司、概念等实体 | Day11 |
| Relation Extraction | 关系抽取 | 识别实体间的语义关系 | Day11 |
| Community Detection | 社区发现 | 在图谱中找到实体关系更密集的子图 | Day11 |
|| isRel | isRelevant（相关性标记） | Self-RAG 中判断 chunk 是否与问题相关的辅助token | Day11 |
|| isSup | isSupported（支撑性标记） | Self-RAG 中判断 chunk 能否支撑答案的辅助token | Day11 |

### Day 12 — 向量数据库选型与生产部署

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| DiskANN | Disk-based Approximate Nearest Neighbor | 把图索引存 SSD 上，适合十亿级以上向量 | Day12 |
| Milvus | — | 最成熟的独立向量数据库，架构重但功能全 | Day12 |
| Qdrant | — | Rust 实现的向量数据库，单机性能好部署简单 | Day12 |
| Chroma | — | pip install 即用，只适合原型验证 | Day12 |
| PGVector | — | PostgreSQL 向量扩展，零额外运维成本 | Day12 |
| Pinecone | — | 纯托管向量数据库，付费 | Day12 |
| Quantization | 量化 | 把 Float32 向量压缩成 Float16/Uint8 省内存 | Day12 |
| nprobe | — | IVF 搜索时搜的组数，越大越准越慢 | Day12 |
| 先写后建 | — | 先用 Flat 模式写入，攒够再建索引 | Day12 |
