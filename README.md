# Ulanzi Studio Plugin Development Skill

A [Claude Code](https://claude.com/claude-code) skill for building Ulanzi Studio plugins (D200H / D200 / D200X stream controllers).

## What is this?

This is a **skill file** for Claude Code. When installed, Claude Code gains the knowledge to build Ulanzi Studio plugins from scratch - including plugin structure, SDK API, Canvas rendering, Property Inspector UI, localization, and platform constraints (CORS, font loading, etc.).

## Install

### For Claude Code users

Copy `SKILL.md` to your Claude Code skills directory:

```bash
# Global (all projects)
mkdir -p ~/.claude/skills
cp SKILL.md ~/.claude/skills/ulanzi-studio.md

# Or project-level
mkdir -p .claude/skills
cp SKILL.md .claude/skills/ulanzi-studio.md
```

### Manual reference

You can also read `SKILL.md` directly as a comprehensive Ulanzi Studio plugin development guide.

## What it covers

- Plugin directory structure and manifest.json schema
- Full SDK API reference (`$UD` object - all methods and events)
- Plugin main service pattern (action lifecycle management)
- Action class pattern (Canvas rendering, icon updates)
- Property Inspector pattern (settings UI with form sync)
- CORS constraints (which APIs work in the WebView, which don't)
- Font loading fix (async font await before Canvas draw)
- Localization setup (multi-language support)
- Debugging tips (remote debug, simulator)
- Device specs (D200H, D200, D200X, Dial)

## Example prompt

After installing this skill, you can ask Claude Code:

> "Ulanzi D200H에 현재 시간을 표시하는 플러그인 만들어줘"

> "Create an Ulanzi plugin that shows CPU usage on the LCD key"

> "Build an Ulanzi D200H plugin with a countdown timer"

Claude Code will generate a complete, installable plugin with all required files.

## Based on

- [UlanziDeckPlugin-SDK](https://github.com/UlanziTechnology/UlanziDeckPlugin-SDK) (official SDK)
- [Ulanzi Studio](https://www.ulanzi.com/pages/downloads)

## License

MIT
