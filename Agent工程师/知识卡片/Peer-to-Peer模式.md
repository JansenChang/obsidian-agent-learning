---
created: 2026-07-20
tags: [knowledge-card, agent-interview, agent-core]
day: Day15
difficulty: 🟠
aliases: [Peer-to-Peer Architecture, 对等通信模式, 去中心化编排]
related: ["[[ReAct（推理-行动循环）]]", "[[Supervisor模式]]"]
---
# Peer-to-Peer模式

> 一句话：Multi-Agent 去中心化编排——没有中央调度者，Agent 之间直接通信共享中间结果，共同协商产出最终答案。

## 核心机制

### 架构

```
        用户请求同时发给三个 Agent
              ↓
    ┌─────────┼─────────┐
    ↓         ↓         ↓
┌───────┐ ┌───────┐ ┌───────┐
│Agent A│ │Agent B│ │Agent C│
│竞品分析│←┤用户画像│→│定价建议│
│(ReAct)│ │(ReAct)│ │(ReAct)│
└──┬──┬─┘ └───┬───┘ └──┬──┬─┘
   │  └────────┼────────┘  │
   │   交叉信息共享          │
   └─────────┼─────────────┘
             ↓
      协商产出最终报告
```

### 工作流程

以市场调研报告为例：

1. **并行启动**：三个 Agent 同时收到用户请求
2. **各自工作**：每个 Agent 在自己的 ReAct 循环中处理子任务
3. **中间结果推送**：
   - 竞品分析 Agent 完成初稿 → 推送给定价建议 Agent："竞品价格范围是 50-200，你的定价需要考虑"
   - 用户画像 Agent 完成分析 → 推送给另外两个
4. **协商输出**：三个 Agent 基于共享信息，协商产出综合报告

### 与 Supervisor 的对比

| 维度 | Supervisor | Peer-to-Peer |
|:---|:---|:---|
| **协调者** | 中央调度 Agent | 无中心，Agent 直接通信 |
| **任务分配** | Supervisor 拆解+分配 | 各 Agent 自行认领 |
| **信息流** | 子 Agent → Supervisor → 汇总 | Agent ↔ Agent 自由交换 |
| **可控性** | 高（单点调度） | 低（去中心化） |
| **灵活性** | 中（受调度逻辑限制） | 高（自由通信） |
| **协调成本** | 低（集中在 Supervisor） | 高（N×N 通信通道） |
| **单点故障** | 有（Supervisor） | 无 |

### 何时选择 Peer-to-Peer

✅ **适合**：
- 子任务高度并行，相互间有交叉信息需求
- 不需要严格的任务序列控制
- 希望避免单点故障

❌ **不适合**：
- 子任务间有强依赖关系（必须先 A 再 B）
- 需要中心化的质量把控
- Agent 数量多时通信成本指数增长

### 面试中常被忽视的关键

**大部分生产系统以 Supervisor 为主**，因为可控性好。Peer-to-Peer 听起来更灵活，但在生产环境中协调成本高、调试困难。面试官期待你说出"我倾向 Supervisor，但理解 Peer-to-Peer 的适用场景"，而不是盲目推荐 P2P。

## 面试要点

- **"Supervisor 和 Peer-to-Peer 怎么选"**：有依赖→Supervisor，并行+交叉信息→P2P，生产系统优先 Supervisor
- **穿透追问**："三个 Peer Agent 意见分歧怎么办？"——这是 P2P 的核心挑战。需要设计共识/投票机制，或引入轻量级仲裁者。如果没有这种设计的回答，会暴露出对 P2P 复杂度理解不足
- **"Multi-Agent 是不是越多越好"**：不是。增加 Agent 数量提升问题拆分能力，但也成倍增加协调成本和出错概率。先用一个 ReAct Agent + 丰富工具，只有在 System Prompt 差异大到无法融合时才拆

## 关联概念

- [[ReAct（推理-行动循环）]] — 每个 Peer Agent 都是独立 ReAct 循环
- [[Supervisor模式]] — 对标的中心调度模式，面试中必然对比
- [[ReAct失败模式]] — Peer 模式下失败模式会互扰：一个 Agent 的幻觉可能污染其他 Agent
