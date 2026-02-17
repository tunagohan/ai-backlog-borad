# Decision Log

形式:
- [Question] yyyy-mm-dd: ...
- [Proposal] yyyy-mm-dd: ...
- [Decision] yyyy-mm-dd: ...

---

## Current Snapshot (2026-02-17)
- フェーズ: DISCOVERY
- 目的: 役割別ブランチ（PO/Design/BE/FE/Research）の提案を統合し、承認判断可能な状態にする
- 前提: `docs/po.md` / `docs/design.md` / `docs/api.md` / `docs/frontend.md` / `docs/experiments.md` / `docs/growth.md` を統合済み

## Open Questions (未決事項一覧)

| Order | Question | Proposal (Integrator) | Owner | 依存/影響 |
|---|---|---|---|---|
| 1 | MVP対象階層をどこまで必須にするか（Store/Space/Assetまで含めるか） | `docs/po.md` 準拠で階層登録はAssetまで対象とし、CRUDはCreate/Read優先で段階実装 | PO + BE | データモデル確定、MVP可用性 |
| 2 | 認証方式をMVPでどう扱うか | ダミーユーザー固定（ownerロール）で開始し、`current_user` 抽象を先行実装 | PO + BE + FE | API認可、画面導線 |
| 3 | 点検テンプレート仕様（入力型/版管理/対象紐付け） | 入力型は良否/数値を必須、テキスト補助。テンプレートは会社共通+version固定 | Design + BE | DB設計、ジョブ実行整合 |
| 4 | 点検結果の保存戦略（都度保存/完了時保存） | MVPは完了時一括保存を基本とし、再送可能な冪等キー設計を採用 | BE + FE | API契約、障害復旧性 |
| 5 | 不具合報告の必須項目をどこまでにするか | タイトル/詳細/発生箇所を必須、写真と緊急度は任意（入力負荷優先） | Design + FE + PO | 入力率、データ品質 |
| 6 | 不具合報告の画像添付をMVPで含めるか | MVPはテキストのみ。画像はResearchの無料枠評価後にPhase 2判定 | Research + PO + BE | ストレージ、コスト |
| 7 | オーナー閲覧機能の出力形式（画面のみ/CSV/PDF） | MVPは画面閲覧必須、CSVは任意、PDFは対象外 | PO + FE | 受け入れ判断、実装工数 |
| 8 | 不具合通知チャネル（メール/アプリ内/外部連携） | MVPは通知連携なし。まず一覧可視化とステータス更新を優先 | PO + Research | MVPスコープ、導入価値 |
| 9 | MVP一次ICPの確定（オーナー vs ビルメン） | 一次ICPは複数物件オーナー、ビルメンは二次ICPとして検証継続 | PO + Research | 営業導線、優先要件 |
| 10 | 運用最低ライン（監視/監査/計測）をどこまで必須化するか | `/health`、構造化ログ、主要イベント計測をMVP必須とする | BE + Research | 運用安定性、成長計測 |

## Resolution Sequence (解消順)
1. Q1 MVP階層スコープ確定（PO/BE）
2. Q2 認証方針確定（PO/BE/FE）
3. Q3 テンプレート仕様と版管理確定（Design/BE）
4. Q4 結果保存戦略確定（BE/FE）
5. Q5 不具合必須項目確定（Design/FE/PO）
6. Q6 画像添付要否確定（Research/PO/BE）
7. Q7 オーナー出力形式確定（PO/FE）
8. Q8 通知チャネル方針確定（PO/Research）
9. Q9 一次ICP確定（PO/Research）
10. Q10 監視/計測最低ライン確定（BE/Research）

## Log Entries
- [Question] 2026-02-17: 各ロールブランチ間でMVP範囲（階層、保存戦略、出力形式）の粒度差があるため、承認前に未決事項を1つの順序へ統合する必要がある。
- [Proposal] 2026-02-17: PRD準拠でDISCOVERY成果を統合し、未決事項は「実装依存の強い順」で10件に整理する。
- [Proposal] 2026-02-17: `task_breakdown` をMVPが通る順（Setup -> Foundation -> Core -> Visibility -> Ops）に再構成し、担当ロールを明確化する。
- [Decision] 2026-02-17: 未承認（human approval待ち）。`docs/approval.md` の status は `pending` のまま維持。
