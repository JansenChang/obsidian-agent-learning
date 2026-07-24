---
date: 2026-07-24
tags: [agent, hitl, checkpoint, state-persistence, time-travel, production, interview, day20]
source: AI面试学习系统
audio: "[[Day20-HITL与Checkpoint状态持久化.mp3]]"
status: completed
day: Day20
difficulty: 🔴
related:
  - "[[2026-07-16-Day14-从零手写ReAct Agent循环]]"
  - "[[2026-07-21-Day17-AgentMemory系统设计]]"
  - "[[2026-07-22-Day18-AgentLoop与ContextEngineering]]"
  - "[[2026-07-23-Day19-MultiAgent编排模式]]"
---

# Day 20 — HITL / Checkpoint / State Persistence

## 🎯 核心概念

| 概念 | 一句话 | 等级 |
|------|--------|:---:|
| **HITL（人在回路）** | Agent 在执行关键操作前暂停，将决策权交给人 | 🔴 |
| **审批门槛** | 高风险操作（写/大额/敏感）执行前触发人工确认 | 🔴 |
| **异常升级** | Agent 遇到无法处理的情况主动求助人类 | 🟠 |
| **Checkpoint** | Agent 在某时刻的完整状态快照（消息列表+循环次数+记忆引用） | 🔴 |
| **增量保存** | 只保存从上一个检查点以来的变更，类似 WAL | 🟠 |
| **时间旅行** | 回到历史检查点重新执行或分支 | 🟠 |
| **版本树** | Checkpoint ID + parent ID → 有向无环图，与 Git commit 树同构 | 🟠 |

---

## 🔄 HITL 三种场景

| 场景 | 触发机制 | 示例 |
|------|---------|------|
| **审批门槛** | 预设规则（金额/操作类型） | 退款 >1000 元需确认 |
| **异常升级** | Agent 自主判断 + 规则兜底 | 连续3次工具超时→求助 |
| **模糊澄清** | 存在多种合理解释 | "那个订单"→确认哪个 |

---

## 💾 Checkpoint 策略

| 策略 | 做法 | 优势 | 劣势 |
|------|------|------|------|
| **全量快照** | 每次保存完整状态 | 恢复最快 | 存储大、写入慢 |
| **增量保存** | 只记变更 | 存储省、写入快 | 恢复慢（需回溯多步） |
| **混合策略** | 每5轮全量 + 中间增量 | 平衡 | 实现复杂 |

**序列化格式：** JSON + 压缩（可读性 + 性能折中）

---

## 🌲 时间旅行分支管理

```
checkpoint_1 (parent: null)
  ├── checkpoint_2 (parent: 1)
  │     ├── checkpoint_3 (parent: 2)  ← 主线
  │     └── checkpoint_3b (parent: 2) ← 分支（回退后走不同路径）
  └── checkpoint_2b (parent: 1)
```

**与 Git commit 树完全同构**——每个检查点是 commit，parent 链是历史，分支是不同执行路径。

---

## 🏦 金融场景 HITL 四维度

| 维度 | 设计要点 |
|------|---------|
| **审批分级** | 读操作免审 / 小额一级 / 大额二级 / 高频用额度 |
| **超时策略** | 买入超时取消 / 卖出超时升级 / 查询超时通过 |
| **审计记录** | 不可篡改：谁+何时+结果+上下文 |
| **权限模型** | 细粒度 + 职责分离（审批者不可配置权限） |

---

## 🔗 知识连接

| 连接 | 内容 |
|------|------|
| **× Day14 ReAct** | HITL 插入在 Thought→Action 之间，循环暂停 |
| **× Day17 Memory** | 审批时附带用户历史记忆作为决策上下文 |
| **× Day18 Context Engineering** | Checkpoint 保存遵循 Write 分层结构 |
| **× Day19 Multi-Agent** | 任一 Worker 触发 HITL → 全局暂停 |

---

## 🎯 明天预告

Day21 — Week3 周回顾+实战：综合运用六天知识，从零手写完整 ReAct Agent（含上下文管理、记忆、容错、HITL）
