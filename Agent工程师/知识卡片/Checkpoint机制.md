---
created: 2026-07-24
tags: [knowledge-card, agent-interview, checkpoint, state-persistence, agent-core]
day: Day20
difficulty: 🔴
aliases: [Checkpoint, 检查点, State Snapshot, 状态快照, LangGraph Checkpointer]
related: ["[[Human-in-the-Loop]]", "[[状态持久化策略]]", "[[时间旅行与版本树]]", "[[三层记忆架构]]", "[[Context Engineering四大策略]]"]
---

# Checkpoint 机制

> 一句话：Agent 在特定时刻的完整状态快照——包含消息列表、ReAct 循环次数、记忆引用、Multi-Agent 子状态，是 HITL 恢复和时间旅行的技术基础。

## 核心机制

### Checkpoint 包含什么

```
Checkpoint {
  checkpoint_id: "ckpt_042",
  parent_id: "ckpt_041",
  timestamp: "2026-07-24T10:30:15Z",
  state: {
    messages: [          // 完整对话历史
      {role: "system", content: "..."},
      {role: "user", content: "..."},
      {role: "assistant", content: "Thought: ...", tool_calls: [...]},
      {role: "tool", content: "...", tool_call_id: "..."}
    ],
    loop_count: 7,       // 当前 ReAct 循环次数
    memory_refs: [       // 本次对话中已检索/更新的记忆引用
      {id: "mem_001", action: "read"},
      {id: "mem_005", action: "written"}
    ],
    sub_agent_states: {  // Multi-Agent 场景：每个 Worker 的状态
      "worker_sql": {...},
      "worker_analyzer": {...}
    }
  }
}
```

### 保存时机

| 时机 | 场景 | 目的 |
|------|------|------|
| **每个 ReAct 循环开始前** | 常规自动保存 | 循环出错时可回到上一轮重新执行 |
| **HITL 审批触发时** | 审批暂停前 | 人类决策后从中断点精确恢复 |
| **异常升级时** | 发送求助信号同时 | 人类接手时了解完整当前状态 |
| **任务完成时** | 最终状态归档 | 审计追踪、后续分析 |

### 存储后端选择

| 后端 | 速度 | 持久化 | 并发 | 适用场景 |
|------|:---:|:---:|:---:|---------|
| **内存** | ⚡最快 | ❌ 进程重启丢失 | ✅ | 开发调试、单次会话 |
| **文件** | 🟡中等 | ✅ | ⚠️ 需处理锁 | 单机部署、简单场景 |
| **Redis** | ⚡快 | ⚡ 可配置持久化 | ✅ | 生产环境首选折中 |
| **数据库** | 🐢慢 | ✅✅ 最可靠 | ✅✅ | 金融/合规场景 |

### 与 HITL 的协作流程

```
ReAct 循环中：
  Thought 完成 → 保存 Checkpoint → HITL Gate 检查
    ├─ 需审批 → 发送审批请求（附带 Checkpoint ID）
    │   等待人类决策...
    │   ├─ 批准 → load_checkpoint(id) → 恢复 → 执行 Action
    │   └─ 拒绝 → load_checkpoint(parent_id) → 回退到安全状态
    └─ 无需审批 → 执行 Action → 进入下一轮
```

## 面试要点

1. **Checkpoint 不只是"保存对话"**——它保存的是 Agent 的完整执行上下文（消息列表 + 循环状态 + 记忆引用 + Multi-Agent 子状态）。面试中要能逐项列出
2. **保存时机的设计哲学**——在 Action 执行**前**保存，而非执行后。如果在执行后保存，Action 已经产生副作用，回退变得复杂。前置保存确保"暂停点"是安全的
3. **Checkpoint 的序列化格式选择**——JSON+压缩是生产环境的平衡点：可读性好（调试方便），性能可接受。为什么不用 Protobuf？因为出了问题需要人工查看检查点内容
4. **Checkpoint ID 与 parent ID 的设计**——这是时间旅行和版本树的数据结构基础。每个检查点记录其来源（parent），形成一个有向无环图
5. **LangGraph 的 Checkpointer 抽象**——LangGraph 把 Checkpoint 提升为一等公民：`MemorySaver`（内存）、`SqliteSaver`（本地）、`RedisSaver`（生产）。面试时提这三个实现说明你有实际工程经验

## 关联概念

- Human-in-the-Loop：Checkpoint 是 HITL 的状态保存基础——暂停前存、决策后恢复
- 状态持久化策略：全量快照 vs 增量保存 vs 混合策略——Checkpoint 的工程优化
- 时间旅行与版本树：Checkpoint ID + parent ID → DAG，回溯和分支的数据结构
- Day14 ReAct：Checkpoint 保存的是 ReAct 循环的当前状态
- Day18 Context Engineering：Checkpoint 保存遵循 Write 分层结构，便于恢复时定位
