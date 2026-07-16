---
date: 2026-07-16
tags: [agent, react, agent-loop, tool-use, function-calling, interview, day14]
source: AI面试学习系统
audio: "[[Day14-从零手写ReAct Agent循环.mp3]]"
status: completed
day: Day14
difficulty: 🟡
related:
  - "[[2026-03-02-Agent ReAct框架学习]]"
  - "[[2026-06-24-Day7-周回顾-LLM推理全链路]]"
  - "[[2026-06-22-Day5-Prompt工程与思维链]]"
  - "[[2026-06-21-Day4-KV Cache与vLLM推理加速]]"
---

# Day 14 — 从零手写 ReAct Agent 循环

## 🎯 核心概念

| 概念 | 一句话 | 等级 |
|------|--------|:---:|
| **ReAct 循环** | Agent 核心循环：Thought→Action→Observation 三步交替 | 🟡 |
| **Thought（思考）** | LLM 推理当前状态，决定做什么 | 🟡 |
| **Action（行动）** | LLM 输出结构化工具调用指令 | 🟡 |
| **Observation（观察）** | 工具执行结果写回对话 | 🟡 |
| **Tool Registry（工具注册中心）** | 管理所有可用工具的 Schema 定义 | 🟡 |
| **tool_calls** | OpenAI API 中模型返回的结构化函数调用 | 🟡 |
| **Function Calling** | LLM 输出标准化 JSON 格式调用指令的协议 | 🟡 |
| **Neutral Observation** | 工具返回结果用安全模板包装，防御间接注入 | 🟠 |

---

## 🧱 ReAct Loop 骨架（伪代码）

```
1. 构造初始消息列表（system + user）
2. 调用 LLM，传入上下文 + tools Schema
3. 解析响应
   ├─ 有 tool_calls → 校验参数 → 执行工具 → 追加结果到消息列表 → 检查迭代上限 → 回到 2
   └─ 无 tool_calls → 作为最终答案返回
4. 超限 → 返回超时提示
```

---

## 🔧 工具 Schema 格式（OpenAI）

```
{
  "type": "function",
  "function": {
    "name": "query_order",
    "description": "查询订单状态，传入订单编号",
    "parameters": {
      "type": "object",
      "properties": {
        "order_id": { "type": "string", "description": "订单编号" }
      },
      "required": ["order_id"]
    }
  }
}
```

---

## 🎯 面试高频边界问法

| 场景 | 回答要点 |
|------|---------|
| 工具调用失败 | 返回错误信息让 LLM 自决（重试或告知用户） |
| 无限循环 | 最大迭代次数 + 连续相同工具检测 |
| 参数校验 | 执行前校验 Schema，不合规报错 |
| 并行工具调用 | 多 tool_calls 循环处理，标注调用 ID |
| 上下文管理 | 保留最近 3 轮完整 TAO 序列，更早压缩为摘要 |
| 结果格式统一 | 统一包装：成功状态 + 数据 + 可读描述 |
| 工具 Description | 回答三个问题：做什么 / 何时用 / 不要何时用 |

---

## 🔗 知识连接

| 连接 | 内容 |
|------|------|
| **× Day5 CoT** | CoT 只有 Thought，ReAct 是 Thought + Action + Observation |
| **× Day2 Temperature** | Agent 场景推荐 0.2-0.5，调低更稳定、调高更探索 |
| **× Day4 vLLM** | ReAct 循环需多次调用 LLM，推理加速直接影响用户体验 |
| **× Day8 Lost in the Middle** | 循环多次后关键信息被埋没 → 关键上下文提升 |
| **× Day6 间接注入** | 工具返回结果可能藏恶意指令 → Neutral Observation 包装 |

---

## ❓ 面试示例回答

**Q：请手写一个 ReAct Agent 的核心逻辑。**

A：ReAct 循环分四步。第一，构造消息列表，包含 system prompt 和用户消息。第二，调用 LLM 并传入 tools Schema。第三，检查响应——如果有 tool_calls，提取工具名和参数，执行工具，把结果包装成 tool 消息追加到对话，检查迭代次数，没超限就继续循环。第四，如果没有 tool_calls，返回自然语言答案。中间需要处理参数校验、错误恢复、并行调用、上下文管理等边界情况。
