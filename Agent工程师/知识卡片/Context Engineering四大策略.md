---
created: 2026-07-22
tags: [knowledge-card, agent-interview, agent-core, context-engineering]
day: Day18
difficulty: 🔴
aliases: [Context Engineering, 上下文工程, Four Pillars of Context Engineering]
related: ["[[Write策略]]", "[[Select策略]]", "[[Compress策略]]", "[[Isolate策略]]", "[[系统提示词分层设计]]", "[[前缀缓存与静态前缀分离]]", "[[ReAct（推理-行动循环）]]"]
---

# Context Engineering 四大策略

> 一句话：在有限的上下文窗口中最大化信息价值的系统方法论。四大策略（Write / Select / Compress / Isolate）构成请求到达 LLM 前的完整处理流水线，Write 是"放什么"，Select 是"留什么"，Compress 是"压什么"，Isolate 是"挡什么"。

## 核心机制

### 四大策略流水线

```
用户消息到达
    │
    ▼
┌─ Select ──────────────────────────────────┐
│ token > 70% 阈值？→ 三维加权排名标记淘汰  │
│ 时间 × 重要性 × 相关性                     │
└───────────────────────────────────────────┘
    │
    ▼
┌─ Compress ────────────────────────────────┐
│ 淘汰消息先压缩再丢弃                       │
│ 摘要压缩(5:1) → 仍超 → 事实提取(20:1)     │
│ → 仍超 → 分层压缩                          │
└───────────────────────────────────────────┘
    │
    ▼
┌─ Isolate ─────────────────────────────────┐
│ 工具返回 → Neutral Observation 安全包装    │
│ 角色标签校验 + 上下文沙箱隔离              │
└───────────────────────────────────────────┘
    │
    ▼
┌─ Write ───────────────────────────────────┐
│ 不变前缀（可缓存）+ 动态后缀               │
│ System Prompt → History → User Message     │
└───────────────────────────────────────────┘
    │
    ▼
  LLM 调用
```

### 各策略定位

| 策略 | 核心问题 | 关键手段 | 触发条件 |
|------|---------|---------|---------|
| **Write** | 放什么进上下文？ | 分层写入 + 前缀缓存 | 每次 LLM 调用 |
| **Select** | 窗口满了留什么？ | 三维加权排名 | token > 70% 窗口上限 |
| **Compress** | 淘汰内容怎么压缩？ | 摘要/事实提取/分层 | Select 标记淘汰后 |
| **Isolate** | 危险内容怎么挡？ | Neutral Observation + 沙箱 | 工具返回/IPC 消息到达 |

## 面试要点

1. **讲清楚流水线顺序**——Select → Compress → Isolate → Write，为什么 Select 在最前？因为先决定淘汰谁，再对淘汰内容压缩（省计算），而非上来全压后再选
2. **Isolate 为什么在 Compress 之后、Write 之前？**——压缩后的内容仍需隔离检查（压缩摘要也可能含注入指令），隔离后的内容直接进入 Write 的写入层
3. **与 Day14 ReAct 的关系**——Agent 每轮 Thought-Action-Observation 追加到上下文 = Write 策略的持续写入；当轮次累积逼近窗口上限，Select/Compress 被触发
4. **反向思考：什么时候不需要这些策略？**——单轮问答 Agent（无窗口压力）只需要 Write；工具调用少且可控的系统 Isolate 可简化
5. **Context Engineering 不是一次性设计**——窗口扩展（如 128K→1M）会改变触发点，阈值和策略需要持续校准

## 关联概念

- Write策略 / Select策略 / Compress策略 / Isolate策略：四大策略的独立展开
- 系统提示词分层设计：Write 策略中 System Prompt 的静态前缀优化
- 前缀缓存与静态前缀分离：Write 策略中"不变前缀可缓存"的工程落地
- Day14 ReAct：每轮追加即 Write；窗口上限触发 Select/Compress
- Day13 Lost in the Middle：Select 三维加权直接应对长上下文信息丢失
