#!/bin/bash

# 创建Claude Code学习记录的脚本
# 使用方法: ./创建学习记录.sh [课程编号] [课程名称] [日期]

set -e

# 默认值
DEFAULT_COURSE_NUM="s01"
DEFAULT_COURSE_NAME="Agent循环机制"
DEFAULT_DATE=$(date +%Y-%m-%d)

# 参数处理
COURSE_NUM="${1:-$DEFAULT_COURSE_NUM}"
COURSE_NAME="${2:-$DEFAULT_COURSE_NAME}"
DATE="${3:-$DEFAULT_DATE}"

# 验证参数
if [[ ! $COURSE_NUM =~ ^s[0-9]{2}$ ]]; then
    echo "错误: 课程编号格式应为 s01, s02 等"
    exit 1
fi

# 提取课程编号中的数字
COURSE_DAY="${COURSE_NUM#s}"
COURSE_DAY=$((10#$COURSE_DAY))  # 去掉前导零

# 计算学习天数
if [ $COURSE_DAY -eq 1 ]; then
    DAY_TEXT="第1天"
elif [ $COURSE_DAY -eq 2 ]; then
    DAY_TEXT="第2天"
elif [ $COURSE_DAY -eq 3 ]; then
    DAY_TEXT="第3天"
elif [ $COURSE_DAY -eq 4 ]; then
    DAY_TEXT="第4天"
elif [ $COURSE_DAY -eq 5 ]; then
    DAY_TEXT="第5天"
elif [ $COURSE_DAY -eq 6 ]; then
    DAY_TEXT="第6天"
elif [ $COURSE_DAY -eq 7 ]; then
    DAY_TEXT="第7天"
elif [ $COURSE_DAY -eq 8 ]; then
    DAY_TEXT="第8天"
elif [ $COURSE_DAY -eq 9 ]; then
    DAY_TEXT="第9天"
elif [ $COURSE_DAY -eq 10 ]; then
    DAY_TEXT="第10天"
elif [ $COURSE_DAY -eq 11 ]; then
    DAY_TEXT="第11天"
elif [ $COURSE_DAY -eq 12 ]; then
    DAY_TEXT="第12天"
else
    DAY_TEXT="第${COURSE_DAY}天"
fi

# 文件名
FILENAME="${DATE}-${COURSE_NUM}-${COURSE_NAME}.md"
FILEPATH="/Users/jansen/Documents/obsidian/JansenObsidian/4.学习资料/Agent工程师/1.学习资源/Claude Code学习/${FILENAME}"

# 检查文件是否已存在
if [ -f "$FILEPATH" ]; then
    echo "警告: 文件已存在: $FILENAME"
    read -p "是否覆盖? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "操作取消"
        exit 0
    fi
fi

# 获取星期几
WEEKDAY=$(date -d "$DATE" +%A 2>/dev/null || echo "星期X")

# 创建文件
cat > "$FILEPATH" << EOF
---
tags: [AI, Agent, ClaudeCode, 学习记录, ${COURSE_NUM}]
date: ${DATE}
course: ${COURSE_NUM} - ${COURSE_NAME}
day: ${DAY_TEXT}
status: 进行中
---

# ${DATE} - ${COURSE_NUM} ${COURSE_NAME}学习记录

## 📅 学习日期
- **日期**：${DATE}
- **星期**：${WEEKDAY}
- **学习阶段**：${DAY_TEXT}/28天
- **学习主题**：${COURSE_NUM} - ${COURSE_NAME}
- **学习时长**：小时

## 🎯 今日学习目标
1. 理解${COURSE_NAME}的核心概念
2. 运行并理解${COURSE_NUM}示例代码
3. 完成相关实践练习
4. 记录学习心得和遇到的问题

## 📖 学习资源
- **官方文档**：\`docs/zh/${COURSE_NUM}-${COURSE_NAME// /-}.md\`
- **示例代码**：\`agents/${COURSE_NUM}_${COURSE_NAME// /_}.py\`
- **学习笔记**：[[${COURSE_NUM} - ${COURSE_NAME}]]
- **前日笔记**：[[前一日学习记录]]（如有）

## 🔧 环境准备
\`\`\`bash
# 进入项目目录
cd /Users/jansen/project/python/learn-claude-code

# 激活虚拟环境
source venv/bin/activate

# 验证环境
python --version
python -c "import anthropic; print('Anthropic版本:', anthropic.__version__)"
\`\`\`

## 🧪 代码实践

### 1. 查看示例代码
\`\`\`bash
# 查看${COURSE_NUM}示例代码
cat agents/${COURSE_NUM}_${COURSE_NAME// /_}.py

# 或使用编辑器查看
\`\`\`

### 2. 运行示例代码
\`\`\`bash
# 运行${COURSE_NUM}示例
python agents/${COURSE_NUM}_${COURSE_NAME// /_}.py

# 记录运行结果：
# [在此记录运行结果和观察到的现象]
\`\`\`

## 📝 学习笔记

### 核心概念理解

#### 1. [核心概念1]
- **定义**：[概念的定义]
- **作用**：[在系统中的角色]
- **重要性**：[为什么重要]

#### 2. [核心概念2]
- **定义**：[概念的定义]
- **作用**：[在系统中的角色]
- **重要性**：[为什么重要]

### 代码分析

#### 关键代码片段
\`\`\`python
# [重要的代码片段]
# [解释这段代码的作用]
\`\`\`

## 💡 学习心得

### 1. 理解程度评估
- [ ] 完全理解${COURSE_NAME}的核心概念
- [ ] 能解释代码运行流程
- [ ] 能进行简单修改
- [ ] 能解决遇到的问题

### 2. 遇到的问题
**问题1**：[问题描述]
- **现象**：[具体表现]
- **原因**：[分析原因]
- **解决**：[解决方案]

### 3. 收获与思考
- **收获1**：[学到了什么]
- **收获2**：[有什么启发]
- **思考**：[对后续学习的思考]

## 🔍 实践练习

### 练习1：[练习名称]
\`\`\`python
# 练习代码
# [在此记录练习代码]
\`\`\`

**目的**：[练习的目的]
**结果**：[练习的结果]

## 📊 学习进度评估

### 知识掌握程度（1-5分）
| 知识点 | 自评分数 | 备注 |
|--------|----------|------|
| ${COURSE_NAME}概念 | | |
| 代码理解 | | |
| 实践能力 | | |
| **平均分** | | |

## 🎯 明日学习计划

### 学习主题：s$(printf "%02d" $((COURSE_DAY + 1))) - [下一课程名称]
- **目标**：[具体学习目标]
- **准备**：[需要做的准备]
- **时间**：预计小时
- **产出**：创建学习记录

## 📁 相关文件链接
- [[${COURSE_NUM} - ${COURSE_NAME}]] - 学习笔记模板
- [[Claude Code学习笔记索引]] - 所有笔记索引
- [[学习排期]] - 学习时间安排

## 📝 总结反思

### 今日完成
1. ✅ [完成的任务1]
2. ✅ [完成的任务2]
3. ⬜ [未完成的任务1]

### 遇到的困难
1. **技术问题**：[具体问题]
2. **理解问题**：[具体问题]

### 改进措施
1. **[改进1]**：[具体措施]
2. **[改进2]**：[具体措施]

---

## 🏷️ 标签
#学习记录 #${COURSE_NUM} #${COURSE_NAME// /} #${DAY_TEXT} #ClaudeCode #AI学习 #Agent工程师

## 📅 下次更新
- **日期**：$(date -d "$DATE +1 day" +%Y-%m-%d 2>/dev/null || echo "YYYY-MM-DD")
- **主题**：s$(printf "%02d" $((COURSE_DAY + 1))) - [下一课程名称]

---

**学习状态**：进行中  
**完成时间**：${DATE}  
**预计学习时长**：小时  
**实际学习时长**：小时  

**🎯 今日学习口号：坚持学习，每天进步！**
EOF

# 设置文件权限
chmod 644 "$FILEPATH"

echo "✅ 学习记录创建成功: $FILENAME"
echo "📁 文件位置: $FILEPATH"
echo ""
echo "📝 使用说明:"
echo "1. 编辑文件: vim '$FILEPATH'"
echo "2. 查看文件: cat '$FILEPATH'"
echo "3. 打开Obsidian查看"
echo ""
echo "🔗 相关文件:"
echo "- 学习记录模板: [[学习记录模板]]"
echo "- 笔记索引: [[Claude Code学习笔记索引]]"
echo "- 学习排期: [[学习排期]]"