# SendSelection Design

## Overview

現在の file buffer で選択した範囲の内容を AI agent に共有する。

これにより、ユーザーはファイル全体ではなく、必要な範囲だけを
AI agent に相談できる。

## User Interaction

ユーザーは file buffer 上で visual mode に入り、
範囲選択した状態で command を実行する。

`:OrbitSendSelection`

## Behavior

- 対象は通常の file buffer 上の visual selection とする
- 選択範囲の content を送信対象とする
- file path が存在しない場合は buffer name または `[No Name]` として扱う
- selection range を context に含める
- terminal buffer、help buffer、quickfix buffer などの特殊 buffer は対象外とする
- workspace が未起動の場合は error notify を表示し、送信しない

## Selection Lifetime

SendSelection は visual mode で選択されている範囲を即時取得して送信する。

選択範囲は workspace state に保持しない。

他 buffer へ移動した後の visual selection は送信対象としない。

ユーザーは file buffer 上で visual selection を行った状態で
`:OrbitSendSelection` を実行することを前提とする。

## Supported Visual Modes

MVP では以下をサポートする。

- linewise selection
- charwise selection

以下は MVP の対象外とする。

- blockwise selection

## Selection Range

MVP では selection range を行番号単位で扱う。

linewise selection は、選択開始行から選択終了行までの
行内容を送信対象とする。

charwise selection は、選択範囲を含む行単位を
送信対象とする。

blockwise selection は MVP の対象外とする。

文字単位の selection 送信は将来の拡張対象とする。

## Context Format

送信内容に少なくとも以下を含める。

- buffer name または file path
- filetype
- selection range
- selected content

AI agent が対象ファイルを識別し、内容を理解できる形式で送信する。

現在の実装では以下の text format を利用する。

---

# Selection Context

Name: path/to/file.lua
Filetype: lua
Range: L10-L20

```lua
selected content
```

---

file path または buffer name が存在しない場合は、
`[No Name]` を `Name` として利用する。

## Error Cases

以下のケースは error notify を表示し、送信しない。

- visual mode ではない状態で実行された
- selection が存在しない
- 送信対象 buffer が存在しない
- file buffer 以外が選択された
- blockwise selection が指定された
- orbit workspace が未起動

## Dependencies

本機能は SendBuffer で導入した Context Sharing 基盤を利用する。

利用するもの:

- context generation
- workspace process send
- command registration

利用しないもの:

- workspace state
- last active file buffer

visual selection は command 実行時に取得する。

## Test Story

### Setup

- AI agent workspace を起動できること
- 任意の file buffer を開いていること

### Steps

1. Neovim で file buffer を開く
2. visual mode で範囲選択する
3. `:OrbitSendSelection` を実行する
4. AI agent workspace に選択内容が送信されていることを確認する

### Expected Result

- 選択範囲だけが AI agent に送信される
- AI agent が送信内容を読み取れる
- Neovim が error を出さない

