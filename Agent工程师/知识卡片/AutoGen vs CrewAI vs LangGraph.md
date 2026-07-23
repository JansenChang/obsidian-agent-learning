---
created: 2026-07-23
tags: [knowledge-card, agent-interview, multi-agent, agent-core, framework, comparison]
day: Day19
difficulty: 🟠
aliases: [Agent Framework Comparison, Multi-Agent Frameworks, 框架选型, AutoGen, CrewAI, LangGraph]
related: ["[[Multi-Agent模式对比]]", "[[Supervisor模式]]", "[[Planner-Executor模式]]", "[[ReAct（推理-行动循环）]]", "[[适配器模式（多模型FC）]]"]
---

# AutoGen vs CrewAI vs LangGraph

> 一句话：AutoGen（对话驱动+微软生态）、CrewAI（角色+任务驱动+上手快）、LangGraph（图编排+最灵活）是当前三大主流 Multi-Agent 框架——选择的关键不是功能多少，而是"你的团队需要什么层次的抽象"。

## 核心机制

### 三大框架架构对比

```
AutoGen（对话驱动）          CrewAI（角色+任务驱动）      LangGraph（图编排）
┌────────────────┐          ┌──────────────┐          ┌──────────────┐
│  Conversable   │          │   Crew       │          │  StateGraph  │
│    Agent       │          │  ┌─────────┐ │          │  ┌──┐  ┌──┐  │
│   ⇅ 对话       │          │  │ Agent A │ │          │  │A │→│B │  │
│   ⇅ 对话       │          │  │ 角色:研究员│ │          │  └──┘  └──┘  │
│    Agent       │          │  ├─────────┤ │          │   ↓     ↓    │
│                │          │  │ Agent B │ │          │  ┌──┐  ┌──┐  │
│  Agent 间通过   │          │  │ 角色:作者  │ │          │  │C │←│D │  │
│  对话消息通信    │          │  └─────────┘ │          │  └──┘  └──┘  │
│                │          │  Task → Agent │          │  条件边/循环   │
│  GroupChat     │          │  Process 执行  │          │  状态持久化    │
│  (群聊模式)     │          │              │          │              │
└────────────────┘          └──────────────┘          └──────────────┘
```

### 深度对比表

| 维度 | AutoGen | CrewAI | LangGraph |
|------|---------|--------|-----------|
| **核心抽象** | 对话（Conversation） | 角色（Role）+ 任务（Task） | 图（Graph）+ 状态（State） |
| **编排方式** | Agent 间对话驱动流转 | 任务按顺序/层级分配给角色 | 节点+条件边的图执行 |
| **上手难度** | ⭐⭐⭐ 中等 | ⭐ 极低 | ⭐⭐⭐⭐ 较高 |
| **灵活性** | ⭐⭐⭐ 中高 | ⭐⭐ 中 | ⭐⭐⭐⭐⭐ 最高 |
| **编程模型** | 事件驱动/回调 | 声明式（Role+Task定义） | 命令式（定义节点和边） |
| **状态管理** | 对话历史（有限） | 内置 Memory | State 对象（任意结构化状态） |
| **人机交互** | 原生支持 Human-in-loop | Task 级别支持 | Checkpoint 断点续传 |
| **五种模式覆盖** | Supervisor ✅ / GroupChat ✅ | ✅ 所有模式（角色抽象） | ✅ 所有模式（图足够通用） |
| **生态** | 微软 + Azure | 独立/社区 | LangChain 生态 |
| **最佳场景** | 需要对话追溯+微软云 | 快速原型+简单编排 | 复杂控制流+自定义需求 |

### 选择决策框架

```
                   你要解决什么问题？
                          │
           ┌──────────────┼──────────────┐
          快速原型        通用编排        复杂控制流
           │              │              │
      ┌────┴────┐    ┌────┴────┐    ┌────┴────┐
      │ CrewAI  │    │ AutoGen │    │LangGraph│
      │         │    │         │    │         │
      │角色+任务  │    │对话+群聊  │    │图+状态   │
      │声明式    │    │事件驱动  │    │命令式    │
      │15分钟上线│    │可追溯性好 │    │完全可控   │
      └─────────┘    └─────────┘    └─────────┘
      
关键追问：
- 需要对话级可追溯？ → AutoGen（每条消息有发送者/接收者/时间戳）
- 非技术人员也要定义流程？ → CrewAI（声明式 Role+Task 最直观）
- 需要条件分支/循环/并行？ → LangGraph（图结构天然支持）
- 需要与 LangChain 工具链集成？ → LangGraph（同生态无缝）
- 需要部署到 Azure？ → AutoGen（微软原生支持）
```

## 面试要点

1. **"不要问哪个框架最好，要问你的场景需要什么"**——面试官喜欢听到你根据需求选框架，而不是盲目推崇某个。三个锚点：复杂度（简单→CrewAI）、可追溯性（重要→AutoGen）、灵活性（关键→LangGraph）
2. **AutoGen 的"对话驱动"是双刃剑**——优点：每步有明确发送方/接收方/消息内容，审计友好；缺点：工程师需要理解"对话即编排"的思维模型，不像 CrewAI 的任务分配那么直觉
3. **CrewAI 的"角色+任务"抽象最适合非技术人员**——Product Manager 也能看懂 "研究员→作者→审查员" 的流程。但灵活性有限，遇到复杂条件分支时需要大量 workaround
4. **LangGraph 的"图编排"是通用解但不是银弹**——图 = 最灵活，但也 = 最需要工程能力。条件边、循环、并行、子图——概念多，调试难。适合有经验的工程师团队
5. **框架间的迁移成本**——CrewAI → LangGraph 的迁移较常见（原型验证后用 LangGraph 重构），因为 LangGraph 可以精确复现 CrewAI 的行为但增加控制。反之则难
6. **别忘了"不用框架"的选项**——如果只是 1 个 Supervisor + 2 个 Worker，手写 50 行 Python 比三个框架都简单。框架开销只在大规模/长维护周期时才能摊平

## 关联概念

- Multi-Agent模式对比：框架是模式的工程实现，五种模式在不同框架中有不同的实现难度
- Day14 ReAct：所有框架中每个 Agent 内部仍运行 ReAct 循环
- Day16 适配器模式：多模型 FC 统一适配——LangGraph/LangChain 的底层就是适配器
- Supervisor模式 / Planner-Executor模式 / Debate模式：三种框架各自的原生优势模式
