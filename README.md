# Ulanzi Studio Plugin Development - AI Context

[한국어](docs/README.ko.md) | **English** | [中文](docs/README.zh.md) | [日本語](docs/README.ja.md)

AI context file for building Ulanzi Studio plugins (D200H / D200 / D200X stream controllers).

## What is this?

`SKILL.md` is a comprehensive Ulanzi Studio plugin development reference that works as:

- **AI context** for any AI coding assistant
- **Developer guide** for humans building plugins manually

When loaded into an AI assistant, it can generate complete, installable Ulanzi plugins from a single prompt.

## Install for AI Assistants

### Claude Code

```bash
mkdir -p ~/.claude/skills
cp SKILL.md ~/.claude/skills/ulanzi-studio.md
```

### Cursor

```bash
cp .cursorrules /path/to/your/project/.cursorrules
```

Or add to Cursor Settings > Rules > User Rules.

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

### Other AI Tools

Paste the contents of `SKILL.md` into your AI assistant's system prompt or context window.

## What it covers

- Plugin directory structure and `manifest.json` schema
- Full SDK API reference (`$UD` object - all methods and events)
- Plugin main service pattern (action lifecycle management)
- Action class pattern (Canvas rendering, icon updates)
- Property Inspector pattern (settings UI with form sync)
- CORS constraints (which APIs work in the WebView, which don't)
- Font loading fix (async font await before Canvas draw)
- Localization, debugging, device specs

## Example prompts

After installing, ask your AI assistant:

> "Ulanzi D200H에 현재 시간을 표시하는 플러그인 만들어줘"

> "Create an Ulanzi plugin that shows CPU usage on the LCD key"

> "Build an Ulanzi D200H plugin with a countdown timer"

> "Ulanzi D200Hのキーに天気を表示するプラグインを作って"

## Based on

- [UlanziDeckPlugin-SDK](https://github.com/UlanziTechnology/UlanziDeckPlugin-SDK) (official SDK)
- [Ulanzi Studio](https://www.ulanzi.com/pages/downloads)

## License

MIT
