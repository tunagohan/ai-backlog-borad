# Decision Log

形式:
- [Question] yyyy-mm-dd: ...
- [Proposal] yyyy-mm-dd: ...
- [Decision] yyyy-mm-dd: ...

---

## Current Snapshot (2026-02-18)
- フェーズ: BUILD（MVP実装完了 + Phase2拡張実施中）
- 目的: MVP後の拡張（CSV / 画像添付 / 通知）を反映し、次実装の判断材料を明確化する
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

## Build Decisions (2026-02-18)
- [Decision] 2026-02-18: Q1 階層スコープは Asset までMVP対象として実装完了。
- [Decision] 2026-02-18: Q2 認証はダミーユーザー前提を維持し、将来差し替え可能なAPI構成で実装。
- [Decision] 2026-02-18: Q3 テンプレートは会社共通 + version固定で実装。
- [Decision] 2026-02-18: Q4 点検結果は結果保存API（一括保存）で実装。
- [Decision] 2026-02-18: Q5 不具合必須項目は title/description を中心にMVP構成で実装。
- [Decision] 2026-02-18: Q6 画像添付はMVP対象外として判定し、Phase2 Step2で実装完了。
- [Decision] 2026-02-18: Q7 オーナー閲覧は画面中心（ダッシュボード/一覧）で実装。
- [Decision] 2026-02-18: Q8 通知連携はMVP対象外として判定し、Phase2 Step3でアプリ内通知を実装完了（メール/外部連携は未対応）。
- [Decision] 2026-02-18: Q9 一次ICPは複数物件オーナー想定で継続。
- [Decision] 2026-02-18: Q10 `/health` と監査ログ（audit_logs）をMVP必須として実装。
- [Decision] 2026-02-18: M0-M4実装が完了し、MVPの主要導線（登録 -> 設定 -> 実施 -> 不具合 -> 可視化）が成立。
- [Decision] 2026-02-18: Phase2 Step1としてCSV出力（`GET /api/v1/dashboard.csv`）を実装完了。

## Remaining Questions (post Phase2)

| Order | Question | Proposal (Integrator) | Owner | 依存/影響 |
|---|---|---|---|---|
| 1 | 通知チャネルをどこまで拡張するか（メール/外部連携） | 先にアプリ内通知を運用し、誤検知率/利用頻度を計測してメール通知の要否を判定 | PO + Research + BE | 通知ノイズ、運用負荷 |
| 2 | オーナー向け帳票をPDFまで対応するか | CSV運用での実利用確認後にPDFを再評価し、優先度が高い場合のみ着手 | PO + FE | 実装コスト、利用価値 |
| 3 | 本認証（owner以外ロール含む）をいつ導入するか | MVP/Phase2の検証結果を基に、Phase3でRBAC導入計画を策定 | PO + BE + FE | セキュリティ、運用設計 |
