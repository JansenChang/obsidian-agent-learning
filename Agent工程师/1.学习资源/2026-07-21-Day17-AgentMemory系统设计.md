---
date: 2026-07-21
tags: [agent, memory, long-term-memory, short-term-memory, mem0, interview, day17]
source: AI面试学习系统
audio: "[[Day17-AgentMemory系统设计.mp3]]"
status: completed
day: Day17
difficulty: 🔴
related:
  - "[[2026-07-16-Day14-从零手写ReAct Agent循环]]"
  - "[[2026-07-20-Day15-ReAct原理深挖与面试穿透]]"
  - "[[2026-07-20-Day16-FunctionCalling与ToolUse协议深度对比]]"
  - "[[2026-06-24-Day8-RAG基础流程与Embedding]]"
  - "[[2026-07-03-Day13-RAG深度优化与Lost in the Middle]]"
---

# Day 17 — Agent Memory 系统设计

## 🎯 核心概念

| 概念 | 一句话 | 等级 |
|------|--------|:---:|
| **三层记忆架构** | 工作记忆（秒-分）→ 短期记忆（分-时）→ 长期记忆（天-年） | 🔴 |
| **ConversationBufferMemory** | 全量缓存对话历史，最简但 token 线性膨胀 | 🔴 |
| **ConversationBufferWindowMemory** | 滑动窗口，只保留最近 K 轮 | 🔴 |
| **ConversationSummaryMemory** | LLM 逐轮压缩旧消息为摘要 | 🔴 |
| **ConversationTokenBufferMemory** | 按 token 数截断，最精确的窗口控制 | 🟠 |
| **长期记忆 = 用户专属 RAG** | Embedding → 向量库存储 → 相似度检索 → 注入上下文 | 🔴 |
| **Mem0** | 自动提取+去重合并+层级存储的长期记忆系统 | 🔴 |
| **遗忘策略** | 时间衰减 + 重要性评分 + 容量淘汰 + 用户主动删除 | 🟠 |
| **记忆质量评估** | 召回率 / 精度 / 时效性，轨迹评估 > 端到端评估 | 🟠 |

---

## 🧠 三层记忆架构

```
工作记忆 (秒-分钟)
  └─ ReAct 中间变量：Thought、工具返回结果、临时状态
  └─ 程序内存 / Redis 短期缓存

短期记忆 (分钟-小时)
  └─ 当前会话完整对话历史
  └─ 上下文窗口（128K-200K token）
  └─ Day14 ReAct 的 messages 列表即短期记忆

长期记忆 (天-年)
  └─ 跨会话持久化：用户偏好、背景、历史决策
  └─ 向量数据库 + Embedding
  └─ 按需检索 → 注入 System Prompt 或 Thought 前
```

---

## 📦 短期记忆四种实现

| 模式 | 做法 | ✅ | ❌ |
|------|------|-----|-----|
| **Buffer** | 全量保留 | 信息完整 | token 线性膨胀 + Lost in the Middle |
| **Window** | 只保留最近 K 轮 | token 恒定 | 早轮关键信息丢失 |
| **Summary** | LLM 压缩旧消息 | 控制 token 不丢要点 | 摘要精度依赖 LLM，额外调用成本 |
| **TokenBuffer** | 按 token 数截断 | 精确窗口控制 | 无情丢弃超限消息 |

**生产系统推荐：混合模式** — 最近 N 轮全量 + 更早的摘要 + 超远历史丢弃

---

## 🗄️ 长期记忆架构

```
对话结束 → 后台 LLM 提取事实 → 去重合并 → Embedding → 向量库
                                                        ↓
新对话/新话题 → Embedding 当前上下文 → 相似度检索 → Top-K → 注入
```

**与 RAG 的关系：长期记忆 = 用户专属 RAG**
- 相同技术栈：Embedding + 向量库 + Rerank
- 唯一区别：存储的是用户事实 vs 外部文档

---

## 🔄 记忆更新时机

| 策略 | 时机 | 风险 |
|------|------|------|
| **同步更新** | ReAct 每步后立即写 | 错误事实污染后续循环 |
| **异步批量** | 对话结束后统一写 | 当前对话内看不到新记忆 |
| **混合** | 高优先级事实同步 + 普通事实异步 | 实现复杂度高 |

**推荐：异步批量为主**。关键信息（如权限变更）例外用同步。

---

## 📉 遗忘策略四道防线

| 维度 | 机制 |
|------|------|
| **时间衰减** | 旧事件降权，但核心偏好不过期 |
| **重要性评分** | 高频检索加分，从未检索降分 → 阈值淘汰 |
| **容量淘汰** | 类比 OS 页面置换，低分优先驱逐 |
| **用户主动删除** | 按用户 ID 精确删除，含审计日志 |

---

## 🔗 知识连接

| 连接 | 内容 |
|------|------|
| **× Day8-13 RAG** | 长期记忆的检索管道完全复用 RAG：Chunking→Embedding→向量库→Rerank |
| **× Day14 ReAct** | 消息列表 = 短期记忆载体；长期记忆在 Thought 前注入 |
| **× Day15 评估三层次** | 记忆评估：组件（提取/检索）→ 轨迹（推理用对记忆）→ 端到端（对话质量） |
| **× Day13 Lost in the Middle** | Buffer 模式放大该问题，Summary/Window 是解法 |

---

## 🎯 明天预告

Day18 — Agent Loop 与 Context Engineering：Google 四大策略（Write/Select/Compress/Isolate）+ 工程化上下文管理
