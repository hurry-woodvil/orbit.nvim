# AGENTS.md

# Overview

orbit.nvim は、
Neovim から AI エージェントを操作し、
エディタ状態・プロジェクト情報・作業文脈を共有するためのプラグインである。

このプロジェクトは AI 駆動開発で進行する。

---

# Language

以下はすべて日本語で記載する。

- README
- 設計書
- Issue
- PR
- コミットメッセージ
- Session Note

---

# Development Philosophy

以下の思想を優先する。

- Neovim を中心に据える
- AI は協働相手として扱う
- Chat UI より Context 共有を重視する
- 小さく反復可能な開発を優先する
- resume 可能な workflow を重視する
- 複数 AI エージェントを統一的に扱えるようにする

---

# MVP Priority

まずは MVP を優先する。

MVP の目的は、
最小構成で AI workflow を成立させることである。

現時点では以下を優先する。

- Codex 起動
- buffer 送信
- selection 送信
- project context 送信
- AI response 表示
- AGENTS.md 生成

将来構想を先行実装しすぎないこと。

---

# UI Guidelines

- AI エージェントは terminal buffer 上で動作させる
- 独自 Chat UI を過剰実装しない
- terminal workflow を優先する
- stdout/stderr を自然に扱える構成を優先する
- AI CLI 本来の操作感を維持する

orbit.nvim は、
terminal-native な AI workflow を重視する。

---

# Architecture Guidelines

過剰抽象化を避けること。

必要になるまでは以下を導入しない。

- 大規模 abstraction layer
- event bus
- plugin architecture
- dependency injection
- 過度な interface 分離
- premature optimization

まずはシンプルに実装し、
必要になった段階で分離する。

---

# Implementation Guidelines

- 小さな変更を優先する
- 1 Issue = 1 目的 を意識する
- 不要なリファクタを避ける
- 関係ないファイルを変更しない
- 既存挙動を壊さない
- 動作確認可能な状態を維持する

## 既存状態の確認

AI は、
install・設定変更・file 生成を行う前に、
既存状態を確認すること。

例:

- command が存在するか
- formatter が install 済みか
- file が存在するか
- plugin が読み込み済みか
- 同等機能が既に存在しないか

不要な install・重複実装・設定競合を避けること。

既存状態が不明な場合は、
確認手順を Task の Test Story または Notes に記載すること。

---

# Repository Structure

現在はシンプルな構成を維持する。

```txt
lua/orbit/
```

必要になるまでは複雑化しない。

---

# Git Guidelines

コミットメッセージは日本語で記載する。

形式:

```txt
<type>: <内容>
```

Issue に関連する変更の場合は、
Issue 番号を記載する。

## refs

開発途中の場合は `refs` を利用する。

例:

```txt
feat: Codex 起動コマンドを追加 refs #10
```

## closes

Issue を完了できる状態の場合は `closes` を利用する。

例:

```txt
feat: buffer 送信機能を追加 closes #12
```

Issue に関連しない変更の場合は、
Issue 番号の記載は不要。

---

# Pull Request Guidelines

- 1 PR = 1 Feature Issue を原則とする
- PR は単一の Feature 完了に集中させる
- 関係ない変更を含めない
- 不要なリファクタを行わない
- 小さな PR を優先する
- Out of Scope を明確にする
- 手動確認方法を記載する

---

# Issue Guidelines

## Feature Issue

Feature Issue は、
ユーザー価値単位で作成する。

例:

```txt
[Feature] 現在 buffer を Codex に送信できる
```

## Task Issue

Task Issue は、
実装単位で分割する。

Task は単独 commit 可能な粒度にする。

例:

```txt
[Task] current buffer の内容を取得する
[Task] Codex process を起動する
```

AI へ依頼する場合は、
Task 単位を推奨する。

---

# Session Notes

作業終了時は Session Note を残す。

最低限以下を記載する。

- 何を実装したか
- 変更ファイル
- 動作内容
- テスト方法
- 次にやるべきこと

---

# Definition of Done

以下を満たした場合に完了とする。

- Acceptance Criteria を満たす
- 不要な抽象化を導入していない
- 既存機能を壊していない
- 手動確認できる
- 必要なドキュメントを更新している
