---
date: 2026-06-21
tags: [agent, tokenization, bpe, wordpiece, unigram, chinese-nlp, interview, day3]
source: AI面试学习系统
status: completed
day: Day3
difficulty: 🟡
related:
  - "[[Day2-Decoding策略与推理优化]]"
  - "[[Day4-KV Cache与vLLM推理加速]]"
  - "[[BPE（字节对编码）]]"
  - "[[Tokenization分词]]"
---

# Day 3 — Tokenization 分词

## 🎯 核心概念

| 概念 | 一句话 | 等级 |
|------|--------|:--:|
| **Tokenization** | 把文本切分成模型能处理的 token 编号序列 | 🟡 |
| **BPE** | 从字符开始，按频率合并最常出现的字符对 | 🟡 |
| **WordPiece** | 类似 BPE，但合并标准是互信息而非频率 | 🟠 |
| **Unigram** | 从大词表删不重要的 token，支持子词正则化 | 🟠 |
| **压缩率** | 一个 token 表示多少汉字，直接决定 API 账单 | 🟡 |
| **OOV** | 词表外的词，通过子词切分处理 | 🟡 |
| **Token 危机** | 「的」等高频字占 token 位的零和博弈 | 🟠 |

## 📐 三种算法对比

| 算法 | 方向 | 合并标准 | 代表模型 | 优点 |
|------|------|---------|---------|------|
| **BPE** | 字符→合并 | 频率最高 | GPT 系列、LLaMA、DeepSeek | 简单高效 |
| **WordPiece** | 字符→合并 | 互信息最大 | BERT | 语义更合理 |
| **Unigram** | 大词表→删除 | 损失增加最小 | SentencePiece | 子词正则化 |

## 🔬 深入要点

### BPE 走查（「拉面很好吃拉面很贵」）
1. 拆成单字符：「拉」「面」「很」「好」「吃」「拉」「面」「很」「贵」
2. 统计相邻频率：「拉面」×2 → 合并
3. 词表加入「拉面」
4. 重新统计 → 继续合并
5. 重复直到目标词表大小

### 中文压缩率对比

| 模型 | 词表大小 | 压缩率（字/token） | 同内容消耗 |
|------|---------|:---:|:---:|
| **Qwen** | ~150K | ✅ 最高 | 最少 |
| **DeepSeek** | ~100K | ✅ 1.0~1.2 | 较少 |
| **GPT-4** | ~100K | ✅ 1.2~1.5 | 适中 |
| **LLaMA** | 32K | ⚠️ 1.5~2.0 | 最多 |

### Token 危机的本质
- 词表是零和博弈：给了「的」一个位置，其他字就少一个
- 「的」出现频率远超英文「the」
- 中文模型天然被「的」吃掉大量概率空间

### LLaMA 中文差的根本原因
- 预训练语料中文 <10%，BPE 合并时自然倾向英文组合
- 中文压缩率差不是模型能力问题，是 tokenizer 的语料分布问题

### 词表工程权衡
- 词表大 → Embedding 矩阵大 → 模型体积大（10万×4096≈4亿参数）
- 词表小 → 模型小但压缩率差 → 序列更长
- LLaMA 选 32K 是故意做小，省 3 亿参数

### ⚠️ 工程注意
- **tokenizer 和模型权重紧密耦合，不能混用**
- 换 tokenizer = 重新训练 Embedding 层 + LM Head

## 🔗 推理链路定位

```
**Tokenization** → Embedding → RoPE → Attention → FFN → LM Head → Decoding → 输出
     ↑ 今天学的：一切推理的起点
```

## ⚡ 面试高频考点

1. BPE 的工作流程？（从字符逐步合并，按频率）
2. BPE 和 WordPiece 的核心区别？（频率 vs 互信息）
3. 中文分词为什么比英文难？（无空格、组词灵活、高频字占位）
4. 怎么判断一个 tokenizer 适不适合你的项目？（看专业术语覆盖率 + 压缩率）
5. tokenizer 能混用吗？（不能，和权重强耦合）

## 📚 专业术语

- `[[Tokenization分词]]` — Tokenization（分词/标记化）
- `[[BPE（字节对编码）]]` — Byte Pair Encoding（字节对编码）
- `[[WordPiece]]` — WordPiece（词片段算法）
- `[[Unigram]]` — Unigram Language Model（一元语言模型分词）
- **OOV** — Out of Vocabulary（词表外词）
- **压缩率** — Compression Ratio（token 中文覆盖率）
