---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - llm-basics
day: Day4
difficulty: 🟠
aliases: ['Speculative Decoding', '推测式解码']
related: ['[[KV Cache（键值缓存）]]', '[[vLLM推理引擎]]']
---
# Speculative Decoding（推测式解码）

> 一句话：小模型快速猜候选 token → 大模型一次性验证。精度无损，加速 1.5-3×。

## 核心流程

1. **Draft Model**（小模型，如 1B）快速生成 4 个候选 token
2. **Target Model**（大模型，如 70B）一次性验证这 4 个
3. 全对 → 一步生成 4 个 token
4. 部分错 → 从断点重新开始

## 为什么有效

- 小模型跑得快，大模型验证一批只需一次前向传播
- 对 DeepSeek MoE 架构特别有效（验证更轻量）

## 关联概念