---
date: 2026-07-23
tags: [agent, multi-agent, supervisor, debate, swarm, autogen, crewai, interview, day19]
source: AI面试学习系统
audio: "[[Day19-MultiAgent编排模式.mp3]]"
status: completed
day: Day19
difficulty: 🔴
related:
  - "[[2026-07-16-Day14-从零手写ReAct Agent循环]]"
  - "[[2026-07-21-Day17-AgentMemory系统设计]]"
  - "[[2026-07-22-Day18-AgentLoop与ContextEngineering]]"
---

# Day 19 — Multi-Agent 编排模式

## 🎯 核心概念

| 概念 | 一句话 | 等级 |
|------|--------|:---:|
| **Supervisor 模式** | 中心调度者拆解任务→分派 Worker→汇总结果 | 🔴 |
| **Planner-Executor** | 先全局规划再逐步执行，适合步骤固定任务 | 🔴 |
| **Reviewer 模式** | Generator 产出→Reviewer 评审→修改→循环至达标 | 🔴 |
| **Debate 模式** | 多 Agent 各自方案→互相质疑→投票/仲裁收敛 | 🟠 |
| **Swarm 模式** | 大量轻量 Agent 无中心调度，局部交互涌现全局智能 | 🟠 |
| **AutoGen** | 微软对话驱动 Multi-Agent 框架 | 🟠 |
| **CrewAI** | 角色+任务驱动的 Multi-Agent 框架 | 🟠 |
| **LangGraph** | 通用图编排，最灵活，五种模式均可实现 | 🟠 |

---

## 🏗️ 五种模式全景

```
Supervisor:          Planner-Executor:     Reviewer:
  Supervisor            Planner               Generator ──→ Reviewer
  /  |  \              (完整计划)                 ↑            │
 W1  W2  W3               ↓                   修改清单 ←── 评审
                         Executor
                        (逐步执行)

Debate:               Swarm:
  A ⇄ B                                     • •  •  • •
   ↕                                      •    •    •   •
  C (仲裁)                                  •  •   •  •
```

---

## 📊 模式对比

| 维度 | Supervisor | Planner-Executor | Reviewer | Debate | Swarm |
|------|:---:|:---:|:---:|:---:|:---:|
| **协调成本** | 低 | 中 | 中 | 高 | 不可预测 |
| **容错能力** | 弱（单点） | 中 | 中 | 强（冗余） | 最强 |
| **适用场景** | 可拆解+有依赖 | 步骤固定 | 质量门控 | 多角度决策 | 大规模并行探索 |
| **可解释性** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐ |

---

## 🔌 三大框架对比

| 框架 | 驱动方式 | 优势 | 劣势 |
|------|---------|------|------|
| **AutoGen** | 对话驱动 | 可追溯、微软生态 | 需要理解对话模型 |
| **CrewAI** | 角色+任务 | 上手快、直观 | 灵活性有限 |
| **LangGraph** | 图编排 | 最灵活、五种模式全覆盖 | 开发成本高 |

---

## 🚦 何时上 Multi-Agent？

**三个判断标准：**
1. 单 Agent 系统提示词长到影响工具选择准确率
2. 子任务工具集完全不重叠（SQL vs 图像分析）
3. 子任务之间无共享上下文

**不满足以上条件→单 Agent 更好。Multi-Agent 不是升级，是架构取舍。**

---

## 🐛 分层日志排查

| 层 | 记录内容 | 什么情况下看 |
|----|---------|-------------|
| **编排日志** | Supervisor 决策/分派/汇总 | 调度逻辑问题 |
| **Worker 日志** | 每个 Agent 的 TAO 循环 | 执行逻辑问题 |
| **通信日志** | Agent 间消息原文 | 信息传递问题 |

**关键技巧：统一时间戳对齐→按时间排序还原全局执行时序。**

---

## 🔗 知识连接

| 连接 | 内容 |
|------|------|
| **× Day14 ReAct** | 每个 Agent 独立运行 ReAct 循环，Multi-Agent 是上层编排 |
| **× Day17 Memory** | 共享记忆 = Agent 之间通过向量库交换信息 |
| **× Day18 Context Engineering** | Supervisor 上下文压力最大，提示词需最精简 |

---

## 🎯 明天预告

Day20 — HITL / Checkpoint / State Persistence：人在回路、断点续传、时间旅行回退
