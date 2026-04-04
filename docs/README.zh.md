# Ulanzi Studio 插件开发 - AI 上下文

[한국어](README.ko.md) | [English](../README.md) | **中文** | [日本語](README.ja.md)

用于构建 Ulanzi Studio 插件(D200H / D200 / D200X 流控制器)的 AI 上下文文件。

## 这是什么?

`SKILL.md` 是一个全面的 Ulanzi Studio 插件开发参考文件:

- **AI 上下文** - 加载到任何 AI 编码助手中即可生成插件
- **开发者指南** - 人类开发者也可直接阅读使用

加载到 AI 助手后,只需一条提示即可生成完整的、可安装的 Ulanzi 插件。

## AI 工具安装方法

### Claude Code

```bash
mkdir -p ~/.claude/skills
cp SKILL.md ~/.claude/skills/ulanzi-studio.md
```

### Cursor

```bash
cp .cursorrules /path/to/your/project/.cursorrules
```

或在 Cursor 设置 > Rules > User Rules 中粘贴内容。

### GitHub Copilot

```bash
mkdir -p /path/to/your/project/.github
cp .github/copilot-instructions.md /path/to/your/project/.github/copilot-instructions.md
```

### Windsurf

```bash
cp .windsurfrules /path/to/your/project/.windsurfrules
```

### Cline

```bash
cp .clinerules /path/to/your/project/.clinerules
```

### 其他 AI 工具

将 `SKILL.md` 的内容粘贴到 AI 助手的系统提示或上下文窗口中。

## 包含内容

- 插件目录结构和 `manifest.json` 模式
- SDK API 完整参考(`$UD` 对象 - 所有方法和事件)
- 插件主服务模式(动作生命周期管理)
- 动作类模式(Canvas 渲染、图标更新)
- Property Inspector 模式(设置 UI + 表单同步)
- CORS 约束(WebView 中可用/被阻止的 API)
- 字体加载修复(Canvas 绘制前异步等待字体)
- 本地化、调试、设备规格

## 使用示例

安装后,向 AI 助手提问:

> "创建一个在 Ulanzi D200H 上显示当前时间的插件"

> "做一个在 LCD 键上显示 CPU 使用率的 Ulanzi 插件"

> "构建一个倒计时器 Ulanzi D200H 插件"

## 基于

- [UlanziDeckPlugin-SDK](https://github.com/UlanziTechnology/UlanziDeckPlugin-SDK)(官方 SDK)
- [Ulanzi Studio](https://www.ulanzi.com/pages/downloads)

## 许可证

MIT
