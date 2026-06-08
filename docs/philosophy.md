# Philosophy

## What is orbit.nvim

> AI agents are not the center.
> The project is.

orbit.nvim は、プロジェクトを中心に複数の AI エージェントが
コンテキストを共有しながら協調できる開発環境を目指す Neovim プラグインです。

近年、Codex、Claude Code、Gemini CLI など、
さまざまな AI コーディングエージェントが登場しています。

それぞれに得意分野があり、開発者は用途に応じて複数のエージェントを
使い分ける時代が到来しつつあります。

しかし、エージェントを切り替えるたびに、

- プロジェクトの背景
- 設計意図
- 過去の議論
- 現在の作業状況

を共有し直さなければなりません。

README、AGENTS.md、設計書、Issue、セッション履歴。

プロジェクトを理解するために必要な情報は存在していても、
それらはエージェントごとに分断されがちです。

orbit.nvim は、この問題を Project、Context、Agent という考え方で捉えます。

- Project は開発の中心です。
- Context はプロジェクトを理解するための情報です。
- Agent は Context を利用して Project を支援します。

orbit.nvim は特定の AI エージェントのためのプラグインではありません。

プロジェクトの文脈を管理し、必要な Context を必要なタイミングで
AI エージェントに共有することで、複数のエージェントが同じプロジェクトを
理解しながら開発を支援できる環境を目指しています。

また、単純に大量のファイルを送信するのではなく、
トークン利用量を考慮しながら必要な情報を選択・共有することも
重要なテーマのひとつです。

Agent は入れ替わるかもしれません。

しかし、Project と Context は残ります。

orbit.nvim は、その Project を中心とした開発体験を提供します。

## Why orbit

**orbit** には「軌道」という意味があります。

orbit.nvimでは、

- Project が中心
- Context が軌道
- Agent がその軌道上を周回する存在

として捉えています。

AI エージェントはプロジェクトを理解するために
Context を利用します。

異なるエージェントであっても、同じ Context を共有できれば、
同じ Project を理解しながら開発に参加できます。

この関係は、惑星の周囲を衛星が周回する軌道のようなイメージです。

Project を中心に Context が形成され、その Context を
利用しながら Agent が周回する。

それが orbit.nvim という名前の由来です。

AI が中心の開発環境ではありません。

Project が中心の開発環境です。

