---
created: 2026-02-26
updated: 2026-07-16
tags:
  - index
  - learning-plan
  - agent-engineer
status: 进行中
---

# 🤖 Agent 工程师学习系统

> **目标：** 系统掌握 AI Agent 工程师核心知识体系，对标工业界面试要求，覆盖 LLM 推理 → Agent 开发实现 → RAG 全栈 → 生产化部署 → 面试冲刺
>
> **当前进度：** Day 13 | 🟡 第二阶段 RAG 专题已完成（Day13 待打卡确认）
>
> **知识结构诊断：** ✅ LLM 推理原理 + ✅ RAG 全栈 → ❌ **Agent 开发实现层严重缺失**（L2 为空）

---

## 📊 已完成内容总览

### 第一阶段：基础理论（2026/02 → 2026/03）✅

| 主题 | 核心内容 |
|:---|:---|
| AI Agent 基础 | Agent 定义、核心特征、传统 AI 对比 |
| ReAct 框架 / Plan-and-Execute / Reflexion | 三大架构模式 |
| 工具调用机制 | 注册、选择、参数、结果解析 |
| 记忆系统 | 短期/长期记忆、向量化检索 |
| LangChain 入门 | 链式调用、工具集成 |
| ACL 消息 & FIPA 标准 | Agent 通信协议 |

### 第二阶段实战：LLM 推理优化（2026/06）✅

| Day | 主题 | 核心内容 |
|:---:|:---|:---|
| Day1 | Transformer & Attention | MHA → MQA → GQA → RoPE → FlashAttention → MLA |
| Day2 | Decoding 策略 | Greedy / Beam Search / Top-K / Top-P / Temperature / Speculative Decoding |
| Day3 | Tokenization | BPE 分词原理 |
| Day4 | KV Cache & vLLM | PagedAttention / Continuous Batching |
| Day5 | Prompt 工程 & 思维链 | CoT / ToT / Prompt 设计模式 |
| Day6 | Prompt Injection 防御 | 直接/间接注入、纵深防御四道防线 |
| Day7 | 周回顾 | LLM 推理全链路串联复习 |

### 第二阶段实战：RAG 全栈（2026/06 → 2026/07）✅

| Day | 主题 | 核心内容 |
|:---:|:---|:---|
| Day8 | RAG 基础 & Embedding | RAG 三阶段、Embedding 选型、Lost in the Middle |
| Day9 | Chunking & Hybrid Search | 语义分块、BM25+Embedding+RRF |
| Day10 | Re-ranking & 查询优化 | Bi-Encoder/Cross-Encoder、查询改写/分解、缓存 |
| Day11 | Agentic RAG & GraphRAG | Corrective/Self-RAG/HyDE/Multi-Hop、实体关系图 |
| Day12 | 向量数据库选型 & 部署 | HNSW/IVF/DiskANN、Milvus/Qdrant/Chroma/PGVector/Pinecone |
| Day13 | RAG 评估与持续优化 | Hit Rate / MRR / LLM-as-a-Judge、四大翻车场景 |

### 已产出统计

| 产出 | 数量 |
|:---|:---:|
| 学习资源（教案） | 27 篇 |
| 知识卡片 | 27 张 |
| 音频（mp3+文稿） | 13 套 |
| 学习日记 | 15 篇 |
| 题库自查 | 5 篇 |
| 专业术语表 | 2 份（Week1 推理 + Week2 RAG） |

---

## 🧠 GitHub 调研：你的知识位置

基于对 GitHub 上顶级 Agent 学习资源（AgentGuide ⭐7,045、awesome-agentic-ai-zh ⭐4,562、awesome-agentic-patterns ⭐4,802 等）的系统调研，你的知识结构如下：

### 你在 AgentGuide 体系中的位置

```
AgentGuide 知识体系
═══════════════════════════════════
L1 基础认知层 (1-2周)
├─ 模块1: Agent核心概念 ═══ ✅ 已学（基础理论）
├─ 模块2: 技术演进史 ══════ ✅ 已学
└─ 模块3: 大模型原理 ══════ ✅ 已学（Day1-7）

L2 开发实现层 (3-4周) ← ⚠️ 当前最重要缺口
├─ 模块4: 经典Agent范式手撕 ═══ ❌ 未学 ← 最紧急
├─ 模块5: 低代码平台 ═══════════ ❌ 未学
├─ 模块6: 主流框架实战 ════════ ❌ 未学（LangGraph/AutoGen/CrewAI）
└─ 模块7: 自研Agent框架设计 ═══ ❌ 未学

L3 高阶优化层 (4-5周)
├─ 模块8: RAG全栈 ═══════════ ✅ 已学（Day8-13，深度足够）
├─ 模块9: 上下文工程 ═════════ ❌ 未学 ← 面试高频
├─ 模块10: 智能体通信协议 ════ ❌ 未学（MCP/A2A）
├─ 模块11: 模型微调与RL ═════ ⚠️ 部分（可选）
└─ 模块12: 性能评估 ═════════ ❌ 未学

实战项目 (8个) ═══════════════ ❌ 未启动
面试题库 (300+题) ════════════ ❌ 未刷
```

