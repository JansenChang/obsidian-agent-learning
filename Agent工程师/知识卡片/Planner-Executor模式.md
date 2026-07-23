---
created: 2026-07-23
tags: [knowledge-card, agent-interview, multi-agent, agent-core, orchestration]
day: Day19
difficulty: 🔴
aliases: [Plan-and-Execute, PE Pattern, 规划-执行模式, Offline Planning]
related: ["[[Supervisor模式]]", "[[Multi-Agent模式对比]]", "[[ReAct（推理-行动循环）]]", "[[AutoGen vs CrewAI vs LangGraph]]"]
---

# Planner-Executor 模式

> 一句话：Planner Agent 感知全局后一次性生成完整执行计划（离线规划），Executor Agent 按步骤逐一执行并反馈进度（在线执行），实现"规划"与"执行"的解耦——长时序任务也能保持全局一致性。

## 核心机制

### 架构拓扑

```
          ┌──────────┐
          │ Planner  │ ← 离线规划者（一次性生成完整计划）
          │ 全局感知+分解  │
          └────┬─────┘
               │ 完整计划（步骤列表）
               ▼
          ┌──────────┐
          │ Executor │ ← 在线执行者（逐步执行+进度反馈）
          │ 步骤执行+反馈  │
          └──────────┘
```

### 执行流程

```python
# Planner: 离线生成计划（一次 LLM 调用）
def planner(task):
    plan = llm.generate(f"""
    分析任务: {task}
    输出结构化执行计划:
    1. 子目标分解
    2. 每步所需工具
    3. 步骤间依赖关系
    4. 预期产出
    """)
    return parse_plan(plan)  # 步骤列表

# Executor: 在线逐步执行（ReAct 循环）
def executor(plan):
    for step in plan:
        result = react_loop(step)       # 标准 ReAct
        if not validate(result):
            replan(plan, step)          # 偏差时触发重规划
```

### 关键设计：重规划触发器

| 触发条件 | 处理方式 | 成本 |
|---------|---------|------|
| 步骤执行失败 | 局部调整当前步骤 | 低 |
| 中间结果与预期偏差 > 阈值 | 从当前步起重新规划 | 中 |
| 工具/环境状态变化 | 完全重新规划剩余步骤 | 高 |
| 用户中途变更需求 | 全量重规划 | 最高 |

### 与 Supervisor 模式的关键区别

| 维度 | Supervisor | Planner-Executor |
|------|:---:|:---:|
| **规划时机** | 边执行边调整 | 先规划后执行 |
| **任务可见性** | 局部（逐子任务） | 全局（完整计划） |
| **适合场景** | 子任务动态/不确定 | 步骤固定/可预测 |
| **上下文消耗** | 汇总压力大 | 规划阶段压力大 |

## 面试要点

1. **为什么需要"离线规划"？**——Agent 逐步 ReAct 容易短视（只看当前步骤），Planner 先看到全局再分解，能避免"局部最优但全局差"的问题。面试要举例子：写长篇报告需要先列大纲再逐段写，否则前后不一致
2. **重规划机制是面试加分点**——只讲"规划-执行"不够，"执行出现偏差时怎么处理"才是工程深度。要提到触发条件和对应的处理策略
3. **与 LangGraph 的关系**——LangGraph 的 StateGraph 天然支持 Planner-Executor：Planner 节点生成计划写入 State，Executor 节点读取+循环执行+写回 State
4. **上下文窗口压力分布不同**——Supervisor 压力在汇总阶段，Planner-Executor 压力在规划阶段（需要把完整计划和执行结果都放上下文）
5. **什么时候 Planner-Executor 不如 Supervisor？**——任务步骤高度不确定（比如开放式研究探索），预规划大概率失效，不如 Supervisor 边做边调整

## 关联概念

- Supervisor模式：中心化调度的对比模式，边执行边调整 vs 先规划后执行
- Day14 ReAct：Executor 执行每一步时仍然运行 ReAct 循环
- Multi-Agent模式对比：五种模式横向对比中的"步骤固定场景首选"
- AutoGen vs CrewAI vs LangGraph：LangGraph 通过 StateGraph 天然实现此模式
- Day18 Context Engineering：Planner 阶段上下文消耗大 → 提示词需精简，必要时 Compress
