# Anki 英语单词卡片模板

一个现代化的 Anki 英语单词学习卡片模板，支持深色主题和移动端适配。

## 功能特点

- 🌓 自动深色主题适配
- 📱 移动端响应式设计
- 🔄 可选翻译功能
- 🎨 现代化 UI 设计
- 🔊 音频播放支持

## 字段说明

- `Word`: 单词
- `IPA`: 音标
- `Example`: 例句
- `Meaning`: 释义
- `ExampleZH`: 例句中文翻译（可选）
- `MeaningZH`: 释义中文翻译（可选）
- `Image`: 图片
- `Sound`: 单词发音
- `Sound_Example`: 例句发音

## 翻译功能使用

默认情况下翻译功能是关闭的。要启用翻译功能：

1. 打开卡片模板编辑器
2. 在背面模板中找到 `<div class="box translation-mode-0">`
3. 将 `translation-mode-0` 改为 `translation-mode-1`
4. 保存模板

启用后，点击例句或释义即可展开对应的中文翻译。

## 扩展性

模板设计支持多语言扩展。如需添加其他语言翻译：

1. 添加对应的字段（如 `ExampleES`、`MeaningES`）
2. 在 HTML 中添加对应的 `details` 元素
3. 在 CSS 中添加对应的 `translation-mode-X` 规则

## 安装方法

1. 导入 `.apkg` 文件到 Anki
2. 或者手动创建笔记类型并复制模板代码

## 兼容性

- Anki 2.1+
- AnkiDroid
- AnkiMobile
- AnkiWeb 