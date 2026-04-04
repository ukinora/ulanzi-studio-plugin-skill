# Ulanzi Studio プラグイン開発 - AI コンテキスト

[한국어](README.ko.md) | [English](../README.md) | [中文](README.zh.md) | **日本語**

Ulanzi Studio プラグイン(D200H / D200 / D200X ストリームコントローラー)を構築するための AI コンテキストファイルです。

## これは何ですか?

`SKILL.md` は Ulanzi Studio プラグイン開発の包括的なリファレンスファイルです:

- **AI コンテキスト** - 任意の AI コーディングアシスタントに読み込ませてプラグインを生成
- **開発者ガイド** - 人間が直接読んでプラグインを開発する際にも使用可能

AI アシスタントに読み込ませると、一行のプロンプトだけでインストール可能な完全な Ulanzi プラグインを生成できます。

## AI ツール別インストール方法

### Claude Code

```bash
mkdir -p ~/.claude/skills
cp SKILL.md ~/.claude/skills/ulanzi-studio.md
```

### Cursor

```bash
cp .cursorrules /path/to/your/project/.cursorrules
```

または Cursor 設定 > Rules > User Rules に内容を貼り付け。

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

### その他の AI ツール

`SKILL.md` の内容を AI アシスタントのシステムプロンプトまたはコンテキストウィンドウに貼り付けてください。

## 含まれる内容

- プラグインディレクトリ構造と `manifest.json` スキーマ
- SDK API 完全リファレンス(`$UD` オブジェクト - 全メソッドとイベント)
- プラグインメインサービスパターン(アクションライフサイクル管理)
- アクションクラスパターン(Canvas レンダリング、アイコン更新)
- Property Inspector パターン(設定 UI + フォーム同期)
- CORS 制約(WebView で動作する API / ブロックされる API)
- フォント読み込み修正(Canvas 描画前の非同期フォント待機)
- ローカライゼーション、デバッグ、デバイススペック

## 使用例

インストール後、AI アシスタントに:

> "Ulanzi D200Hのキーに現在時刻を表示するプラグインを作って"

> "LCD キーに CPU 使用率を表示する Ulanzi プラグインを作成して"

> "カウントダウンタイマーの Ulanzi D200H プラグインを構築して"

## ベースプロジェクト

- [UlanziDeckPlugin-SDK](https://github.com/UlanziTechnology/UlanziDeckPlugin-SDK)(公式 SDK)
- [Ulanzi Studio](https://www.ulanzi.com/pages/downloads)

## ライセンス

MIT
