# SendBuffer Design

## Overview

現在の file buffer の内容を AI agent に共有する。

これにより、ユーザーは Neovim を離れることなく、
編集中のファイルについて AI agent に相談できる。

## User Interaction

ユーザーはコマンドを実行することで、
現在の file buffer の内容を AI agent に送信できる。

`:OrbitSendBuffer`

## Behavior

- 対象は通常の file buffer とする
- 未保存 buffer でも現在の buffer 内容を送信対象とする
- file path が存在しない場合は、buffer name または `[No Name]` として扱う
- terminal buffer、help buffer、quickfix buffer などの特殊 buffer は今回の対象外とする
- workspace が起動していない場合は error notify を表示し、送信しない

## Buffer Selection

送信対象は workspace state が保持する last active file buffer とする。

以下の buffer は送信対象としない。

- workspace buffer
- terminal buffer
- help buffer
- quickfix buffer
- その他特殊 buffer

## Context Format

送信内容に少なくとも以下を含める。

- buffer name または file path
- filetype
- buffer content

AI agent が対象ファイルを識別し、内容を理解できる形式で送信する。

現在の実装では以下の text format を利用する。

````txt
# Buffer Context

Name: path/to/file.lua
Filetype: lua

```lua
buffer content
```
````

file path または buffer name が存在しない場合は、
`[No Name]` を `Name` として利用する。

空 buffer は error にせず、
metadata と空 content を含む context として送信する。

## Error Case

以下のケースは error notify を表示し、送信しない。

- 送信対象 buffer が存在しない
- file buffer以外が選択された
- orbit workspace が未起動

## Dependencies

本 feature は workspace state に依存する。

送信対象 buffer は workspace state が保持する
last active file buffer を利用する。

そのため、file buffer の追跡機能が利用可能であることを
前提とする。

## Test Story

### Setup

- Codex を terminal buffer 上で起動できること
- 任意の file buffer を開いていること

### Steps

1. Neovim で file buffer を開く
2. `:OrbitSendBuffer` を実行する
3. Codex terminal buffer に内容が送信されることを確認する

### Expected Result

- current buffer の内容が Codex に送信される
- Codex が送信された内容を読み取れる
- Neovim が error を出さない
