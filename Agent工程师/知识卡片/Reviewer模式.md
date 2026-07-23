---
created: 2026-07-23
tags: [knowledge-card, agent-interview, multi-agent, agent-core, quality-control]
day: Day19
difficulty: 🔴
aliases: [Reviewer Pattern, Generator-Critic, 评审者模式, Quality Gate Pattern]
related: ["[[Multi-Agent模式对比]]", "[[Debate模式]]", "[[ReAct（推理-行动循环）]]", "[[接地（Grounding）]]", "[[ReAct失败模式]]"]
---

# Reviewer 模式

> 一句话：Generator Agent 产出初稿→Reviewer Agent 基于质量标准逐项评审→返回修改清单→Generator 修改→循环迭代直至达标。本质是把"质量把关"从 Generator 的自我反思外化为独立 Reviewer 的外部评审，大幅提升输出质量。

## 核心机制

### 架构拓扑

```
      ┌───────────┐         ┌───────────┐
      │ Generator │ ──────→ │ Reviewer  │
      │  产出初稿   │  初稿    │  质量评审   │
      │            │ ←────── │            │
      │  按清单修改  │ 修改清单  │  逐项打分   │
      └───────────┘         └───────────┘
           │                      │
           └──── 达标 → 输出 ──────┘
```

### 评审维度与检查点

```python
class Reviewer:
    def review(self, output, task_spec):
        checks = {
            "正确性": self.fact_check(output),        # 事实是否准确
            "完整性": self.coverage_check(output, task_spec),  # 是否覆盖所有需求
            "一致性": self.consistency_check(output), # 前后逻辑是否一致
            "安全性": self.safety_check(output),      # 是否含敏感/有害内容
            "格式": self.format_check(output),        # 是否符合输出规范
        }
        score = sum(checks.values()) / len(checks)
        return ReviewResult(
            passed=score >= threshold,
            score=score,
            feedback=self.generate_revision_notes(checks)
        )

# Generator 修改循环
def generate_with_review(task, max_iterations=3):
    output = generator(task)
    for i in range(max_iterations):
        review = reviewer.review(output, task)
        if review.passed:
            return output
        output = generator.revise(output, review.feedback)
    raise QualityNotMetError(f"经过 {max_iterations} 轮仍未达标")
```

### Reviewer 的三种角色设计

| 角色类型 | Reviewer 设定 | 适用场景 |
|---------|-------------|---------|
| **专家 Reviewer** | 领域专家角色（如"资深代码审查员"） | 专业性强的产出（代码/论文） |
| **用户 Reviewer** | 模拟目标用户角色 | 面向终端用户的内容 |
| **对抗 Reviewer** | 故意挑错、鸡蛋里挑骨头 | 安全关键场景/高可靠性需求 |

### 循环终止条件

- ✅ 所有检查项通过（达标终止）
- ⚠️ 达到最大迭代次数（3-5 轮常见）
- ⚠️ 连续两轮分数无提升（收敛终止——再改也没用了）
- ❌ 分数持续下降（需人工介入）

## 面试要点

1. **Reviewer 模式 vs 自我反思（Self-Reflection）**——Self-Reflection 是同一个 LLM 审查自己的输出，存在盲区（"自己看不出自己的错"）；Reviewer 模式用独立的 Reviewer Agent（不同角色设定、甚至不同模型），交叉验证，质量提升显著
2. **Reviewer 的提示词设计比 Generator 更关键**——Reviewer 需要明确的评分标准（Rubric）、具体的修改建议（而非笼统的"再改改"）、以及何时"放行"的判断力
3. **Reviewer 也可能出错**——Reviewer 自身也有幻觉风险（误判正确内容为错误）。工程上需要"可驳回"机制：Generator 可以反对 Reviewer 的判断，由第三方仲裁
4. **成本换质量**——Reviewer 模式每轮多一次 LLM 调用（成本加倍），3 轮迭代 = 4 次调用。只适用于质量要求高于成本的场景（如代码生成、合同审查）
5. **与 Grounding 的关系**——Day15 的 Grounding 强调用工具验证，Reviewer 强调用 Agent 验证，两者互补：工具验证事实，Agent 验证逻辑

## 关联概念

- Debate模式：Reviewer 的升级版——多个 Agent 互相评审而非单向评审
- Grounding（Day15）：工具验证事实 vs Reviewer 验证逻辑，正交互补
- ReAct失败模式（Day15）：Reviewer 直接对抗 Tool Swamp 和循环发散
- Multi-Agent模式对比：质量门控场景的首选模式
- AutoGen vs CrewAI vs LangGraph：AutoGen 的 agentchat 内置人类反馈 Review 机制
