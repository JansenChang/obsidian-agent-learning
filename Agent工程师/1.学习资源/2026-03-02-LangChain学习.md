# LangChain学习笔记

## 学习时间
- **日期**: 2026-03-02
- **开始时间**: 00:42 (GMT+8)
- **学习主题**: LangChain基础与核心概念

## 一、LangChain概述

### 1.1 什么是LangChain
LangChain是一个用于开发由语言模型驱动的应用程序的框架。它提供了一套工具、组件和接口，简化了构建基于LLM的应用程序的过程。

### 1.2 核心价值
1. **模块化设计**: 将复杂任务分解为可重用的组件
2. **链式调用**: 将多个组件连接成工作流
3. **工具集成**: 轻松集成外部工具和API
4. **记忆管理**: 处理对话历史和上下文

## 二、LangChain核心组件

### 2.1 Models (模型)
```python
# 伪代码示例：模型使用
from langchain.llms import OpenAI
from langchain.chat_models import ChatOpenAI

# 基础LLM
llm = OpenAI(model="gpt-3.5-turbo", temperature=0.7)

# 聊天模型
chat_model = ChatOpenAI(model="gpt-4", temperature=0.5)
```

**模型类型**:
- **LLMs**: 文本输入 → 文本输出
- **Chat Models**: 消息列表 → 消息输出
- **Embeddings**: 文本 → 向量表示

### 2.2 Prompts (提示)
```python
# 伪代码示例：提示模板
from langchain.prompts import PromptTemplate

# 创建提示模板
template = """
你是一个专业的{role}助手。
请根据以下上下文回答问题：

上下文: {context}
问题: {question}

请用{language}回答：
"""

prompt = PromptTemplate(
    input_variables=["role", "context", "question", "language"],
    template=template
)

# 填充模板
filled_prompt = prompt.format(
    role="技术",
    context="LangChain是一个LLM应用开发框架",
    question="LangChain的主要功能是什么？",
    language="中文"
)
```

**提示技术**:
- **Few-shot提示**: 提供示例
- **Chain-of-Thought**: 引导推理过程
- **结构化输出**: 指定输出格式

### 2.3 Chains (链)
```python
# 伪代码示例：简单链
from langchain.chains import LLMChain

# 创建链
chain = LLMChain(llm=llm, prompt=prompt)

# 运行链
result = chain.run({
    "role": "技术",
    "context": "LangChain提供模型、提示、链等组件",
    "question": "解释LangChain的链式调用",
    "language": "中文"
})
```

**链类型**:
- **LLMChain**: 最基本的链
- **SequentialChain**: 顺序执行多个链
- **RouterChain**: 根据输入路由到不同链

### 2.4 Memory (记忆)
```python
# 伪代码示例：对话记忆
from langchain.memory import ConversationBufferMemory

# 创建记忆
memory = ConversationBufferMemory(
    memory_key="chat_history",
    return_messages=True
)

# 保存对话
memory.save_context(
    {"input": "你好，我是Jansen"},
    {"output": "你好Jansen！有什么可以帮助你的？"}
)

# 读取记忆
history = memory.load_memory_variables({})
```

**记忆类型**:
- **Buffer Memory**: 存储最近的对话
- **Summary Memory**: 存储对话摘要
- **Entity Memory**: 存储实体信息

### 2.5 Agents (智能体)
```python
# 伪代码示例：智能体
from langchain.agents import initialize_agent, Tool
from langchain.tools import WikipediaQueryRun

# 定义工具
tools = [
    Tool(
        name="Wikipedia",
        func=wikipedia_tool.run,
        description="搜索维基百科获取信息"
    ),
    Tool(
        name="Calculator",
        func=calculator_tool.run,
        description="进行数学计算"
    )
]

# 创建智能体
agent = initialize_agent(
    tools=tools,
    llm=llm,
    agent="zero-shot-react-description",
    verbose=True
)

# 运行智能体
result = agent.run("计算圆的面积，半径为5cm")
```

**智能体类型**:
- **Zero-shot ReAct**: 零样本推理和行动
- **Conversational**: 对话式智能体
- **Self-ask with search**: 自我提问搜索

## 三、LangChain实践应用

### 3.1 文档问答系统
```python
# 伪代码示例：文档问答
from langchain.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.chains import RetrievalQA

# 1. 加载文档
loader = TextLoader("document.txt")
documents = loader.load()

# 2. 分割文本
text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
texts = text_splitter.split_documents(documents)

# 3. 创建向量存储
embeddings = OpenAIEmbeddings()
vectorstore = Chroma.from_documents(texts, embeddings)

# 4. 创建检索链
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever()
)

# 5. 提问
answer = qa_chain.run("文档中提到了哪些关键技术？")
```

