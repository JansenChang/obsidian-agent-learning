---
created: 2026-07-23
tags: [knowledge-card, agent-interview, multi-agent, agent-core, orchestration, comparison]
day: Day19
difficulty: 🔴
aliases: [Multi-Agent Patterns Comparison, 多Agent编排对比, Orchestration Trade-offs]
related: ["[[Supervisor模式]]", "[[Planner-Executor模式]]", "[[Reviewer模式]]", "[[Debate模式]]", "[[Swarm模式]]", "[[AutoGen vs CrewAI vs LangGraph]]", "[[ReAct（推理-行动循环）]]"]
---

# Multi-Agent 模式对比

> 一句话：五大 Multi-Agent 编排模式在协调成本、容错能力、可解释性、适用场景四个维度上存在根本性取舍——没有"最好"的模式，只有"最匹配场景"的模式。

## 核心机制

### 五个维度横向对比

| 维度 | Supervisor | Planner-Executor | Reviewer | Debate | Swarm |
|------|:---------:|:----------------:|:--------:|:------:|:-----:|
| **协调成本** | 低（中心调度） | 中（规划成本） | 中（迭代评审） | 高（O(n²)质疑） | 不可预测 |
| **容错能力** | 弱（单点故障） | 中（重规划兜底） | 中（可重审） | 强（多份冗余） | 最强（无单点） |
| **LLM 调用数** | n（Worker数） | 2+（规划+执行） | 2-6（迭代×2） | O(n²×轮数) | 极高（Agent多） |
| **可解释性** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐ |
| **输出质量** | 中等 | 高（全局优化） | 最高（质量门控） | 高（多角度收敛） | 不确定 |
| **延迟** | 低 | 中 | 中高（迭代） | 高（多轮辩论） | 极低（并行） |
| **最佳场景** | 可拆解+有依赖 | 步骤固定+长时序 | 质量敏感+可迭代 | 多角度决策 | 大规模并行探索 |

### 模式选择决策树

```
                    任务是否需要 Multi-Agent？
                           │
              ┌────────────┼────────────┐
             否           是            不确定
              │            │             │
           单 Agent    子任务是否        任务空间是否
           (ReAct)    有明确可分性？     可并行大规模探索？
                        │                  │
                 ┌──────┼──────┐      ┌────┼────┐
                高     中     低     是   否   不确定
                 │      │      │      │    │     │
              Supervisor Planner- 质量  Swarm │  Debate
              质量敏感？ Executor 要求？      │  (多角度
               │         │         │         │   保险)
          ┌────┼────┐   步骤固定？ ┌┼─┐       │
         是   否    │      │      ││ │       │
          │    │    │     是     高低 │       │
       Reviewer│ Supervisor  │     ││  │       │
          │    │       │  Planner- Reviewer  │
          │    │       │  Executor           │
          │    │       │                     │
```

### 组合模式：真实系统很少只用一种

```
常见组合：

1. Supervisor + Reviewer
   Supervisor 拆解分派 → 每个 Worker 产出 → Reviewer 评审
   适用：企业级任务管理系统

2. Planner-Executor + Reviewer
   Planner 生成计划 → Executor 逐步执行 → 每步结果 Review
   适用：代码生成（先规划架构 → 逐模块实现 → 代码审查）

3. Debate + Supervisor（仲裁）
   多 Agent 辩论 → Supervisor 作为仲裁者选最优
   适用：战略决策系统

4. Swarm + Supervisor（混合）
   Swarm 大规模探索 → Supervisor 筛选有价值发现 → 深度分析
   适用：科研探索（广度探索+深度挖掘）
```

## 面试要点

1. **面试官最常问的坑**——"什么场景用 Multi-Agent 比单 Agent 更好？"不要直接报模式名，要按"三个判断标准"回答：① 单 Agent 提示词长到影响准确率 ② 子任务工具集完全不重叠 ③ 子任务无共享上下文
2. **"Multi-Agent 不是升级，是架构取舍"**——这句话一定要说出来。Multi-Agent 增加了协调成本、通信开销、延迟，只在特定条件下才优于单 Agent
3. **组合模式是面试加分项**——展示你理解真实系统不会只用单一模式，会按需组合。但要说清楚组合的代价（成本叠加）
4. **选择模式的锚点**——面试中的简洁回答框架：先判断是否需要 Multi-Agent → 看任务结构（可拆解→Supervisor；步骤固定→Planner-Executor）→ 看质量要求（高→Reviewer/Debate）→ 看容错要求（高→Swarm）
5. **别忘了"不用的理由"**——每个模式都要知道"什么时候不该用"，这比"什么时候该用"更能体现工程判断力

## 关联概念

- 五种模式详情：Supervisor模式 / Planner-Executor模式 / Reviewer模式 / Debate模式 / Swarm模式
- Day14 ReAct：所有 Multi-Agent 模式中每个 Agent 内部仍运行 ReAct 循环
- Day17 Memory：Multi-Agent 共享记忆通过向量库交换信息
- Day18 Context Engineering：Supervisor/Planner 上下文压力最大，提示词需极简
- AutoGen vs CrewAI vs LangGraph：三大框架对各模式的原生支持程度
