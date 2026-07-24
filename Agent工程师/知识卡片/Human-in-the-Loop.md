---
created: 2026-07-24
tags: [knowledge-card, agent-interview, hitl, agent-core, production]
day: Day20
difficulty: 🔴
aliases: [HITL, 人在回路, Human in the Loop, Human Approval]
related: ["[[Checkpoint机制]]", "[[ReAct（推理-行动循环）]]", "[[金融HITL四维度]]", "[[状态持久化策略]]", "[[Agent评估三层次]]"]
---

# Human-in-the-Loop（人在回路）

> 一句话：Agent 在执行关键操作前暂停，将决策权交给人，经人类确认/拒绝后再从 Checkpoint 恢复继续或回退。是生产级 Agent 系统从"全自动"到"可控自主"的最后一块拼图。

## 核心机制

### 三种场景

| 场景 | 触发机制 | 典型示例 | 实现方式 |
|------|---------|---------|---------|
| **审批门槛** | 预设规则（金额/操作类型/敏感数据） | 退款 >1000 元需人工确认 | 规则引擎，在 Action 执行前检查 |
| **异常升级** | Agent 自主判断 + 规则兜底 | 连续3次工具超时→求助人类 | LLM 置信度检测 + 异常计数兜底 |
| **模糊澄清** | 存在多种合理解释 | "那个订单"→确认具体哪个 | LLM 歧义检测，主动追问而非猜测 |

### 在 ReAct 循环中的位置

```
Thought → [HITL Gate] → Action → Observation
              ↑
         审批/澄清/升级
```

HITL 插入在 Thought（LLM 决定做什么）与 Action（真正执行）之间。这是对 ReAct 循环最简洁的增强——只加一个判断节点，不影响循环本身的推理链。

### 审批粒度设计

审批不是全局开关，而是精细化的：
- **读操作免审**：SELECT/GET 类操作自动通过
- **写操作审批**：INSERT/UPDATE/DELETE 类操作需确认
- **金额梯度审批**：<100元自动，100-1000元一级审批，>1000元二级审批
- **敏感数据审批**：涉及 PII（Personally Identifiable Information）的操作强制暂停

### 完整链路

```
Agent启动 → 加载初始状态 → 用户消息到达
  → ReAct循环开始
  → [自动保存Checkpoint]
  → Thought完成
  → HITL Gate检查审批规则
      ├─ 需审批 → 暂停、发送审批请求、等待
      │           ├─ 人类批准 → 从Checkpoint恢复 → 执行Action
      │           └─ 人类拒绝 → 回退到安全状态
      ├─ 异常检测 → 保存Checkpoint → 求助人类
      └─ 无需审批 → 执行Action → 继续循环
```

### 常见坑

- **等待超时**：人类可能离线，需设超时+降级策略（自动拒绝/升级/暂存）
- **消息格式转换**：Agent 内部 Thought 不可直接发给人类——需要把技术状态翻译成自然语言审批卡片
- **Multi-Agent 暂停策略**：任一 Worker 触发 HITL → 全局暂停（部分暂停可能导致状态不一致）

## 面试要点

1. **HITL 的本质不是"加个确认按钮"**——而是一套完整的暂停→序列化→通知→等待→恢复/回退的工程链路。Checkpoint 是技术基础，审批规则是业务逻辑
2. **审批阈值设定的权衡**——太低人工负担大（审批疲劳），太高风险敞口大（自动化失控）。面试中要说明"按操作类型+金额+数据敏感度三维度精细定义"
3. **HITL 与 12-Factor Agents 的关系**——HITL 不是特殊功能，而是 Agent 系统可观测性、可审计性、可干预性三项工程原则的交汇点
4. **审批 ≠ 异常升级**——前者是预设的确定性规则（规则引擎），后者是动态的不确定性判断（LLM + 规则兜底）。两者互补，缺一不可
5. **为什么不在 ReAct 的 Observation 之后插入 HITL？**——因为 Action 已经执行了，损失已经造成。HITL 必须在 Action 之前

## 关联概念

- Checkpoint机制：HITL 暂停时的状态保存基础——没有 Checkpoint 就无法恢复
- Day14 ReAct：HITL 插入在 Thought→Action 之间，循环暂停
- 金融HITL四维度：高风险行业 HITL 落地模板——审批分级+超时+审计+权限
- 状态持久化策略：Checkpoint 的全量/增量/混合三种保存方式
- Day17 Memory：审批时附带用户历史记忆作为决策上下文
- Day19 Multi-Agent：任一 Worker 触发 HITL → Supervisor 协调全局暂停
