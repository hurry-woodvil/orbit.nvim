# workflow.md

Version: v0.1

---

# Overview

orbit.nvim は、
AI 駆動開発 workflow を前提として開発を行う。

GitHub Project は、
Issue の状態管理と、
AI に依頼可能な状態管理を目的として利用する。

---

# GitHub Project Workflow

Project は以下の workflow を利用する。

```txt
Backlog
↓
Ready
↓
In Progress
↓
Review
↓
Done
```

---

# Status Definitions

## Backlog

Issue 作成直後の状態。

まだ整理されていない状態を表す。

---

## Ready

AI に依頼可能な状態。

以下が整理済みであること。

- Scope
- Out of Scope
- Acceptance Criteria
- Test Story

Ready は、
AI が単独で作業可能な状態を意味する。

---

## In Progress

現在作業中の状態。

AI または人間が実装を進めている状態を表す。

---

## Review

実装後の動作確認・レビュー状態。

orbit.nvim では、
「コードが存在する」だけでは完了としない。

以下を確認する。

- terminal integration が動作する
- command が実行できる
- エラーが発生しない
- workflow が成立している

---

## Done

動作確認完了状態。

Review が完了し、
実際に利用可能な software として成立している状態を表す。

---

# Feature Workflow

Feature Issue は、
ユーザー価値単位で管理する。

```txt
Ready
↓
In Progress
↓
Review
↓
Done
```

Feature Review は、
Feature PR 作成後に行う。

Done は、
PR merge 完了後とする。

---

# Task Workflow

Task Issue は、
Feature を構成する実装単位として管理する。

```txt
Ready
↓
In Progress
↓
Review
↓
Done
```

Task Review は、
実装後の動作確認状態を表す。

Task は、
「コードを書いた」ではなく、
「動作確認済み」で Done とする。

---

# Development Philosophy

orbit.nvim は、
以下を重視する。

- 小さな変更
- 小さな PR
- 動作確認可能な software
- terminal-native workflow
- AI に依頼可能な Issue 管理
- 過剰 abstraction の抑制
