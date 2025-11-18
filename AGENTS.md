

## 项目概述

Mneme 是一个专为音频优先语言学习设计的 Anki 卡片模板系统。该项目创建 HTML/CSS/JavaScript 模板，用于制作优先听力理解、后显示文本内容的闪卡。

## 架构

### 核心组件
- **template/EEW Mneme/front.html**: Anki 卡片正面 - 仅显示目标单词和 IPA 音标
- **template/EEW Mneme/back.html**: 卡片背面，包含完整内容：
  - 可配置延迟的音频优先显示机制
  - 渐进式内容展示（音频 → 文本 → 翻译）
  - 通过点击交互可中断的延迟
  - 带有可折叠详情的响应式翻译系统
- **template/styling.css**: 综合性 CSS，包含：
  - 主题化的 CSS 自定义属性
  - 通过 `.night_mode` 类支持明暗模式
  - 移动优先的响应式设计
  - 音频时长功能的渐进增强

### 文件结构
```
/                    # 仓库根目录
├── template/        # VS Code 扩展直接使用的模板目录
│   ├── EEW Mneme/   # 特定牌组模板
│   │   ├── front.html
│   │   └── back.html
│   └── styling.css  # 主样式表
├── docs/            # GitHub Pages / 远程引用资源
│   ├── index.html
│   ├── preview.gif
│   └── anki-storage.umd.js
├── notes/           # 本地文档（git 忽略，不随仓库发布）
├── .config/         # 配置文件
│   └── config.json  # AnkiConnect 和模板路径
├── AGENTS.md
├── readme.md
└── package.json / node_modules / 等
```

### 模板系统
模板使用 Anki 的字段替换语法（如 `{{Word}}`、`{{Example}}`、`{{Sound}}`）。关键字段包括：
- `{{Word}}`、`{{IPA}}` - 单词和发音
- `{{Example}}`、`{{Meaning}}` - 英文内容
- `{{ExampleZH}}`、`{{MeaningZH}}` - 中文翻译
- `{{Sound}}`、`{{Sound_Example}}` - 音频文件
- `{{Sound_Dur}}`、`{{Sound_Example_Dur}}` - 音频时长元数据
- `{{Image}}` - 视觉内容

### JavaScript 功能
back.html 包含复杂的 JavaScript，用于：
- **音频优先延迟**: 基于音频时长计算内容显示时机
- **渐进式披露**: 音频播放后显示内容（可配置延迟因子）
- **可中断界面**: 屏幕中心区域的点击显示功能
- **翻译管理**: 动态显示/隐藏翻译内容
- **响应式交互**: 触摸和点击事件处理
- **Hit Motivation 配置**: 设置激励消息参数和调试模式

front.html 包含 OneMoreTurn MVP 功能：
- **学习激励系统**: 在达到特定复习次数时显示鼓励消息
- **跨平台计数管理**:
  - AnkiDroid: 使用 anki-storage 实现完全持久化（跨应用重启）
  - iOS/Desktop: 使用 sessionStorage 实现会话级持久化
- **每日重置**: 每天 4:00 AM 自动重置计数器
- **分层消息显示**: 支持 quick hit（快速里程碑）和 combo hit（大里程碑）
- **自定义配置**: 从 back.html 通过 localStorage/sessionStorage 读取配置

## 开发命令

### 模板联动
- VS Code NK Card Template Editor 直接指向 `template/` 目录，不再需要复制脚本。
- 扩展读取 `template/EEW Mneme/front.html`、`back.html` 和 `template/styling.css`，编辑后即可同步到 Anki。

### 模板开发工作流
1. 在 `template/EEW Mneme/` 中编辑 `front.html`、`back.html`，并更新 `template/styling.css`。
2. 使用 VS Code 扩展或 Anki 模板编辑器直接加载 `template/`，无需额外构建步骤。
3. `template/` 中的模板通过 AnkiConnect 配置与 Anki 保持一致。

## 配置

### 模板设置（back.html JavaScript）
```javascript
var delayFactor = 1;        // 音频延迟倍数（0=立即显示，1=完整时长）
var translationMode = 1;    // 翻译显示（0=无，1=中文，2=保留）
var interruptible = 1;      // 点击显示（0=禁用，1=启用）
var hitMotivation = 1;      // 激励系统（0=禁用，1=启用）
var debugMode = 0;          // 调试模式（0=关闭，1=显示计数器和存储信息）
```

### AnkiConnect 集成
`.config/config.json` 中的配置定义：
- AnkiConnect URL 和版本
- 笔记类型（"EEW Mneme"）
- 正面/背面 HTML 模板文件路径
- CSS 文件路径[text](../OneMoreTurn/模板简化版实现方案.md)

## 核心设计原则

1. **音频优先学习**: 内容在音频播放后显示，鼓励先听后读
2. **最小认知负荷**: 简洁、无干扰的界面，采用渐进式披露
3. **移动端响应式**: 针对桌面和移动端学习会话优化
4. **可访问性**: 高对比度模式、可缩放字体、触摸友好交互
5. **模块化翻译**: 易于启用/禁用翻译功能

## 开发注意事项

- 模板使用 CSS 自定义属性确保主题一致性
- JavaScript 使用原生语法（无框架）以确保 Anki 兼容性
- 所有音频时机功能依赖 `{{Sound_Dur}}` 元数据字段
- 移动端断点为 600px，字体有特定缩放（单词大小 10vw）
- 夜间模式由 `.night_mode` 类触发（Anki 的暗色主题检测）

## 功能限制

### 旗标功能
- **PC端**: Anki 桌面版完全支持旗标功能（Ctrl+1-7）
- **移动端**: AnkiMobile/AnkiDroid 有限制
  - 旗标功能仅在 Anki 桌面版中完全支持
  - 移动端不支持在 HTML 模板中显示自定义旗标
  - 移动端用户需要使用 Anki 内置的旗标功能进行卡片管理

### OneMoreTurn 计数持久化
由于各平台技术限制，计数器持久化能力不同：
- **AnkiDroid (Android)**: 使用 anki-storage 库，完全持久化（重启应用后保留，每天 4 AM 重置）
- **Desktop (Windows/Mac/Linux)**: 使用 sessionStorage，会话级持久化（Anki 运行期间保留，关闭应用后重置）
- **AnkiMobile (iOS)**: 使用 sessionStorage，会话级持久化（学习期间保留，退出到主界面后重置）
- **调试**: 设置 `debugMode = 1` 可在单词右侧显示计数器和存储类型（🔒=anki-storage，📦=sessionStorage）

## 工作流程

### Git 分支策略

- `main`: 生产稳定版本

- `dev`: 开发集成分支

- `feat/T000X-name`: 任务功能分支

### 任务驱动开发

1. **创建任务**：在 `.claude/tasks/T000X_描述` 创建任务文件

2. **开发实现**：在 `feat/T000X-name` 分支完成功能

3. **合并集成**：合并到 `dev` 分支

4. **版本发布**：定期从 `dev` 合并到 `main`

### 提交规范

**注意事项**：

- 不添加 AI 协作者信息

- main 分支只通过 squash merge 合并 dev 的提交

- 禁止直接在 main 分支进行提交
