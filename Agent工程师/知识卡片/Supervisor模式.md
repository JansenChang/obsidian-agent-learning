---
created: 2026-07-20
tags: [knowledge-card, agent-interview, agent-core]
day: Day15
difficulty: 🟠
aliases: [Supervisor Architecture, 中心调度模式, 调度Agent]
related: ["[[ReAct（推理-行动循环）]]", "[[Peer-to-Peer模式]]"]
---
# Supervisor模式

> 一句话：Multi-Agent 的中心调度编排——一个 Supervisor Agent 负责拆解任务、分配子 Agent、汇总结果，像项目经理配专职执行人。

## 核心机制

### 架构

```
                    用户请求
                       ↓
              ┌────────────────┐
              │  Supervisor     │  ← 调度 Agent（不干活，只协调）
              │  (ReAct循环)    │
              └───┬────┬────┬───┘
                  │    │    │
          分配子任务  │    │   分配子任务
                  ↓    │    ↓
         ┌────────┐   │  ┌────────┐
         │Agent A │   │  │Agent C │
         │竞品分析│ ← ┼ →│定价建议│
         │(ReAct) │   │  │(ReAct) │
         └────────┘   │  └────────┘
                      ↓
               ┌────────┐
               │Agent B │
               │用户画像│
               │(ReAct) │
               └────────┘
                   
    所有子 Agent 结果 → Supervisor 汇总 → 最终输出
```

### 工作流程

1. **Supervisor 分析请求**：用户需要市场调研报告，包含竞品分析、用户画像、定价建议
2. **拆解子任务**：三个独立子任务，各有明确输出
3. **分配执行**：子 Agent A/B/C 各自在自己的 ReAct 循环中完成任务
4. **汇总输出**：Supervisor 收齐所有结果，整合成最终报告

### 为什么 Supervisor 可控性好

- **任务序列可控**：Supervisor 决定子任务的先后顺序。若子任务间有依赖（如先竞品分析再定价），Supervisor 可串行调度
- **异常处理集中**：子 Agent 出问题，Supervisor 可以重新分配或降级处理
- **结果质量检查**：Supervisor 可以验证子 Agent 的输出是否满足要求，不满足则要求重做

### 何时选择 Supervisor

✅ **适合**：
- 子任务间有明确的依赖关系
- 需要严格的任务流程控制
- 对子 Agent 的输出质量有校验需求

❌ **不适合**：
- 子任务高度并行且相互独立
- 子 Agent 之间需要频繁交换中间信息
- Supervisor 本身成为瓶颈（单点故障）

## 面试要点

- **"多个 Agent 怎么协作"**：先说 Supervisor vs Peer-to-Peer 两种模式，再说选择标准——有依赖关系用 Supervisor，需要灵活通信用 P2P
- **"Supervisor 崩了怎么办"**：单点故障是 Supervisor 模式的缺点。解法是 Supervisor 本身也做冗余，或用轻量级规则引擎代替 LLM 做调度
- **穿透追问**："Supervisor 和普通 ReAct Agent 有什么区别？"——Supervisor 也是 ReAct Agent，但它的工具不是 API，而是其他 Agent。调用子 Agent 就是它的 Action

## 关联概念

- [[ReAct（推理-行动循环）]] — Supervisor 本身也是 ReAct Agent，每个子 Agent 也是
- [[Peer-to-Peer模式]] — 与之对标的另一种 Multi-Agent 编排模式
- [[ReAct失败模式]] — Multi-Agent 中每个子 Agent 都可能触发自己的失败模式，叠加后更复杂
