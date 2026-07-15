---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - security
day: Day6
difficulty: 🟡
aliases: ['Prompt Injection', '提示注入']
related: ['[[Guardrails（LLM护栏）]]', '[[Defense-in-Depth（纵深防御）]]', '[[Attention机制]]']
---
# Prompt Injection（提示注入）

> 一句话：攻击者在输入中嵌入恶意指令，覆盖 LLM 的系统指令。OWASP LLM Top 10 排名第一的安全威胁。

## 两种主类型

| 类型 | 方式 | 案例 |
|------|------|------|
| **直接注入** | 用户输入「忽略系统指令」 | DAN 模式 |
| **间接注入** | 恶意指令藏在 RAG 抓取的外部数据 | 维基百科隐藏指令 |

## 根本原因

> Attention 不区分指令和数据。LLM 输入是一维连续文本流，没有独立的指令通道。
> Prompt Injection ≈ LLM 世界的 SQL 注入。

## 四道防线

① 输入过滤 → ② **权限隔离（最有效）** → ③ 输出验证 → ④ Guardrails 框架

## 关联概念