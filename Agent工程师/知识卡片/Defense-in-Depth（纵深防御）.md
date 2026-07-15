---
created: 2026-06-24
tags:
  - knowledge-card
  - agent-interview
  - security
day: Day6
difficulty: 🟡
aliases: ['Defense in Depth', '纵深防御']
related: ['[[Prompt Injection（提示注入）]]', '[[Guardrails（LLM护栏）]]']
---
# Defense in Depth（纵深防御）

> 一句话：多层防御叠加的安全策略。每一层都不完美，但多层叠加后攻击难度指数级上升。

## 四层防御体系

```
输入层  → 正则 + BERT 分类器检测注入
权限层  → 最小权限原则，隔离 LLM 执行环境
输出层  → 多检测器管道验证输出内容
框架层  → Guardrails 代码级硬规则拦截
```

## 落地路线图

| 阶段 | 做法 | 适用 |
|------|------|------|
| Phase 1 | Prompt 约束（零成本） | 所有项目 |
| Phase 2 | 输入输出过滤 | 生产环境 |
| Phase 3 | Guardrails 框架 | 正式产品 |
| Phase 4 | 权限隔离 | 金融/医疗 |

## 关联概念