---
created: 2026-07-23
tags: [knowledge-card, agent-interview, multi-agent, agent-core, emergent-behavior]
day: Day19
difficulty: 🟠
aliases: [Swarm Intelligence, Emergent Coordination, 蜂群模式, Decentralized Multi-Agent]
related: ["[[Multi-Agent模式对比]]", "[[Supervisor模式]]", "[[Debate模式]]", "[[ReAct（推理-行动循环）]]"]
---

# Swarm 模式

> 一句话：大量轻量 Agent 无中心调度者、无全局计划、无固定拓扑——每个 Agent 只根据局部信息和简单规则行动，通过 Agent 间的局部交互自底向上涌现出全局智能行为。灵感来自蚁群/鸟群等自然系统。

## 核心机制

### 架构拓扑

```
         无中心、无层级、无全局状态

         •  •   •   • •      每个 • = 一个轻量 Agent
       •    •     •    •      规则简单、局部感知
          •  •   •  •        仅与邻近 Agent 通信
       •     • •     • •      
         •   •   • •   •     全局智能从局部交互中涌现
```

### Swarm 三大核心原则

```
┌─────────────────────────────────────────────────────┐
│  1. 去中心化                                         │
│     无 Supervisor、无 Planner、无全局任务分配          │
│     每个 Agent 自主决策，不等待上级指令                │
├─────────────────────────────────────────────────────┤
│  2. 局部交互                                         │
│     Agent 只感知邻近 Agent 的状态                     │
│     通过消息传递/环境标记（Stigmergy）间接通信         │
│     无全局广播、无共享状态                             │
├─────────────────────────────────────────────────────┤
│  3. 简单规则                                         │
│     每个 Agent 的行为规则简单（3-5 条）                │
│     规则组合 + 大规模并行执行 → 复杂全局行为           │
│     脱离-跟随-探索三个基元                            │
└─────────────────────────────────────────────────────┘
```

### Stigmergy：通过环境间接通信

```python
# 蚁群信息素机制在 Agent Swarm 中的应用
class Environment:
    def __init__(self):
        self.pheromones = {}  # 环境标记
    
    def deposit(self, location, signal):
        """Agent 在环境中留下标记"""
        self.pheromones[location] = signal
    
    def sense(self, location, radius):
        """Agent 感知附近标记"""
        return [self.pheromones[loc] 
                for loc in self.neighbors(location, radius)]

# Agent 行为：探索→发现→标记→其他 Agent 感知→聚集
def agent_loop():
    if environment.sense(my_location, radius):
        follow_trail()      # 跟随信息素
    else:
        random_walk()       # 随机探索
    if found_interesting():
        environment.deposit(my_location, "有价值区域")
```

### Swarm vs 传统编排

| 维度 | Supervisor/Debate | Swarm |
|------|:---:|:---:|
| **Agent 数量** | 3-10 个 | 数十~数千个 |
| **Agent 复杂度** | 高（完整 ReAct+工具） | 低（简单规则+轻量感知） |
| **拓扑** | 固定（星型/网状） | 动态变化 |
| **容错** | 单点故障风险 | Agent 故障无影响 |
| **可解释性** | 可追溯决策链 | 极低（涌现行为难解释） |
| **适用场景** | 精密任务 | 大规模并行探索 |

## 面试要点

1. **"涌现"是关键词**——Swarm 的核心在于：单个 Agent 行为极其简单，但大规模并行交互产生复杂的整体行为模式。面试官期待的比喻是"蚁群：每只蚂蚁只知道跟随信息素，但整体能找出最优觅食路径"
2. **Stigmergy（间接通信）——面试亮点**——Agent 不直接对话，而是通过修改共享"环境"来通信。类比：AirTag 的 Find My 网络就是 Stigmergy——每个 iPhone 不直接通信，而是通过 Apple 服务器留下位置标记
3. **Swarm 的容错原因**——无中心、无单点、Agent 可随时加入/退出，系统整体行为不受个别 Agent 故障影响
4. **什么时候不该用 Swarm**——需要可解释性（金融/医疗决策）、需要精确控制（确定性任务）、Agent 数量太少（< 10 个，Swarm 优势不明显）
5. **Swarm 在 AI Agent 的实践**——OpenAI 的 Swarm 实验框架、AutoGen 的群聊模式、蚂蚁群体优化算法的 Agent 化应用

## 关联概念

- Supervisor模式：Swarm 的对立面——中心化 vs 去中心化
- Debate模式：都是多 Agent，但 Debate 有结构化对抗和仲裁，Swarm 完全无结构
- Multi-Agent模式对比：容错最强但可解释性最弱
- ReAct（Day14）：Swarm 中的 Agent 不运行完整 ReAct 循环，行为规则极简
