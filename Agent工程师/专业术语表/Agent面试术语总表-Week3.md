---
created: 2026-07-20
tags:
  - glossary
  - agent-interview
  - index
---

# Agent 面试术语表 — Week 3

> 按 Day 组织。每个术语包含：英文全称 + 中文 + 一句话定义 + 首次出现的 Day + 关联知识卡片。

## Week 3 · Agent 核心循环 & Multi-Agent 编排

### Day 16 — Function Calling / Tool Use 协议深度对比

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| **Function Calling** | Function Calling（函数调用） | LLM 输出结构化 JSON 调用指令的标准化协议——OpenAI 用 tool_calls 数组承载，Anthropic 用 tool_use block 承载 | [[OpenAI Function Calling 格式]] |
| **Tool Use** | Tool Use（工具使用） | Anthropic 的工具调用机制：工具定义用 input_schema、调用嵌在 content 数组的 tool_use block、结果以 user 角色回传 | [[Anthropic Tool Use 格式]] |
| **Exponential Backoff** | Exponential Backoff（指数退避） | 失败重试间隔按指数增长（1s→2s→4s→...）的容错策略，防止在故障未恢复时立即重试造成请求风暴 | [[指数退避（Exponential Backoff）]] |
| **Adapter Pattern** | Adapter Pattern（适配器模式） | 通过三层转换（定义→解析→回溯）统一多模型 FC 格式的适配层设计，实现模型无关的 Agent 框架 | [[适配器模式（多模型FC）]] |
| **Parallel Tool Calling** | Parallel Tool Calling（并行工具调用） | 利用线程池同时执行多个无依赖工具调用，总耗时压缩到最慢工具的时间 | [[并行工具调用]] |
| **Idempotency** | Idempotency（幂等性） | 相同输入重复调用的结果一致性——读操作天然幂等，写操作需通过幂等键去重 | [[工具幂等性]] |

### Day 15 — ReAct 原理深挖与面试穿透

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| Grounding | Grounding（接地） | LLM 用外部工具调用验证推理正确性，防止幻觉在封闭链中无限放大 | [[接地（Grounding）]] |
| Error Propagation | Error Propagation（错误传播） | CoT 自循环推理中第一步错误在无外部验证下被逐级放大，最终输出看似合理但全错的答案 | [[错误传播（Error Propagation）]] |
| Trajectory Eval | Trajectory Evaluation（轨迹评估） | 检查 Agent 完整推理-行动链（Thought→Action→Observation）是否合理，而非只看最终答案 | [[Agent评估三层次]] |
| Component Eval | Component Evaluation（组件评估） | 每个工具单独测试，确保 Agent 的底层数据源准确可靠 | [[Agent评估三层次]] |
| End-to-End Eval | End-to-End Evaluation（端到端评估） | 只看最终答案正确性，最常用但最容易掩盖推理质量问题 | [[Agent评估三层次]] |
| Neutral Observation | Neutral Observation（中性观察包装） | 工具返回结果用安全模板包裹，防御 ReAct 中间接注入攻击 | [[Prompt Injection（提示注入）]] |
| Tool Swamp | Tool Swamp（工具沼泽） | ReAct 失败模式：LLM 已有足够信息但仍过度调用不必要的工具 | [[ReAct失败模式]] |
| Reasoning-Action Loop Divergence | Reasoning-Action Loop Divergence（循环发散） | ReAct 失败模式：推理方向逐渐偏离原始问题，越查越远 | [[ReAct失败模式]] |
| ReAct Prompt Layering | ReAct 提示词四层设计 | 角色定义→推理行动约束→工具使用指南→安全边界，优先级递增 | [[ReAct提示词四层设计]] |
| Supervisor | Supervisor 模式（中央调度） | Multi-Agent 中心调度编排：一个 Supervisor 拆解分配汇总，子 Agent 各自 ReAct | [[Supervisor模式]] |
| Peer-to-Peer | Peer-to-Peer 模式（对等通信） | Multi-Agent 去中心化编排：Agent 间直接通信共享中间结果 | [[Peer-to-Peer模式]] |
| ReWOO | Reasoning WithOut Observation | ReAct 变体：一次性规划所有工具调用，批量执行，减少 LLM 调用次数 | — |
| Reflexion | Reflexion（反思） | ReAct 变体：每次循环后增加反思步骤，自我改进推理质量 | — |
| LATS | Language Agent Tree Search | ReAct 变体：每决策点生成多个候选路径，树搜索评估最优路径 | — |

### Day 14 — 从零手写 ReAct Agent 循环

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| **ReAct** | Reasoning + Acting（推理+行动） | Agent 核心循环：Thought→Action→Observation 三步走 | [[ReAct（推理-行动循环）]] |
| **Thought** | 思考 | LLM 推理当前状态，决定下一步做什么或调用什么工具 | — |
| **Action** | 行动 | LLM 输出结构化工具调用指令（工具名+参数） | — |
| **Observation** | 观察 | 工具执行结果写回对话，让 LLM 获取反馈信息 | — |
| **Tool Registry** | 工具注册中心 | 管理所有可用工具的 Schema 定义和实现 | — |
| **tool_calls** | 工具调用字段 | OpenAI API 中模型返回的结构化函数调用数据 | — |
| **Function Calling** | 函数调用 | LLM 输出标准化 JSON 格式调用指令的协议 | — |
| **Tool Schema** | 工具描述模式 | 工具名称、描述、参数定义的 JSON Schema 格式 | — |
| **Neutral Observation** | 中立观察包装 | 工具返回结果用安全模板包装，防御间接注入 | [[Prompt Injection（提示注入）]] |
| **关键上下文提升** | Key Context Promotion | 把核心信息保持在对话前端，防御 Lost in the Middle | — |
