---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - security
day: Day6
difficulty: 🟡
aliases: ['Guardrails', 'LLM护栏']
related: ['[[Prompt Injection（提示注入）]]', '[[Defense-in-Depth（纵深防御）]]']
---
# Guardrails（LLM 护栏）

> 一句话：把安全策略从 Prompt 解耦到代码层，用硬规则定义 LLM 的安全边界。

## 两大框架

| 框架 | 特点 |
|------|------|
| **NVIDIA NeMo Guardrails** | 三种护栏：话题/安全/执行 |
| **Guardrails AI** | YAML 配置，开发者友好 |

## 三种护栏（NeMo）

| 类型 | 作用 |
|------|------|
| **话题护栏** | 控制能聊的话题范围 |
| **安全护栏** | 检测仇恨/暴力/色情 |
| **执行护栏** | 控制工具调用权限 |

## 与 Prompt 约束的区别

> Prompt 约束 = 软约束（模型可以选择不服从）
> Guardrails = 硬规则（代码层拦截，模型无法绕过）

## 关联概念