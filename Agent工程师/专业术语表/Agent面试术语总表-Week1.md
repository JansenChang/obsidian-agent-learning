---
created: 2026-06-24
tags:
  - glossary
  - agent-interview
  - index
---

# Agent 面试术语表 — 总索引

> 按 Week 1 学习顺序排列。每个术语包含：英文全称 + 中文 + 一句话定义 + 首次出现的 Day + 关联知识卡片。

## Week 1 · LLM 推理全链路

### Day 1 — Transformer & Attention

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| Attention | Attention Mechanism（注意力机制） | 让模型动态关注上下文中的相关词 | [[Attention机制]] |
| MHA | Multi-Head Attention（多头注意力） | 多个独立注意力头关注不同语义子空间 | [[MHA（多头注意力）]] |
| MQA | Multi-Query Attention（多查询注意力） | 所有头共享 K/V，极省显存但表达受限 | [[MQA（多查询注意力）]] |
| GQA | Grouped Query Attention（分组查询注意力） | MHA 和 MQA 之间最优折中 | [[GQA（分组查询注意力）]] |
| RoPE | Rotary Position Embedding（旋转位置编码） | 通过旋转矩阵融入位置信息 | [[RoPE（旋转位置编码）]] |
| FlashAttention | FlashAttention（闪存注意力） | 分块在 SRAM 算完，提速 2-3× | [[FlashAttention]] |
| Lost in the Middle | 中间信息丢失 | 模型对 Prompt 中间位置关注度最低 | — |

### Day 2 — Decoding 策略

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| Greedy Decoding | Greedy Decoding（贪婪解码） | 每步选概率最高的词 | [[Greedy Decoding]] |
| Temperature | Temperature（温度参数） | 控制概率分布陡峭度 | [[Temperature温度参数]] |
| Top-K | Top-K Sampling | 固定保留前 K 个候选词 | [[Top-K与Top-P采样]] |
| Top-P | Nucleus Sampling（核采样） | 动态累加概率到 P 为止 | [[Top-K与Top-P采样]] |
| Beam Search | Beam Search（束搜索） | 同时维护 N 条路径选全局最优 | [[Beam Search束搜索]] |

### Day 3 — Tokenization

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| BPE | Byte Pair Encoding（字节对编码） | 按频率合并字符对 | [[BPE（字节对编码）]] |
| WordPiece | WordPiece（词片段算法） | 按互信息合并 | [[WordPiece]] |
| Unigram | Unigram Language Model | 从大词表删除不重要 token | [[Unigram]] |
| Tokenization | Tokenization（分词/标记化） | 文本→token 编号序列 | [[Tokenization分词]] |
| OOV | Out of Vocabulary（词表外词） | 词表不包含的词/字 | — |
| 压缩率 | Compression Ratio | 一个 token 表示多少汉字 | — |

### Day 4 — KV Cache & 推理加速

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| KV Cache | Key-Value Cache（键值缓存） | 缓存前面算过的 K/V | [[KV Cache（键值缓存）]] |
| Prefill/Decode | Prefill / Decode（预填充/解码阶段） | 输入一次性算完 vs 逐 token 生成 | — |
| PagedAttention | PagedAttention（分页注意力） | 分页管理 KV Cache | [[PagedAttention（分页注意力）]] |
| vLLM | vLLM（推理引擎） | 基于 PagedAttention 的高吞吐引擎 | [[vLLM推理引擎]] |
| Continuous Batching | Continuous Batching（持续批处理） | 不等整批，谁完谁退 | [[Continuous Batching]] |
| Speculative Decoding | Speculative Decoding（推测式解码） | 小模型猜，大模型验 | [[Speculative Decoding]] |
| MLA | Multi-head Latent Attention（多头隐空间注意力） | K/V 压缩到低维再缓存 | [[MLA（多头隐空间注意力）]] |

### Day 5 — Prompt 工程

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| CoT | Chain-of-Thought（思维链） | 让模型先写推理过程再答 | [[CoT（思维链）]] |
| Zero-shot CoT | Zero-shot Chain-of-Thought | 「让我们一步步思考」 | [[CoT（思维链）]] |
| Few-shot CoT | Few-shot Chain-of-Thought | 给示例引导推理格式 | [[CoT（思维链）]] |
| Self-Consistency | Self-Consistency（自一致性） | 多次采样投票选最一致 | [[CoT（思维链）]] |
| ReAct | Reasoning and Acting（推理-行动循环） | Thought → Action → Observation | [[ReAct（推理-行动循环）]] |
| ToT | Tree-of-Thought（思维树） | 多分支树搜索 | [[ToT（思维树）]] |

### Day 6 — Prompt Injection 安全

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| Prompt Injection | Prompt Injection（提示注入） | 嵌入恶意指令覆盖系统指令 | [[Prompt Injection（提示注入）]] |
| Direct Injection | Direct Prompt Injection（直接注入） | 用户直接输入恶意指令 | [[Prompt Injection（提示注入）]] |
| Indirect Injection | Indirect Prompt Injection（间接注入） | 恶意指令藏在外部分数据 | [[Prompt Injection（提示注入）]] |
| Jailbreaking | Jailbreaking（越狱攻击） | 角色扮演绕过安全限制 | — |
| Prompt Leaking | Prompt Leaking（提示泄露） | 诱导模型输出系统指令 | — |
| Guardrails | Guardrails（LLM 护栏） | 代码级硬规则安全边界 | [[Guardrails（LLM护栏）]] |
| Defense in Depth | Defense in Depth（纵深防御） | 多层叠加安全策略 | [[Defense-in-Depth（纵深防御）]] |
| Red Teaming | Red Teaming（红队测试） | 模拟攻击者系统测试安全 | — |
