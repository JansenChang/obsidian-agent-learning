---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - tokenization
day: Day3
difficulty: 🟡
aliases: ['Byte Pair Encoding', '字节对编码']
related: ['[[Tokenization分词]]', '[[WordPiece]]', '[[Unigram]]']
---
# BPE（字节对编码）

> 一句话：最主流的 Tokenization 算法。从单个字符开始，统计相邻字符对的频率，逐步合并最高频的组合。

## 核心流程

1. 所有文本拆到**最小粒度**（单个 Unicode 字符）
2. 统计所有**相邻字符对**的出现频率
3. 合并**频率最高**的字符对 → 新 token
4. 重复 2-3，直到词表达到目标大小

## 代表模型

GPT 系列、LLaMA、DeepSeek、Qwen 全部使用 BPE。

## 缺点

纯频率驱动，不考虑语义。如「的了」频率很高但合并后无意义。

## 关联概念