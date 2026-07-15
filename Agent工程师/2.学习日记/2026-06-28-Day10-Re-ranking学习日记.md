# Day 10 学习日记 — Re-ranking 与 RAG 优化

## 📅 基本信息
- **学习日期**: 2026-06-28
- **学习主题**: Re-ranking（重排序）+ RAG 缓存架构
- **学习状态**: ✅ 已完成

## 📖 学习内容概要

RAG 检索的完整链路：Bi-encoder 粗筛 → Cross-encoder 精排 → 缓存优化 → Intent Classifier 解决文档概览问题。

## 🧠 关键知识点

| 概念 | 画面记忆 | 一句话 |
|------|---------|--------|
| **Bi-encoder** | 🏢 各自进电话亭打电话 | 快，独立编码，适合全库粗筛 |
| **Cross-encoder** | 🪑 面对面聊天 | 准，拼接编码，适合 Top-50 精排 |
| **Hit Rate** | 🎯 闭眼扔飞镖，扎到就算 | 不关心排第几，有就行 |
| **MRR** | 🎯 看飞镖离靶心多近 | 排越前分越高，1/排名 |
| **四层缓存** | 查询结果 → Embedding → Rerank 分 → LLM 生成 | 逐层拦截 |
| **Intent Classifier** | 先判断用户在问文档还是片段 | 解决「君心似我心讲什么」类问题 |

## 🔗 与之前的知识连接
- **Day 8 Embedding** → Bi-encoder 就是 Embedding 模型，今天补上精排第二步
- **Day 9 Hybrid Search** → 串联关系：Hybrid Search 粗筛 → Re-ranking 精排
- **Day 11 Agentic RAG** → Intent Classifier 就是 Agentic RAG 的雏形

## 📝 学习效果评估
- **理解程度**: ⭐⭐⭐⭐
- **兴趣程度**: ⭐⭐⭐⭐⭐

## 🗓️ 明日计划
- Day 11 Agentic RAG 与 GraphRAG（待学完）