**核心诊断：知识结构是"两头有，中间空"**
- ✅ 顶层（LLM 原理、Agent 概念）已有
- ✅ 底层（RAG 工程实践）深度甚至超过 AgentGuide
- ❌ **中间层（Agent 开发实现能力）完全缺失** — 这是面试的核心考点，也是招人的硬性门槛

### 缺失的核心模块（按优先级）

| 优先级 | 模块 | 说明 | 参考资源 |
|:---:|:---|:---|:---|
| 🔴 **P0** | **Agent 核心范式手撕** | ReAct Loop、Plan-Execute、Reflection 手工实现。面试必问，「请手写一个 ReAct Agent」 | AgentGuide L2-模块4 |
| 🔴 **P0** | **Tool Use 与 Function Calling** | 工具注册、Schema 设计、权限分级、容错恢复 | AgentGuide + learn-claude-code |
| 🔴 **P0** | **LangGraph 框架实战** | 图编排 Agent、状态管理、条件分支。工业界主流 | AgentGuide L2-模块6 |
| 🟡 **P1** | **Context Engineering** | System Prompt 分层、四大策略（Write/Select/Compress/Isolate）、KV Cache 优化 | AgentGuide L3-模块9 |
| 🟡 **P1** | **Agent 评估体系** | Component Eval、Trajectory Eval、LLM-as-Judge、消融实验 | AgentGuide L3-模块12 |
| 🟡 **P1** | **Multi-Agent 协调** | Supervisor/Planner/Executor 模式、消息队列、冲突解决 | awesome-agentic-patterns |
| 🟡 **P2** | **MCP / A2A 协议** | 工具标准化、跨 Agent 通信、MCP Server 实操 | AgentGuide L3-模块10 |
| 🟢 **P3** | **Agent 生产化** | 幂等性、超时重试、成本守卫、可观测性、安全 | AgentGuide 系统设计 |
| 🟢 **P3** | **Agent 微调 (RL)** | 轨迹数据合成、GRPO/DPO、Agent 专用模型 | AgentGuide L3-模块11 |

---

## 🗺️ 新学习规划（8-10周 → 面试冲刺）

### 关键资源索引

调研了 GitHub 上 50+ 高质量项目后，筛选出与你的定位最匹配的资源：