### 3.2 对话机器人
```python
# 伪代码示例：对话机器人
from langchain.chains import ConversationChain

# 创建对话链
conversation = ConversationChain(
    llm=llm,
    memory=ConversationBufferMemory(),
    verbose=True
)

# 对话
response1 = conversation.predict(input="你好！")
response2 = conversation.predict(input="你能帮我学习LangChain吗？")
```

## 四、LangChain高级特性

### 4.1 回调系统
```python
# 伪代码示例：回调
from langchain.callbacks import StdOutCallbackHandler

# 创建回调处理器
callbacks = [StdOutCallbackHandler()]

# 在链中使用回调
chain = LLMChain(
    llm=llm,
    prompt=prompt,
    callbacks=callbacks
)
```

### 4.2 异步支持
```python
# 伪代码示例：异步调用
import asyncio

	async def async_query():
    result = await chain.arun({
        "role": "技术",
        "context": "异步编程",
        "question": "解释async/await",
        "language": "中文"
    })
    return result

# 运行异步任务
answer = asyncio.run(async_query())
```

### 4.3 流式输出
```python
# 伪代码示例：流式响应
for chunk in chain.stream({
    "role": "技术",
    "context": "流式处理",
    "question": "什么是流式输出？",
    "language": "中文"
}):
    print(chunk, end="", flush=True)
```

## 五、学习要点总结

### 5.1 核心概念
1. **模块化思维**: LangChain将复杂任务分解为组件
2. **链式调用**: 通过链连接不同组件
3. **工具集成**: 智能体可以调用外部工具
4. **上下文管理**: 记忆系统处理对话历史

### 5.2 实践建议
1. **从简单开始**: 先掌握LLMChain和PromptTemplate
2. **理解数据流**: 跟踪输入到输出的完整流程
3. **调试技巧**: 使用verbose模式和回调
4. **性能优化**: 考虑缓存、批处理和异步

### 5.3 常见应用场景
1. **文档问答**: 基于文档的智能问答
2. **对话系统**: 上下文感知的聊天机器人
3. **数据提取**: 从非结构化文本提取信息
4. **代码生成**: 基于自然语言生成代码

## 六、今日学习计划

### 6.1 学习目标
- [ ] 理解LangChain核心组件
- [ ] 掌握基本链的使用
- [ ] 学习提示工程技巧
- [ ] 实践文档问答系统

### 6.2 实践任务
1. **环境搭建**: 安装LangChain和相关依赖
2. **基础示例**: 运行官方入门示例
3. **自定义链**: 创建简单的问答链
4. **文档处理**: 实现文本加载和分割

### 6.3 学习资源
1. **官方文档**: https://python.langchain.com/
2. **GitHub仓库**: https://github.com/langchain-ai/langchain
3. **示例代码**: LangChain官方示例
4. **社区资源**: Discord、Reddit讨论

## 七、面试准备要点

### 7.1 技术问题
**Q: LangChain的核心组件有哪些？**
A: Models、Prompts、Chains、Memory、Agents

**Q: 解释LangChain中的链式调用**
A: 链式调用是将多个组件连接起来，形成完整的工作流。例如：输入 → 提示 → LLM → 输出解析

**Q: 智能体(Agent)和链(Chain)的区别**
A: 链是预定义的工作流，智能体可以根据情况动态选择工具和行动

### 7.2 系统设计
**场景: 设计一个智能客服系统**
- 使用ConversationChain处理对话
- 集成知识库检索(RAG)
- 添加工具调用(查询订单、FAQ等)
- 实现多轮对话记忆

## 八、学习进度记录

### 8.1 已完成
- [x] 创建学习笔记框架
- [x] 整理LangChain核心概念
- [x] 编写伪代码示例

### 8.2 待完成
- [ ] 安装LangChain环境
- [ ] 运行实际代码示例
- [ ] 构建简单应用
- [ ] 调试和优化

### 8.3 遇到的问题
- **问题1**: 环境配置依赖
- **解决方案**: 使用虚拟环境，按文档安装
- **问题2**: API密钥管理
- **解决方案**: 使用环境变量或配置文件

---

**学习时间**: 2026-03-02 00:42开始  
**预计时长**: 2-3小时  
**学习重点**: LangChain基础组件和链式调用  
**实践目标**: 完成一个简单的文档问答示例
