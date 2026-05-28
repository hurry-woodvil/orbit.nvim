# orbit.nvim

Neovim から AI エージェントを操作し、
エディタ状態・プロジェクト情報・作業文脈を共有するためのプラグイン。

---

# なぜ orbit.nvim を作るのか

現在の AI 開発では、
コード・エラー・作業状態を毎回 AI に説明する必要がある。

例えば以下のような課題が存在する。

- コードを毎回コピー＆ペーストする必要がある
- プロジェクトの文脈を繰り返し説明する必要がある
- Diagnostics やエラー内容を都度共有する必要がある
- AI セッションを再開しづらい
- AI エージェントを切り替えるたびに状態共有が必要になる

orbit.nvim は、
Neovim 自体を AI 開発の管制塔にすることを目的とする。

---

# Philosophy

orbit.nvim は以下の思想で設計する。

- Neovim を中心に据える
- AI は補助ではなく協働相手として扱う
- Chat UI より Context 共有を重視する
- 小さく反復可能なワークフローを優先する
- AI 作業を resume 可能にする
- 複数 AI エージェントを統一的に扱えるようにする

---

# Features

## MVP

- Neovim から Codex を起動
- 現在 buffer を送信
- 選択範囲を送信
- プロジェクト情報を送信
- AI の応答を Neovim 上に表示
- AGENTS.md を生成
- AI セッションを resume

## Planned

- Diagnostics 送信
- Quickfix 送信
- Claude Code 対応
- Gemini 対応
- エージェント間 Context 共有
- patch apply workflow
- Project-aware context management

---

# Project Context Sharing

orbit.nvim は、
単なる Chat UI ではなく、
Neovim 上の開発状態を AI エージェントへ共有することを重視する。

共有対象の例:

- current buffer
- visual selection
- project root
- git diff
- diagnostics
- quickfix
- AGENTS.md
- 作業中の session 情報

これにより、
AI エージェントを切り替えても、
現在の開発状態を継続したまま作業できることを目指す。

---

# Non Goals

orbit.nvim は以下を目的としない。

- 汎用 Chat UI
- クラウドサービス
- IDE の完全置き換え
- 完全自律 AI

orbit.nvim の主目的は、
Neovim 内で AI エージェントとの開発ワークフローを統合することである。

---

# Roadmap

## Phase 1 — MVP

- [ ] Codex 起動
- [ ] AI 応答表示
- [ ] 現在 buffer 送信
- [ ] 選択範囲送信
- [ ] プロジェクト情報送信
- [ ] AGENTS.md 生成

## Phase 2 — Workflow Integration

- [ ] resume 対応
- [ ] Diagnostics 対応
- [ ] Quickfix 対応
- [ ] Git diff 共有

## Phase 3 — Multi-Agent Support

- [ ] Claude Code 対応
- [ ] Gemini 対応
- [ ] エージェント切り替え
- [ ] エージェント間 Context 共有

---

# Development

orbit.nvim は AI 駆動開発で開発される。

開発管理は以下を利用する。

- GitHub Issues
- GitHub Milestones
- AGENTS.md
- design documents

今後、ドキュメントや設計資料を追加予定。
