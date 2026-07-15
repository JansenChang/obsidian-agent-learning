---
tags: [AI, Agent, 学习计划, ClaudeCode]
date: 2026-03-29
status: 进行中
priority: 高
---

# Claude Code 学习计划

## 🎯 学习目标
从零到一掌握构建类似Claude Code的AI代理工具，理解"模型就是Agent，代码是Harness"的核心思想。

## 📅 总体安排：28天（4周）

### 第一阶段：基础理解（1-2天）
**目标：建立核心概念框架**

#### Day 1（上午）：建立心智模型
- [ ] 精读README-zh.md，理解"模型就是Agent，代码是Harness"的核心思想
- [ ] 重点理解：Agent是模型，Harness是环境
- [ ] 区分：Agent开发 vs Harness工程

#### Day 1（下午）：整体架构概览
- [ ] 浏览web交互式学习平台（http://localhost:3000）
- [ ] 查看12个课程的递进关系
- [ ] 理解每个课程的核心格言

#### Day 2：核心机制理解
- [ ] 阅读docs/zh/s01-the-agent-loop.md
- [ ] 阅读docs/zh/s02-tool-use.md  
- [ ] 阅读docs/zh/s03-todo-write.md
- [ ] 完成理解检查：能解释Agent循环的基本工作原理

### 第二阶段：动手实践（3-7天）
**目标：逐课实现12个核心机制**

#### Week 1：基础机制（Day 3-7）
**Day 3-4：s01-s03 - 基础循环与规划**
- [ ] 运行s01_agent_loop.py，理解最小Agent循环
- [ ] 运行s02_tool_use.py，学习工具注册机制
- [ ] 运行s03_todo_write.py，理解规划的重要性
- [ ] 练习：为s01添加一个新工具

**Day 5-6：s04-s06 - 上下文管理与知识加载**
- [ ] 运行s04_subagent.py，理解子智能体隔离
- [ ] 运行s05_skill_loading.py，学习按需知识注入
- [ ] 运行s06_context_compact.py，掌握上下文压缩策略
- [ ] 练习：创建一个自定义Skill文件

**Day 7：复习与巩固**
- [ ] 复习前6课的核心概念
- [ ] 创建思维导图：前6个机制的关系
- [ ] 完成检查点：能解释为什么需要上下文压缩

#### Week 2：高级机制（Day 8-14）
**Day 8-9：s07-s08 - 持久化与异步**
- [ ] 运行s07_task_system.py，学习任务持久化
- [ ] 运行s08_background_tasks.py，理解异步执行
- [ ] 练习：创建一个简单的后台任务

**Day 10-11：s09-s10 - 团队协作**
- [ ] 运行s09_agent_teams.py，学习多智能体协作
- [ ] 运行s10_team_protocols.py，理解团队通信协议
- [ ] 练习：模拟两个智能体的简单协作

**Day 12-13：s11-s12 - 自治与隔离**
- [ ] 运行s11_autonomous_agents.py，学习自治机制
- [ ] 运行s12_worktree_task_isolation.py，掌握工作空间隔离
- [ ] 练习：创建一个隔离的工作空间

**Day 14：完整架构理解**
- [ ] 运行s_full.py，观察完整架构
- [ ] 对比s01-s12，理解机制叠加过程
- [ ] 完成检查点：能完整解释harness工程的12个机制

### 第三阶段：深度应用（8-14天）
**目标：将知识转化为实际项目**

#### Week 3：源码研究（Day 15-20）
**Day 15-16：Kode Agent CLI研究**
- [ ] 克隆Kode CLI项目：`git clone https://github.com/shareAI-lab/Kode-cli`
- [ ] 分析生产级实现与教学实现的差异
- [ ] 重点学习：Skill系统、LSP集成

**Day 17-18：Kode Agent SDK研究**
- [ ] 克隆Kode SDK项目：`git clone https://github.com/shareAI-lab/Kode-agent-sdk`
- [ ] 理解嵌入式Agent的实现
- [ ] 学习如何将Agent能力嵌入应用

**Day 19-20：claw0项目研究**
- [ ] 克隆claw0项目：`git clone https://github.com/shareAI-lab/claw0`
- [ ] 学习主动式常驻harness机制
- [ ] 理解心跳、定时任务、IM路由

#### Week 4：实践项目（Day 21-28）
**Day 21-23：项目设计**
- [ ] 选择应用场景（如：代码审查助手、文档生成器、测试自动化）
- [ ] 设计harness架构图
- [ ] 定义工具集、知识库、权限边界

**Day 24-26：原型实现**
- [ ] 基于s_full.py创建基础框架
- [ ] 实现核心工具
- [ ] 集成必要的知识库

**Day 27-28：测试优化**
- [ ] 测试原型功能
- [ ] 优化性能与用户体验
- [ ] 撰写项目总结文档

## 🛠️ 环境准备

```bash
# 项目已克隆到：
/Users/jansen/.openclaw/workspace-learning/learn-claude-code

# 安装依赖：
cd /Users/jansen/.openclaw/workspace-learning/learn-claude-code
pip install -r requirements.txt

# 配置API密钥：
cp .env.example .env
# 编辑.env文件，填入ANTHROPIC_API_KEY或其他模型API密钥

# 启动web学习平台（可选）：
cd web
npm install
npm run dev
# 访问 http://localhost:3000
```

## 📚 核心概念笔记

### 核心格言
- **模型就是Agent，代码是Harness**
- Agent是模型，Harness是环境
- 造好Harness，Agent会完成剩下的

### 12个核心机制
1. **Agent循环** - 最基本的交互循环
2. **工具使用** - 扩展Agent能力
3. **TodoWrite规划** - 让Agent自己规划
4. **子智能体** - 任务隔离与并行
5. **Skill加载** - 按需知识注入
6. **上下文压缩** - 管理token限制
7. **任务系统** - 持久化与恢复
8. **后台任务** - 异步执行
9. **智能体团队** - 多智能体协作
10. **团队协议** - 通信与协调
11. **自治智能体** - 主动执行
12. **Worktree隔离** - 安全的工作空间

## 🔗 相关链接
- [项目GitHub](https://github.com/shareAI-lab/learn-claude-code)
- [详细学习计划](file:///Users/jansen/.openclaw/workspace-learning/learn-claude-code-learning-plan.md)
- [学习笔记目录](Claude%20Code学习笔记索引.md)
- [学习排期](学习排期.md)

## 📝 学习记录
| 日期 | 学习内容 | 完成状态 | 备注 |
|------|----------|----------|------|
| 2026-03-29 | 制定学习计划，环境准备 | ✅ | 计划制定完成 |
| | | | |

---

**开始学习时间：** 2026-03-29  
**预计完成时间：** 2026-04-25  
**当前状态：** 🟡 进行中