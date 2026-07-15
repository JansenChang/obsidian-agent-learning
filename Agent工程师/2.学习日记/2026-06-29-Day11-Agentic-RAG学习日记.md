# Day 11 学习日记 — Agentic RAG 与 GraphRAG

## 📅 基本信息
- **学习日期**: 2026-06-29
- **学习主题**: Agentic RAG（Corrective / Self-RAG / HyDE / Multi-Hop）+ GraphRAG
- **学习状态**: ✅ 已完成

## 📖 学习内容概要

从「一次性检索」到「对话式检索」的进化。传统 RAG 搜一次就生成，Agentic RAG 可以搜→评→改→重搜。

## 🧠 关键知识点

### 四种模式

| 模式 | 画面 | 位置 |
|------|------|------|
| **Corrective RAG** | 搜完后自评，不够好就改写重搜 | retrieve 内部 |
| **Self-RAG** | 每条 chunk 过 isRel/isSup 两道门槛 | retrieve 内部 |
| **HyDE** | 查询太短，先生成假想文档再搜 | retrieve 内部 |
| **Multi-Hop** | 搜到新实体→拿实体再搜→层层深入 | 跨多轮 ReAct 循环 |

### 核心认识
- **内部集成 vs 独立工具**：自动化策略（Corrective/Self-RAG/HyDE）封装在 retrieve 内部，不需要 LLM 参与决策；需要 LLM 判断「查询类型」的（如按标题搜）才注册为独立工具
- **查询改写 vs HyDE**：都站在检索之前。查询改写「把话说清楚」，HyDE「给更多语义信号」
- **GraphRAG**：从文档抽实体关系建知识图谱，解决跨文档关联问题，代价是建图成本高

### 工程要点
- 停止策略：固定次数 / 置信度阈值 / 边际收益
- 延迟控制：缓存 + 共享上下文 + 并行搜索
- GraphRAG 建图频率：静态一次性，周更新增量，实时不适合

## 🔗 知识连接
- **Day 10 「君心似我心」问题** → Agentic RAG 的应用场景
- **Day 7 ReAct** → Agentic RAG 是 ReAct 在 RAG 领域的落地
- **Day 10 查询改写** → 变成 Corrective RAG 的内置组件

## 🕸️ GraphRAG 专题笔记
- 核心价值：解决传统 RAG 跨文档关联弱的问题
- 建图成本：GPT-4 处理 100 万 token ≈ $100
- 更新策略：全量重建成本高 → 只用增量/混合方案
- 轻量替代：JSON + NetworkX 在本地跑，不上 Neo4j
- 你的 Obsidian：已有 `[[wikilink]]` 链接图，缺语义关系；llm-wiki skill 的 markdown wiki 模式可复用

## 📝 学习效果评估
- **理解程度**: ⭐⭐⭐⭐
- **兴趣程度**: ⭐⭐⭐⭐⭐

## 🗓️ 明日计划
- Day 12 向量数据库选型与生产部署
