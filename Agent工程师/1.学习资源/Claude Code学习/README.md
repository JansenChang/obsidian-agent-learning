---
tags: [ClaudeCode, 学习资源, Agent工程师]
date: 2026-03-29
---

# Claude Code 学习资源

## 📁 目录结构

```
Claude Code学习/
├── README.md                          # 本文件 - 资源说明
├── 学习排期.md                        # 整体学习时间安排与进度跟踪
├── Claude Code学习计划.md             # 详细学习计划（28天）
├── Claude Code学习笔记索引.md         # 所有笔记的索引和模板
├── Claude Code核心概念理解.md         # 核心理念和12个机制概述
├── 环境准备检查清单.md                # 环境配置的逐步指南
└── s01 - Agent循环机制.md            # 第一课的详细学习笔记模板
```

## 🎯 学习目标

掌握构建类似Claude Code的AI代理工具，理解"模型就是Agent，代码是Harness"的核心思想，并把 Claude Code 放回更完整的 Agent 工程语境中去理解。

### 核心格言
> **模型就是Agent，代码是Harness**

### 这份资料的定位

这里不只是学习 Claude Code 本身，而是把 **Claude Code 当成主线案例**：

- 用它理解 `Agent loop`
- 用它理解 `tools / planning / subagents / context compression`
- 再把这些机制映射到 OpenAI Agents、MCP、OpenClaw、Hermes 等更通用的 Agent 工程体系里

换句话说：

- `Claude Code` 负责给你一个可感知、可拆解、可实践的主案例
- `其他官方资料和仓库` 负责帮助你建立更完整的通用 Agent 架构视角

## 📚 学习顺序建议

### 第一步：建立整体认知
1. **阅读学习排期**：了解整体时间安排
2. **阅读学习计划**：了解详细的学习路线
3. **阅读核心概念**：建立正确的心智模型
4. **带着一个问题去读**：Claude Code 里每个机制，在通用 Agent 系统里分别对应什么

### 第二步：环境准备
1. **按照检查清单**：配置开发环境
2. **克隆项目**：获取学习代码
3. **测试运行**：验证环境正常

### 第三步：系统学习
1. **按顺序学习**：s01 → s02 → ... → s12
2. **理论+实践**：每个课程都包含理解和练习
3. **及时记录**：使用提供的笔记模板
4. **同步映射**：每学完一课，都问自己它和 OpenAI / MCP / OpenClaw / Hermes 的哪一层最接近

## 🧩 Claude Code 与通用 Agent 架构的结合方式

为了避免把学习看散，建议把 `learn-claude-code` 里的 12 个机制，当成你理解通用 Agent 工程的主线入口。

### 一条总主线

你可以先这样理解：

- `Claude Code`：教你 Harness 是怎么搭起来的
- `OpenAI Agents`：教你现代 Agent runtime 通常包含什么
- `MCP`：教你工具与资源为什么需要统一协议层
- `OpenClaw`：教你系统 prompt、workspace、sandbox、多 Agent 路由这些系统层问题
- `Hermes`：教你长期运行 Agent 的 loop、memory、skills、持久化

所以更好的学法不是“分别学五套东西”，而是：

**用 Claude Code 的课程顺序，串起整个 Agent 工程知识图谱。**

### 课程机制映射表

| Claude Code 课程 | 在通用 Agent 工程里对应什么 | 建议联想的资料 |
|---|---|---|
| `s01 Agent循环` | 最小 Agent loop、决策闭环 | Anthropic `Building effective agents`、Hermes `Agent Loop` |
| `s02 工具使用` | tool calling、工具注册、执行边界 | OpenAI `Agents SDK`、MCP 文档 |
| `s03 TodoWrite规划` | planning、任务分解、执行计划 | Anthropic `workflow vs agent` 思路 |
| `s04 子智能体` | subagents、handoff、职责拆分 | OpenAI `handoffs`、OpenClaw `multi-agent` |
| `s05 Skill加载` | 知识注入、按需上下文装配 | OpenClaw `system prompt`、Hermes `skills` |
| `s06 上下文压缩` | context management、记忆边界 | Hermes `memory`、Claude Code 自身压缩机制 |
| `s07 任务系统` | 状态持久化、任务恢复 | OpenAI `sessions/tracing`、Hermes 持久化思路 |
| `s08 后台任务` | 异步执行、长任务管理 | 长运行 Agent / automation 思维 |
| `s09 智能体团队` | 多 Agent 协作架构 | OpenClaw `multi-agent`、团队型 Harness |
| `s10 团队协议` | Agent 间通信契约、消息边界 | OpenClaw `delegate architecture`、协议设计 |
| `s11 自治智能体` | autonomy、持续运行、主动行为 | Hermes `cron / memory / long-running` 思路 |
| `s12 Worktree隔离` | sandbox、隔离执行、安全边界 | OpenClaw `sandbox`、Claude Code 工程安全设计 |

### 学每一课时都问自己的 6 个问题

无论你现在学到哪一课，都尽量回答下面这 6 个问题：

1. 这个机制解决的是 Agent 的哪一个核心问题？
2. 这里是 **模型在做决定**，还是 **代码在提供环境**？
3. 这个机制和 `tools / memory / planning / handoff / sandbox / tracing` 哪一类最接近？
4. 如果没有这个机制，系统会在哪一类任务上失效？
5. 这个机制更偏“单 Agent 增强”，还是“系统层工程能力”？
6. 它和 OpenAI / MCP / OpenClaw / Hermes 里哪类概念能对应上？