| 资源 | ⭐ | 用途 |
|:---|:---:|:---|
| **[adongwanai/AgentGuide](https://github.com/adongwanai/AgentGuide)** | 7,045 | **主线教材** — 求职导向，300+面试题，体系最完整 |
| **[datawhalechina/hello-agents](https://github.com/datawhalechina/hello-agents)** | 66,595 | **中文补强** — Datawhale 从零搭建 Agent，中文教程标杆 |
| **[shareAI-lab/learn-claude-code](https://github.com/shareAI-lab/learn-claude-code)** | 71,187 | **Harness 实践** — s01-s12 机制学习（已本地克隆） |
| **[nibzard/awesome-agentic-patterns](https://github.com/nibzard/awesome-agentic-patterns)** | 4,802 | **设计模式参考** — 8 大类 120+ 生产级模式 |
| **[wdndev/llm_interview_note](https://github.com/wdndev/llm_interview_note)** | 14,715 | **面试题库** — LLM 面试笔记，14.7K⭐ |
| **[WenyuChiou/awesome-agentic-ai-zh](https://github.com/WenyuChiou/awesome-agentic-ai-zh)** | 4,562 | **学习地图** — 三语路线图，240+ 资源导航 |
| **[bcefghj/ai-agent-interview-guide](https://github.com/bcefghj/ai-agent-interview-guide)** | 1,596 | **Agent 面试专项** — 200+题，三语言企业级项目 |

### 阶段一：补 Agent 开发实现核心（3周）

**目标**：填补"两头有、中间空"的缺口，建立 Agent 开发实现能力

| 周 | 内容 | 产出物 | 参考 |
|:---:|:---|:---|:---:|
| **W1** | **ReAct 范式手撕**：从零实现 Thought→Action→Observation 循环；Tool Registry & Schema 设计；Plan-Execute 架构 | 手工 ReAct Agent 代码 | AgentGuide L2-模块4 + hello-agents |
| **W2** | **LangGraph 框架实战**：状态图、节点/边、条件分支；用 LangGraph 重写 ReAct Agent；Tool Calling 集成 | LangGraph Agent 原型 | AgentGuide L2-模块6 + awesome-agentic-patterns |
| **W3** | **多 Agent 协调**：Supervisor/Planner/Executor/Reviewer 模式；消息队列、任务编排 | 多 Agent 协作 Demo | AgentGuide L2-模块7 + learn-claude-code s04/s07 |

**每日节奏**：学习 2h + daily cron 推送复习（SM-2）+ 每周末编码实践

### 阶段二：深化 + 简历级项目（3周）

**目标**：掌握面试高频考点，完成 1-2 个可写进简历的完整项目

| 周 | 内容 | 产出物 | 参考 |
|:---:|:---|:---|:---:|
| **W4** | **Context Engineering 四大策略**：System Prompt 分层设计、Memory 三层架构（Working/Episodic/Semantic）、上下文压缩/隔离 | Context 管理笔记 + Demo | AgentGuide L3-模块9 |
| **W5** | **Agent 评估体系 + MCP 协议**：Golden Dataset 构建、LLM-as-Judge、Component/Trajectory Eval；MCP Server 实操 | Agent Eval 框架 + MCP Demo | AgentGuide L3-模块10+12 + awesome-agentic-patterns |
| **W6** | **简历级项目**：选择 Paper Agent（RAG 检索）或 Travel Agent（Multi-Agent 协作），完成 end-to-end 实现 | 完整项目代码 + README | AgentGuide 实战项目 |

**项目选择指南**：
- **Paper Agent**（论文检索 RAG）— 贴合你已有的 RAG 知识，快速出活
- **Travel Agent**（多 Agent 机票+酒店推荐）— 更显 Multi-Agent 能力
- **Deep Research Agent**（自主深度搜索）— Agentic RAG 的终极形式

### 阶段三：面试冲刺（2-3周）

**目标**：刷完 300+ 面试题，完成模拟面试，简历写到位

| 周 | 内容 | 参考 |
|:---:|:---|:---|
| **W7** | **系统刷题**：Agent 系统 52 题 + RAG 22 题 + 手撕代码 34 题 | AgentGuide 面试题库 + llm_interview_note |
| **W8** | **手撕代码训练**：Self-Attention、ReAct Loop、RoPE、Tool Registry、KV Cache | AgentGuide 手撕代码 34 题 |
| **W9** | **模拟面试 + 简历完善**：STAR 项目讲述、谈薪策略、大厂面经复盘 | AgentGuide 求职模块 + ai-agent-interview-guide |

### 并行线

| 线 | 内容 | 频率 |
|:---|:---|:---:|
| 📚 **SM-2 间隔复习** | 每日 21:00 cron 推送当天知识卡片复习 | 每日 |
| 🎧 **通勤音频** | 每阶段结束后生成 30min 复盘音频 | 每阶段末 |
| 🔍 **知识扩展** | 每周日自动扫 B站/知乎新内容 | 每周 |

---

## 📁 目录结构

```
Areas/学习/Agent工程师/
├── README.md                          ← 你在此处（总规划）
├── 思维导图-Agent工程师知识体系.md     ← 总体知识框架
├── 1.学习资源/                        ← 每日教案
│   ├── YYYY-MM-DD-Day{N}-{Topic}.md   ← 结构化教案
│   ├── 学习排期.md                    ← 详细排期
│   └── Claude Code学习/               ← Harness 专项
├── 2.学习日记/                        ← 个人记录
├── 3.题库自查/                        ← 面试自测
├── 知识卡片/                          ← 原子概念卡片
├── 专业术语表/                        ← 术语索引
└── 音频资料/                          ← 通勤音频
```

---

## 🔗 外部资源速查

| 用途 | 资源 | URL |
|:---|:---|:---|
| 主线教材 | AgentGuide | https://github.com/adongwanai/AgentGuide |
| 中文入门 | hello-agents | https://github.com/datawhalechina/hello-agents |
| Harness 学习 | learn-claude-code | 本地 `~/.openclaw/workspace-learning/learn-claude-code/` |
| 设计模式 | awesome-agentic-patterns | https://github.com/nibzard/awesome-agentic-patterns |
| 面试题库 | llm_interview_note | https://github.com/wdndev/llm_interview_note |
| 学习路线图 | awesome-agentic-ai-zh | https://github.com/WenyuChiou/awesome-agentic-ai-zh |
| Agent 面试 | ai-agent-interview-guide | https://github.com/bcefghj/ai-agent-interview-guide |
| 公开仓库 | obsidian-agent-learning | https://github.com/JansenChang/obsidian-agent-learning |

---

## ✅ 待办（下一步）

- [ ] Day13 打卡确认，标记 RAG 专题正式收尾
- [ ] 确认新学习规划路线
- [ ] 更新学习排期.md（详细到每天）
- [ ] 更新思维导图进度标记
- [ ] W1 启动：从零手写 ReAct Agent
