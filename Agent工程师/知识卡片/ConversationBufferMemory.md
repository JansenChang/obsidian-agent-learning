---
created: 2026-07-21
tags: [knowledge-card, agent-interview, agent-core, memory, short-term-memory]
day: Day17
difficulty: 🔴
aliases: [Buffer Memory, 全量缓冲, 全量记忆]
related: ["[[三层记忆架构]]", "[[ConversationSummaryMemory]]", "[[遗忘策略]]"]
---

# ConversationBufferMemory

> 一句话：短期记忆的最简实现——把整个对话历史原封不动存下来，每轮 LLM 调用全量传入，信息最完整但 token 消耗线性膨胀，仅在短对话场景中好用。

## 核心机制

### 工作原理

```
对话轮次      消息列表长度      token 消耗
  第 1 轮       2 条             ~200
  第 5 轮      10 条           ~1,000
  第 10 轮     20 条           ~2,000
  第 20 轮     40 条           ~4,000
  第 50 轮    100 条          ~12,000
```

每轮都把完整的消息列表发给 LLM，不做任何截断或压缩。

### 三大问题

| 问题 | 描述 |
|------|------|
| **Token 线性膨胀** | 50 轮对话可轻松消耗数万 token，每次调用成本持续增长 |
| **Lost in the Middle** | Day13 讲过的——LLM 对长上下文中间部分的信息容易忽略，早期关键信息沉入中间段后难以被模型关注 |
| **延迟累积** | 输入 token 越多，LLM 推理时间越长，用户等待越久 |

### 适用场景

✅ 短对话（<10 轮）的客服，一上来就解决问题，不需要长时间记忆
✅ 原型开发和 Demo——先用 Buffer 快速验证，之后再换生产方案
❌ 长对话（>30 轮）的教育辅导、代码审查、复杂决策场景

## 面试要点

1. **"最简但不最优"**——先说 Buffer 是起点，再说为什么生产环境需要升级
2. **Token 成本计算**——能当场估算 50 轮对话的 token 消耗，展示工程意识
3. **Lost in the Middle 关联**——将 Buffer 与 Day13 概念连接，证明知识体系完整
4. **对比其他模式**——Window 丢旧信息、Summary 有精度损失、TokenBuffer 更精确，每种各有取舍
5. **混合模式是最终答案**——最近 N 轮 Buffer + 更早 Summary + 超远丢弃

## 关联概念

- ConversationSummaryMemory：摘要压缩替代方案，解决 token 膨胀
- 三层记忆架构：Buffer 是短期记忆的一种实现策略
- Day13 Lost in the Middle：Buffer 模式放大该问题
