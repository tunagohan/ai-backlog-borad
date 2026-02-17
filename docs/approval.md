# Approval Gate

status: pending  # pending | approved

## What is approved?
- `docs/po.md` のスコープとAC
- `docs/design.md` の画面/状態
- `docs/api.md` / `docs/frontend.md` の主要方針
- `docs/task_breakdown.md` のMVP計画

## Approval Checklist (for human reviewer)
- `docs/decision_log.md` のOpen Questionsに対して採否が明示されている
- MVP対象外（画像添付、PDF、本認証、詳細階層）が合意されている
- 各ロール（PO/Design/BE/FE/Research）の担当と順序に矛盾がない
- ACとテスト観点がM0-M3で不足なく定義されている

## Notes
- `approved` になるまで BUILD を開始しない（AGENTS.md参照）
- 本ファイルはIntegratorが更新しても `pending` のまま維持する（承認操作は人間のみ）
