# design.md

Version: v0.1

---

# Overview

orbit.nvim は、
Neovim から AI エージェントを操作し、
エディタ状態・プロジェクト情報・作業文脈を共有するためのプラグインである。

AI エージェントは terminal buffer 上で動作し、
Neovim 上で AI workflow を統合する。

---

# Design Goals

orbit.nvim は以下を目的とする。

- Neovim から AI エージェントを起動できる
- terminal buffer 上で AI CLI を操作できる
- editor state を AI に共有できる
- project context を AI に共有できる
- session を resume 可能にする
- 将来的に複数 AI エージェントを扱えるようにする

---

# MVP Scope

初期実装では以下を対象とする。

- Codex を terminal buffer 上で起動する
- Codex への指示入力を terminal buffer 上で行う
- Codex の response を terminal buffer 上に表示する
- current buffer を Codex に送信する
- visual selection を Codex に送信する
- project context を Codex に送信する
- AGENTS.md を生成する

---

# Non Goals

初期実装では以下を対象としない。

- 独自 Chat UI
- 完全自律 AI
- 高度な patch apply
- 初期段階での multi-agent abstraction
- event bus
- plugin architecture
- dependency injection
- 過度な abstraction

まずは、
小さく動作する workflow を優先する。

---

# UI Design

AI エージェントは、
Neovim の terminal buffer 上で実行する。

orbit.nvim は、
AI CLI の terminal workflow を維持することを重視する。

## terminal buffer の役割

terminal buffer は以下を統合的に扱う。

- AI エージェントの起動
- AI への指示入力
- AI response の表示
- stdout/stderr の表示
- interactive command の実行
- session resume

orbit.nvim は、
独自 Chat UI を過剰実装せず、
AI CLI 本来の操作感を維持する。

## 理由

- AI CLI 本来の UX を維持できる
- stdout/stderr を自然に扱える
- interactive CLI と相性が良い
- session resume と相性が良い
- terminal ecosystem を活用できる
- Codex / Claude / Gemini の切り替えと相性が良い

---

# Initial Module Design

初期実装では、
必要になった module から追加する。

現時点での構成候補は以下。

```txt
lua/orbit/
  init.lua
  config.lua
  commands.lua
  terminal.lua
  state.lua
  session.lua
  agent.lua
```

## state.lua

Neovim / orbit.nvim の現在状態を扱う。

例:

- current buffer
- diagnostics
- quickfix
- working directory

## context

AI エージェントへ共有する情報を指す。

例:

- prompt
- project information
- buffer content
- metadata

## session.lua

AI workflow の継続状態を扱う。

例:

- agent 種別
- terminal buffer
- working directory
- resume metadata

初期段階では、
module 分割を過剰に行わない。

---

# Command Design

現時点で想定する command。

```vim
:OrbitStart
:OrbitSendBuffer
:OrbitSendSelection
:OrbitSendProject
:OrbitGenerateAgents
:OrbitResume
```

command は MVP 実装とともに調整する。

---

# Context Design

AI エージェントへ共有する context は、
以下を基本とする。

- current buffer
- visual selection
- project root
- git diff
- diagnostics
- quickfix
- AGENTS.md
- session metadata

context の詳細形式は、
実装とともに調整する。

---

# Session Design

session は、
AI workflow の継続を目的として管理する。

初期実装では以下を保持対象とする。

- working directory
- terminal buffer 情報
- agent 種別
- 実行 command

高度な session synchronization は、
後続対応とする。

---

# Multi-Agent Design

将来的には以下を想定する。

- Codex
- Claude Code
- Gemini CLI

ただし、
初期実装では Codex first とする。

初期段階では、
multi-agent abstraction を過剰実装しない。

---

# Development Policy

orbit.nvim は AI 駆動開発で進行する。

以下を重視する。

- 小さな変更
- 小さな PR
- 1 PR = 1 Feature Issue
- resume 可能な workflow
- 過剰 abstraction の抑制
- terminal workflow 優先

---

# Future Design

将来的には以下を検討する。

- diagnostics integration
- quickfix integration
- patch apply workflow
- shared agent context
- agent switching
- session synchronization
- project-aware context management

ただし、
MVP 完成前に過剰実装しない。
