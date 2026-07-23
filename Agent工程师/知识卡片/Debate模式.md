---
created: 2026-07-23
tags: [knowledge-card, agent-interview, multi-agent, agent-core, decision-making]
day: Day19
difficulty: 🟠
aliases: [Debate Pattern, Adversarial Collaboration, 辩论模式, Multi-Perspective Reasoning]
related: ["[[Reviewer模式]]", "[[Multi-Agent模式对比]]", "[[Swarm模式]]", "[[ReAct失败模式]]", "[[AutoGen vs CrewAI vs LangGraph]]"]
---

# Debate 模式

> 一句话：多个 Agent 各自独立产出方案→互相质疑对方方案中的漏洞→仲裁者评估辩论过程→收敛到最优方案。通过对抗性协作打破单 Agent 的认知盲区，适用于多角度决策和高风险判断场景。

## 核心机制

### 架构拓扑

```
   ┌──────────┐      ┌──────────┐
   │ Agent A  │ ←──→ │ Agent B  │
   │ 方案A    │ 质疑  │ 方案B    │  ← 互相质疑、指出漏洞
   └────┬─────┘      └────┬─────┘
        │                 │
        └────────┬────────┘
                 ▼
          ┌───────────┐
          │ Arbitrator│ ← 仲裁者（不产生方案，只评估辩论质量）
          │ 评估+收敛   │
          └───────────┘
```

### 辩论流程

```python
def debate_mode(task, n_agents=3, max_rounds=3):
    # 第一轮：各自生成方案
    proposals = [agent.generate(task) for agent in agents]
    
    for round in range(max_rounds):
        # 交叉质疑
        critiques = []
        for i, prop in enumerate(proposals):
            # 每个 Agent 评审其他所有方案
            for j, other_prop in enumerate(proposals):
                if i != j:
                    critique = agents[i].critique(other_prop)
                    critiques.append((i, j, critique))
        
        # Agent 根据质疑修改方案
        for i in range(n_agents):
            all_feedback = [c for (tgt, src, c) in critiques if tgt == i]
            proposals[i] = agents[i].revise(proposals[i], all_feedback)
        
        # 仲裁者评估收敛度
        if arbitrator.check_convergence(proposals, critiques):
            break
    
    return arbitrator.pick_best(proposals, critiques)
```

### 三种辩论策略

| 策略 | 机制 | 优点 | 缺点 |
|------|------|------|------|
| **交叉质询** | 每个 Agent 评审其他所有 Agent 的方案 | 覆盖全面 | O(n²) 通信成本 |
| **两两对决** | 淘汰赛制：胜者晋级下一轮 | 成本可控 | 可能遗漏最佳方案 |
| **共识辩论** | 所有 Agent 共同讨论，逐点达成共识 | 输出凝聚 | 耗时长，容易妥协 |

### 收敛机制

```
辩论轮次:  R1        R2        R3
         方案分歧大 → 质疑修正 → 观点收敛 → 仲裁选出最优
         
收敛信号:
- 多轮后方案间相似度 > 阈值
- 连续两轮质疑点不重复（已穷尽）
- 仲裁者判断"分歧已澄清"
```

## 面试要点

1. **Debate 模式解决的核心问题**——单 Agent 存在"确认偏误"：自己倾向于找支持自己方案的理由，忽略反例。Debate 用对抗性 Agent 强制发现漏洞
2. **与 Reviewer 模式的本质区别**——Reviewer 是单向评审（Generator→Reviewer），Debate 是多向对抗（A⇄B⇄C）。前者验证"这个方案哪里不对"，后者比较"哪个方案更优"
3. **仲裁者（Arbitrator）的角色设计**——仲裁者不参与方案生成，只看辩论质量和逻辑瑕疵。这是面试中的亮点：仲裁者需要元认知能力（判断"谁的论证更有力"而非"谁的方案更像正确答案"）
4. **成本是最大劣势**——n 个 Agent 交叉质疑 = O(n²) 次 LLM 调用。3 个 Agent × 3 轮 = 约 18 次调用。仅用于高价值决策
5. **实际落地案例**——ChatGPT 的 CriticGPT（用独立模型找代码 bug）、Anthropic 的 Constitutional AI（两个 Agent 互相 critique 减少有害输出）

## 关联概念

- Reviewer模式：Debate 的前身——单向评审 vs 多向对抗
- Multi-Agent模式对比：协调成本最高但容错最强的模式
- ReAct失败模式（Day15）：错误传播（Error Propagation）和多 Agent 互相纠错的对策
- Swarm模式：Debate 的反面——无仲裁、无中心、自底向上涌现
- 接地（Grounding）：辩论中引入工具调用做事实仲裁，增强可信度
