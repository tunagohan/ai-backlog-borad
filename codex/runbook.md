# Runbook: PO/Design/BE/FE/Integrator/Research を並列運用する

## 0. 入力
`docs/idea.md` を埋める（雑でOK）。

## 1. DISCOVERY フェーズ（docsのみ）
Codexで Worktree を使い 6 スレッドを作る:
- PO / Design / BE / FE / Integrator / Research

各スレッドは `codex/prompts/<role>.md` を貼る。
Integrator が `docs/approval.md` を `pending` のまま、必要な docs を揃える。

## 2. 承認（あなたがOK）
- チャットで「OK」 と返す  *or*
- `docs/approval.md` の `status` を `approved` に変えてコミット

## 3. BUILD フェーズ（実装）
Integrator が `codex/prompts/build.md` を使って、BE/FEに実装を割り振る。
以降は PR 単位で進める（小さく、動くものを積む）。

## 記事化
各スレッドは run のたびに `articles/runlog/` へログを残す。
