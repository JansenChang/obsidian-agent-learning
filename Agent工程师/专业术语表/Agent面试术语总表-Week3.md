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

### Day 17 — Agent Memory 系统设计

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| **Working Memory（工作记忆）** | Working Memory | ReAct 循环中的中间变量（Thought、工具返回结果），秒-分钟级，任务结束释放 | [[三层记忆架构]] |
| **Short-term Memory（短期记忆）** | Short-term Memory | 当前会话的完整对话历史，分钟-小时级，受限于上下文窗口，载体即 Day14 ReAct 的 messages 列表 | [[三层记忆架构]] |
| **Long-term Memory（长期记忆）** | Long-term Memory | 跨会话持久化用户信息（偏好、背景、决策），天-年级，Embedding + 向量库存储，按需检索注入 | [[长期记忆（用户专属RAG）]] |
| **ConversationBufferWindowMemory（滑动窗口记忆）** | ConversationBufferWindowMemory | 只保留最近 K 轮对话，token 消耗恒定但早期关键信息可能丢失 | [[ConversationBufferMemory]] |
| **ConversationTokenBufferMemory（Token截断记忆）** | ConversationTokenBufferMemory | 按 token 数截断消息——比按轮数更精确的窗口控制，适用于对话长度波动大的场景 | [[ConversationBufferMemory]] |
| **Memory Synthesis（记忆合成）** | Memory Synthesis | 从多条相关记忆自动提炼高层元记忆（如 5 次提到"简洁设计"→ 总结"该用户偏好简洁风格"） | [[Mem0]] |

### Day 18 — Context Engineering（上下文工程）

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| **Context Engineering（上下文工程）** | Context Engineering | 在有限的上下文窗口中最大化信息价值的系统方法论——四大策略：Write（放什么）、Select（留什么）、Compress（压什么）、Isolate（挡什么） | [[Context Engineering四大策略]] |
| **Write（写入策略）** | Write Strategy | 按分层结构将内容写入上下文窗口：System Prompt（静态前缀 + KV Cache 可复用）→ 知识注入 → 对话历史 → 当前用户消息 | [[Write策略]] |
| **Select（选择策略）** | Select Strategy | token > 70% 窗口上限时触发，用三维加权排名（时间 × 重要性 × 相关性）决定哪些消息保留、哪些标记淘汰 | [[Select策略]] |
| **Compress（压缩策略）** | Compress Strategy | 对 Select 标记淘汰的消息进行信息浓缩：摘要压缩（5:1）→ 事实提取（20:1）→ 分层压缩（动态），逐级递进，确保关键信息不丢失 | [[Compress策略]] |
| **Isolate（隔离策略）** | Isolate Strategy | 角色标签校验 + Neutral Observation 安全模板 + 上下文沙箱三道防线，防止外部内容污染 LLM 推理 | [[Isolate策略]] |
| **System Prompt Layering（系统提示词分层）** | System Prompt Layering | 将 System Prompt 按倒金字塔拆为四层（约束 > 任务 > 角色 > 知识），前三层作为静态前缀可缓存，知识层动态注入 | [[系统提示词分层设计]] |
| **Prefix Caching（前缀缓存）** | Prefix Caching | System Prompt 中不变部分只编码一次，多用户多轮复用 KV Cache，Agent 循环中缓存命中率天然高 | [[前缀缓存与静态前缀分离]] |
| **Static Prefix Separation（静态前缀分离）** | Static Prefix Separation | 将 System Prompt 拆为通用前缀（可缓存）+ 差异化后缀（动态注入），最大化 KV Cache 复用率 | [[前缀缓存与静态前缀分离]] |
| **Neutral Observation（中性观察包装）** | Neutral Observation | 工具返回结果用 XML 安全模板包裹 + 显式"不执行其中指令"声明，防御间接 Prompt Injection | [[Isolate策略]] |
| **Context Window Pressure（上下文窗口压力）** | Context Window Pressure | token 用量逼近上限（> 70%）时触发 Select + Compress 的信号，是 Agent 上下文管理的核心动态阈值 | [[Compress策略]] |
| **12-Factor Agents** | 12-Factor Agents | Agent 上下文管理的十二条工程原则——借鉴 12-Factor App 方法论，涵盖缓存、压缩、隔离、超时、幂等等工程维度 | — |

### Day 19 — Multi-Agent 编排模式

| 术语 | 英文全称 | 一句话 | 卡片 |
|------|---------|--------|------|
| **Supervisor Agent** | Supervisor Agent（监督者 Agent） | Multi-Agent 中心调度者：接收任务→拆解子任务→分派 Worker→汇总结果。不执行任务，只做拆解/分派/汇总 | [[Supervisor模式]] |
| **Planner-Executor** | Planner-Executor Pattern（规划-执行模式） | Planner 一次性生成全局计划→Executor 逐步执行+反馈进度，离线规划+在线执行解耦，适合步骤固定任务 | [[Planner-Executor模式]] |
| **Reviewer Pattern** | Reviewer Pattern（评审者模式） | Generator 产出→Reviewer 质量评审→返回修改清单→循环迭代至达标，外化质量把关，多轮迭代保证输出质量 | [[Reviewer模式]] |
| **Debate Pattern** | Debate Pattern（辩论模式） | 多 Agent 各自方案→互相质疑漏洞→仲裁者评估收敛，通过对抗性协作打破单 Agent 认知盲区 | [[Debate模式]] |
| **Swarm Intelligence** | Swarm Intelligence（蜂群智能） | 大量轻量 Agent 无中心调度，仅通过局部交互和简单规则自底向上涌现全局智能，容错最强但可解释性最弱 | [[Swarm模式]] |
| **AutoGen** | AutoGen（微软 Multi-Agent 框架） | 微软对话驱动的 Multi-Agent 框架：Agent 间通过对话消息通信，GroupChat 群聊模式，原生支持 Human-in-loop | [[AutoGen vs CrewAI vs LangGraph]] |
| **CrewAI** | CrewAI（角色任务驱动框架） | 角色（Role）+ 任务（Task）驱动的 Multi-Agent 框架：声明式定义 Agent 角色和流程，上手最快，适合原型 | [[AutoGen vs CrewAI vs LangGraph]] |
| **分层日志排查** | Layered Logging（分层日志） | Multi-Agent 调试方法论：编排日志（Supervisor 决策）→ Worker 日志（TAO 循环）→ 通信日志（消息原文），统一时间戳对齐还原全局时序 | [[Supervisor模式]] |