## 🔗 相关资源

### 本地资源
- **项目代码**：`/Users/jansen/.openclaw/workspace-learning/learn-claude-code/`
- **前期学习**：同目录下的其他学习笔记（2026-02-26 至 2026-03-07）
- **学习日记**：`../2.学习日记/` 目录
- **题库自查**：`../3.题库自查/` 目录

### 外部资源
- **项目GitHub**：https://github.com/shareAI-lab/learn-claude-code
- **官方文档**：https://docs.anthropic.com/claude/docs/claude-code
- **相关项目**：
  - Kode CLI：https://github.com/shareAI-lab/Kode-cli
  - Kode SDK：https://github.com/shareAI-lab/Kode-agent-sdk
  - claw0：https://github.com/shareAI-lab/claw0
  - OpenClaw：https://github.com/openclaw/openclaw

### 与课程同步阅读的官方资料

下面这些资料不是“课外阅读”，而是建议穿插进主线里的：

- **Anthropic: Building effective agents**
  - 网址：https://www.anthropic.com/engineering/building-effective-agents
  - 用途：帮助你理解 `workflow` 和 `agent` 的边界

- **OpenAI Agents**
  - 网址：https://platform.openai.com/docs/guides/agents
  - 用途：帮助你建立 `models / tools / knowledge / evals` 的平台视角

- **OpenAI Agents SDK**
  - 网址：https://platform.openai.com/docs/guides/agents-sdk/
  - 用途：帮助你把 Claude Code 的机制映射到现代 Agent runtime

- **Anthropic MCP**
  - 网址：https://docs.anthropic.com/en/docs/mcp
  - 用途：帮助你理解工具协议层，而不是只停留在“会调工具”

- **OpenClaw Concepts**
  - System Prompt：https://docs.openclaw.ai/concepts/system-prompt
  - Multi-Agent：https://docs.openclaw.ai/concepts/multi-agent
  - Delegate Architecture：https://docs.openclaw.ai/concepts/delegate-architecture
  - 用途：帮助你理解 prompt 注入、workspace、身份边界、多 Agent 路由

- **Hermes Agent Docs**
  - Agent Loop：https://hermes-agent.nousresearch.com/docs/developer-guide/agent-loop/
  - Memory：https://hermes-agent.nousresearch.com/docs/user-guide/features/memory/
  - 用途：帮助你理解 loop、记忆、长期运行和持久化

### 与课程同步认识的参考仓库

这些仓库不用一开始深翻源码，但建议知道它们在知识图谱里的位置：

- **OpenAI Agents Python**
  - https://github.com/openai/openai-agents-python
  - 作用：帮助你理解现代 Agent SDK 典型结构

- **Model Context Protocol**
  - https://github.com/modelcontextprotocol/modelcontextprotocol
  - https://github.com/modelcontextprotocol/servers
  - 作用：帮助你理解协议层和参考 server 实现

- **OpenClaw**
  - https://github.com/openclaw/openclaw
  - 作用：帮助你理解 Agent 运行时系统

- **Hermes Agent**
  - https://github.com/NousResearch/hermes-agent
  - 作用：帮助你理解长期运行 Agent 的 loop、memory、skills、MCP、cron

## 📝 笔记系统

### 笔记模板
每个课程都有对应的笔记模板，包含：
- 学习目标
- 核心概念
- 关键代码
- 理解要点
- 实践练习
- 常见问题
- 学习检查

### 学习记录
建议在学习过程中：
1. **每日记录**：在笔记中记录学习进度
2. **问题记录**：记录遇到的疑问和解决方法
3. **思考记录**：记录个人的理解和思考
4. **复习标记**：标记需要复习的内容

## 🎯 学习检查点

### 阶段检查
- **s03后**：能解释为什么Agent需要规划
- **s06后**：能说明上下文压缩的三种策略
- **s09后**：能描述团队协作的基本模式
- **s12后**：能完整解释harness工程的12个机制

### 最终评估
- **理解深度**：能用自己的话解释核心概念
- **实践能力**：能修改和扩展示例代码
- **应用能力**：能设计简单的harness架构
- **表达能力**：能向他人讲解所学内容

## ⚠️ 注意事项

### 学习原则
1. **不要跳课**：每个机制都是下一个的基础
2. **理解优先**：先理解"为什么"，再写代码
3. **最小化**：每个课程只关注一个核心机制
4. **实践验证**：通过修改代码来验证理解

### 时间管理
- **每日学习**：建议2-3小时
- **持续学习**：28天系统学习
- **定期复习**：每周回顾已学内容
- **进度跟踪**：使用学习排期记录进度

## 🆘 帮助与支持

### 问题解决
1. **环境问题**：参考环境准备检查清单
2. **代码问题**：查看GitHub Issues或文档
3. **概念问题**：回顾核心概念理解文档
4. **进度问题**：调整学习计划，保持节奏

### 学习支持
- **笔记系统**：使用提供的模板记录学习
- **进度跟踪**：定期更新学习排期
- **知识连接**：与前期学习内容建立联系
- **实践应用**：设想实际应用场景

---

**开始学习时间：** 2026-03-29  
**预计完成时间：** 2026-04-25  
**学习状态：** 🟡 进行中（第1天）

**今日任务：** 环境准备 + s01学习  
**学习建议：** 从核心概念理解开始，建立正确的心智模型
