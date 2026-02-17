# Decision Log

形式:
- [Question] yyyy-mm-dd: ...
- [Proposal] yyyy-mm-dd: ...
- [Decision] yyyy-mm-dd: ...

---

## Current Snapshot (2026-02-17)
- フェーズ: DISCOVERY
- 目的: 承認判断可能なMVPスコープと実装順を確定する
- 前提: `docs/idea.md` の「会社登録 -> 点検業務実施 -> 不具合報告」を最短導線として扱う

## Open Questions (未決事項一覧)

| Order | Question | Proposal (Integrator) | Owner | 依存/影響 |
|---|---|---|---|---|
| 1 | MVPで扱う業務範囲はどこまでか（階層フル対応か最小導線か） | 会社/物件/店舗までをMVP対象。スペース/資産の詳細管理はPhase 2へ延期 | PO | 全体スコープ、BE/FE工数 |
| 2 | 認証・ユーザー管理をMVPでどこまで実装するか | ダミーユーザー固定ログイン（認証UIなし）で開始。監査ログにユーザーIDを残す | PO + BE | API設計、画面導線 |
| 3 | 点検テンプレート仕様（大項目/項目/入力型）を固定化するか | 入力型を「良否」「数値」「テキスト」の3種に限定し、テンプレートversionを持つ | Design + BE | DB設計、UI複雑性 |
| 4 | 不具合報告に画像添付を含めるか | MVPはテキスト+優先度+発生日のみ。画像はResearchで無料ストレージ案比較後に判断 | Research + PO | インフラ、UI、コスト |
| 5 | オーナー向けレポート出力形式 | MVPは画面一覧+CSVのみ。PDF帳票はPhase 2候補 | PO + FE | 受け入れ条件、UX |
| 6 | 監視/運用の最低ライン | APIヘルスチェック、基本ログ、エラートラッキング最小設定をMVP必須化 | BE | 運用品質、障害検知 |

## Resolution Sequence (解消順)
1. Q1 スコープ確定（PO）
2. Q2 認証方針確定（PO/BE）
3. Q3 点検テンプレート仕様確定（Design/BE）
4. Q4 画像添付要否確定（Research/PO）
5. Q5 レポート形式確定（PO/FE）
6. Q6 運用最低ライン確定（BE）

## Log Entries
- [Question] 2026-02-17: MVPにスペース/資産管理まで含めるべきか、または会社登録->点検->不具合報告の最短導線に限定すべきか。
- [Proposal] 2026-02-17: 承認判断を早めるため、MVPは最短導線に限定し、詳細階層と高コスト機能（画像/PDF）をPhase 2へ分離する。
- [Proposal] 2026-02-17: 認証はダミーユーザー固定で先行し、監査性はログで担保してBUILDを開始できる状態を作る。
- [Decision] 2026-02-17: 未承認（human approval待ち）。本ファイルのProposalを承認会で採否判定する。
