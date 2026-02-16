# Project Instructions (Codex)

このリポジトリは **PO/Design/BE/FE/Integrator/Research** の役割別スレッドで進めます。
すべての作業は **ファイルに成果物を残す**こと（会話だけで結論を出さない）。

## Golden Rules
1. SSOT は `docs/`。仕様・決定・タスク分解は必ず `docs/` を更新する。
2. `docs/approval.md` が `approved` になるまで **実装（backend/frontend の大きな変更）をしない**。
   - 先に「DISCOVERY フェーズ」で設計を固める
   - 承認後「BUILD フェーズ」で実装する
3. 未確定は `docs/decision_log.md` に「Question / Proposal / Decision」で追記する。
4. 変更したら、該当スレッドは `articles/runlog/` に
   - 入力プロンプト（要約でOK）
   - 生成物（差分）
   - 実行したコマンド / 失敗と修正
   を残す（記事化のため）。

## Phases
- DISCOVERY: docs のみ更新（調査・仮説・PRD・設計・タスク分解）
- BUILD: 実装・テスト・最小デモまで

現在のフェーズは `docs/approval.md` を参照すること。

## Coding standards (minimum)
- 追加依存は必要最小限。導入理由と代替案をPR本文（または runlog）に書く。
- 実装前に「受け入れ条件(AC)」と「テスト観点」を docs に明記する。
