# 专业术语表

本目录收录 Agent 工程师面试学习过程中遇到的英文专业术语，按首字母排序。每个条目包含：英文全称、中文翻译、一句话定义。

---

## C

**Continuous Batching**
- 中文：持续批处理
- 定义：不等一批请求全部完成才处理下一批，而是谁先完成就释放资源立即塞入新请求，GPU 始终满负荷

## F

**FlashAttention**
- 中文：闪速注意力
- 定义：将 Attention 计算拆成小块在 GPU 芯片内部 SRAM 缓存中完成，减少显存读写次数，加速 2-3 倍

## G

**GQA (Grouped Query Attention)**
- 中文：分组查询注意力
- 定义：多个 Query 头共享同一组 Key/Value，缩小 KV Cache 到 MHA 的四分之一

## K

**KV Cache (Key-Value Cache)**
- 中文：键值缓存
- 定义：缓存已生成的 token 的 Key 和 Value 向量，避免每步重新计算，用线性存储换平方级计算

## M

**MHA (Multi-Head Attention)**
- 中文：多头注意力
- 定义：每个 Attention Head 拥有独立的 QKV，原始 Transformer 设计

**MLA (Multi-head Latent Attention)**
- 中文：多头潜在注意力
- 定义：DeepSeek 提出的架构，将 Key/Value 压缩到低维隐空间再缓存，进一步缩小 KV Cache

**MoE (Mixture of Experts)**
- 中文：混合专家模型
- 定义：有大量参数但每次只激活一部分，与 MLA 配合可大幅降低推理成本

**MQA (Multi-Query Attention)**
- 中文：多查询注意力
- 定义：所有 Query 头共享同一组 Key/Value，KV Cache 缩小到 MHA 的三十二分之一

## P

**PagedAttention**
- 中文：分页注意力
- 定义：把 KV Cache 像操作系统分页一样切成固定大小的 block，按需分配，显存利用率从 30% 提升到 90%+

**Prefix Caching**
- 中文：前缀缓存
- 定义：复用多个请求相同的 prompt 开头的 Key/Value，减少 prefill 阶段计算量

## S

**Speculative Decoding**
- 中文：推测式解码
- 定义：用小模型快速猜一批候选 token，大模型一次性验证，一次前向传播生成多个 token
