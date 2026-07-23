---
created: 2026-07-23
tags: [knowledge-card, agent-interview, multi-agent, agent-core, orchestration]
day: Day19
difficulty: 🔴
aliases: [Supervisor Pattern, Coordinator Agent, 监督者模式, Centralized Orchestration]
related: ["[[Multi-Agent模式对比]]", "[[Peer-to-Peer模式]]", "[[Planner-Executor模式]]", "[[ReAct（推理-行动循环）]]", "[[AutoGen vs CrewAI vs LangGraph]]"]
---

# Supervisor 模式

> 一句话：中心 Supervisor Agent 接收任务→拆解子任务→分派给专职 Worker Agent→汇总各 Worker 结果→合成最终输出。是 Multi-Agent 编排中协调成本最低、可解释性最高的集中式模式。

## 核心机制

### 架构拓扑

```
                    ┌─────────────┐
                    │  Supervisor │ ← 中心调度者（单一控制点）
                    │  拆解/分派/汇总  │
                    └──┬────┬─────┘
                       │    │
              ┌────────┘    └────────┐
              ▼                      ▼
        ┌──────────┐          ┌──────────┐
        │ Worker A │          │ Worker B │   ← 专职子Agent
        │  (SQL)   │          │ (分析)   │      各自独立 ReAct 循环
        └──────────┘          └──────────┘
```

### 执行流程

```python
# 伪代码：Supervisor 调度循环
def supervisor_run(task):
    subtasks = decompose(task)          # 1. 拆解：大任务→子任务
    results = {}
    for subtask in subtasks:
        worker = route(subtask)         # 2. 分派：选最合适的 Worker
        result = worker.run(subtask)    # 3. Worker 独立 ReAct
        results[subtask.id] = result
    return synthesize(results)          # 4. 汇总：合并各 Worker 输出
```

### 关键设计决策

| 决策点 | 选项 | 权衡 |
|--------|------|------|
| **分派方式** | 静态路由 vs LLM 动态路由 | 静态快但僵化，动态灵活但多一次 LLM 调用 |
| **并行度** | 顺序 vs 并行执行 Worker | 顺序保留依赖关系，并行快但可能失败 |
| **汇总策略** | Supervisor 合成 vs Worker 间传递 | 合成可解释性好，传递减少 Supervisor 压力 |
| **Worker 通信** | 只看 Supervisor vs Worker 互见 | 隔离简单但信息利用率低 |

### 适用与不适用

- ✅ 任务可拆解为清晰子任务（如 SQL 查询 + 图表绘制）
- ✅ 子任务有依赖关系需要编排顺序
- ✅ 需要高可解释性和审计追踪
- ❌ 子任务高度耦合、频繁需要共享中间状态
- ❌ Supervisor 成为单点瓶颈和故障点

## 面试要点

1. **Supervisor 模式的本质**——不是简单的"一个调多个"，而是"中心化编排 + 专业化分工"。Supervisor 自己不执行任务，只做拆解、分派、汇总三件事
2. **Supervisor 的上下文压力**——所有 Worker 的输出都要汇总到 Supervisor，Supervisor 的上下文窗口成为整个系统的瓶颈。面试中要提到"Supervisor 提示词需要极简设计"
3. **与 Day14 ReAct 的关系**——每个 Worker 内部仍运行标准 ReAct 循环（Thought→Action→Observation），Supervisor 模式是 ReAct 的上层编排框架
4. **单点故障（单 Worker 崩溃）→ 整个任务失败，除非增加重试/降级机制
5. **什么时候不该用 Supervisor？**——子任务完全独立可并行（用简单并行即可）、任务简单到单 Agent 能搞定（不需要 Multi-Agent），以及 Peer-to-Peer 更合适的时候

## 关联概念

- Peer-to-Peer模式：去中心化编排，Agent 间直接通信，与 Supervisor 对称互补
- Planner-Executor模式：中心化规划但执行解耦，可视为 Supervisor 的工程优化变体
- Multi-Agent模式对比：五种模式的协调成本/容错/场景横向对比
- Day14 ReAct：Worker Agent 内部的推理-行动循环
- Day18 Context Engineering：Supervisor 上下文窗口压力 → Write/Select/Compress 策略
