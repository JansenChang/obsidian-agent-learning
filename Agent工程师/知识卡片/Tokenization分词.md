---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - tokenization
day: Day3
difficulty: 🟡
aliases: ['Tokenization', '分词']
related: ['[[BPE（字节对编码）]]', '[[WordPiece]]', '[[Unigram]]']
---
# Tokenization（分词）

> 一句话：把原始文本转换成模型能处理的 token 编号序列。推理全链路的第一步，压缩率直接决定 API 成本。

## 核心概念

- **词表 (Vocabulary)**：模型认识的所有 token 的集合（3 万~15 万）
- **OOV (Out of Vocabulary)**：词表外的词，通过子词切分处理
- **压缩率**：一个 token 表示多少汉字（越高越好）

## 中文压缩率对比

| 模型 | 压缩率 | 说明 |
|------|:---:|------|
| Qwen | 最高 | 15 万词表，中文优先 |
| DeepSeek | 1.0~1.2 | 10 万词表，中文优化 |
| GPT-4 | 1.2~1.5 | 10 万词表，中英均衡 |
| LLaMA | 1.5~2.0 | 3.2 万词表，中文差 |

## ⚠️ Tokenizer 和模型权重强耦合，不能混用

## 关联概念