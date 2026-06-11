# 🛰️ orbit.nvim

AI Coding Agents for Neovim

orbit.nvim は、AI エージェントと協調しながら開発を行うための Neovim プラグインです。

現在は Codex CLI を Terminal Buffer 上で利用するための Workspace を提供しています。

将来的には Project Context の共有、Session Management、Multi-Agent Collaboration を通して、複数の AI エージェントが
同じプロジェクトを理解しながら開発できる環境を目指しています。

> ⚠️orbit.nvim は現在ベータ版（v0.1.x）です。
> API や動作仕様は今後変更される可能性があります。

## Requirements

- Neovim >= 0.12.0
- One supported AI agent CLI

### Supported Agents

| Agent       | Status       |
|-------------|--------------|
| Codex CLI   | ✅ Supported |
| Claude Code | 📋 Planned   |
| Gemini CLI  | 📋 Planned   |

## Quick Start

### How to install

#### lazy.nvim

```lua
{
  "hurry-woodvil/orbit.nvim",
  opts = {},
}
```

### How to use

#### AI エージェント Workspace を起動する

`:OrbitStart`

#### AI エージェント Workspace を停止する

`:OrbitRelease`

#### file buffer の内容を AI エージェント Workspace に送信

`:OrbitSendBuffer`

#### visual mode で選択している行を AI エージェント Workspace に送信

`:OrbitSendSelection`

## Demo

Coming Soon 💫

## Features

- AI エージェント（Codex）を Terminal Buffer 上で起動
- 編集中 Buffer を送信
- 選択行を送信
- Neovim を離れずに AI と対話

## Roadmap

orbit.nvim は単なる Codex ラッパーではありません。

将来的には以下の機能を実現したいと考えています。

- Context Sharing
  - AGENTS.md Support
- Session Management
- Multi-Agent Collaboration
- AI Agent Workflow Integration

## コマンド一覧

| Command            | Description             |
|--------------------|-------------------------|
| OrbitStart         | エージェント起動        |
| OrbitRelease       | エージェント停止        |
| OrbitSendBuffer    | 編集中 file buffer 送信 |
| OrbitSendSelection | 選択範囲送信            |

## LICENSE

MIT
