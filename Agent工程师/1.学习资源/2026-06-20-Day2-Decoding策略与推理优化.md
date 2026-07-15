---
date: 2026-06-20
tags: [agent, decoding, temperature, top-p, top-k, beam-search, interview, day2]
source: AI面试学习系统
audio: "[[Day2-Decoding策略与推理优化.mp3]]"
audio_deep: "[[Day2-深度扩展-Tokenization预习.mp3]]"
status: completed
day: Day2
difficulty: 🟡
related:
  - "[[Day1-Transformer与Attention机制]]"
  - "[[Day3-Tokenization分词]]"
  - "[[CoT（思维链）]]"
  - "[[Temperature温度参数]]"
  - "[[Top-K与Top-P采样]]"
---

# Day 2 — Decoding 策略与推理优化

## 🎧 配套音频

- **正式版（~30min）**：`[[Day2-Decoding策略与推理优化.mp3]]`
- **预习版（~30min）**：`[[Day2-深度扩展-Tokenization预习.mp3]]`

## 🎯 核心概念

| 概念 | 一句话 | 等级 |
|------|--------|:--:|
| **Greedy Decoding** | 每步选概率最高的词，确定但单调 | 🟡 |
| **Temperature** | 控制概率分布陡峭度，来自统计物理玻尔兹曼分布 | 🟡 |
| **Top-K** | 只保留概率最高的 K 个词，硬限制 | 🟡 |
| **Top-P (Nucleus)** | 动态累加概率达到 P 为止，软限制 | 🟡 |
| **Beam Search** | 同时维护 N 条路径选整体最优 | 🟠 |
| **Frequency/Presence Penalty** | 已出现词降权，防重复（OpenAI 独有） | 🟠 |

## 🔄 完整解码流程

```
Top-K 砍尾部噪声 → Top-P 动态剪裁 → Temperature 调节分布 → 采样选词
```

四个步骤顺序执行，K 管下限，P 管上限。

## 📐 参数速查表

| 场景 | Temperature | Top-P | Top-K | 说明 |
|------|:----------:|:-----:|:-----:|------|
| 客服/代码/数学 | 0.2~0.3 | 0.9 | 40 | 需要确定性 |
| 通用对话 | 0.7 | 0.9 | 40 | ChatGPT 默认 |
| 创意写作 | 0.8~0.95 | 0.95 | 50 | 需要多样性 |
| 翻译/摘要 | 0.1 / Greedy | — | — | 忠于原文 |

## 🔬 深入要点

### Greedy Decoding 的问题
- 缺乏多样性：同样的输入永远得到同样的输出
- 容易重复循环：「很开心，真的很开心，非常开心…」
- 每一步选最好 ≠ 整体最好（局部最优陷阱）

### Temperature 本质
- T=0 → 确定性算法（调试/测试必备）
- T=1 → 原始 softmax，不做修改
- T>1 → 分布被压平，更"冒险"
- **面试话术**：「Temperature 控制的是概率分布的陡峭程度，高温让分布更平坦、模型更愿意冒险」

### Top-K vs Top-P
- **K 固定**：分布集中时 K 太大引入噪声，分布分散时 K 太小砍合理候选
- **P 动态**：自动适配分布形态，候选数不固定
- 先 K 后 P，K 管下限，P 管上限

### Temperature 不能弥补模型能力差距
- 模型能力是训练决定的，Decoding 参数只影响表达方式
- DeepSeek 调到低温也不会变成 Claude

### 跨模型迁移
- 不同模型 softmax 输出分布不同
- 参数不能直接搬，需重新微调

## 🔗 与已学知识的连接

```
Tokenization → Embedding → RoPE → Attention → FFN → LM Head → Softmax → **Decoding 策略** → 输出
                                                                              ↑ 今天学的
```

- **Day1 Attention**：算出了每个 token 对上下文的理解
- **Day2 Decoding**：从 Attention 算出的概率中做最优选择
- 注意：Attention 决定了信息的质量，Decoding 决定了信息的选择方式，两者不可替代

## ⚡ 面试高频考点

1. 贪婪解码有什么问题？（单调/重复/局部最优）
2. Temperature 和 Top-P 分别控制什么？
3. Top-K 和 Top-P 的区别？什么时候用哪个？
4. 解码参数能弥补模型能力差距吗？（不能）
5. 输出重复怎么调？（frequency_penalty 或升温 + 放宽 Top-P）

## 📚 专业术语

- `[[Temperature温度参数]]` — Temperature（温度参数）
- `[[Top-K与Top-P采样]]` — Top-K Sampling / Top-P (Nucleus) Sampling
- `[[Greedy Decoding]]` — Greedy Decoding（贪婪解码）
- `[[Beam Search束搜索]]` — Beam Search（束搜索）
