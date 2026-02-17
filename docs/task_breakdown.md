# Task Breakdown

## Execution Status (2026-02-18)
- M0: completed
- M1: completed
- M2: completed
- M3: completed
- M4: completed
- Current phase: BUILD (MVP implementation completed)

## Planning Assumptions (DISCOVERY)
- MVP導線: 会社登録 -> 階層登録（物件/店舗/スペース/資産） -> テンプレート作成 -> 業務作成/実施 -> 不具合報告 -> オーナー確認
- 認証: ダミーユーザー固定（ownerロール）、`current_user` 抽象は先に入れる
- 非機能: `/health`、構造化ログ、主要イベント計測をMVP必須とする

## MVP Implementation Order

### M0: Discovery Freeze (承認前)
- [PO] PRDとMVP境界を確定（一次ICP、In/Out scope、AC）
- [Design] 主要画面の状態設計（empty/loading/error）と導線を確定
- [BE] API境界（エンドポイント/データモデル/RBAC）の叩き台を確定
- [FE] ルーティング/API連携方針とエラー方針を確定
- [Research] 無料枠インフラと検証計画（実験/成長仮説）を確定
- AC: `docs/*.md` で役割間の前提矛盾がない
- テスト観点: `docs/decision_log.md` のOpen Questionsに解消順と担当が定義済み

### M1: Setup Foundation (Company to Asset)
- [BE] 会社/物件/店舗/スペース/資産のCreate/Read APIを実装
- [FE] セットアップ画面（会社/階層登録）を実装
- [Design] 階層登録UIのコンポーネントルール（フォーム、一覧、バリデーション）を定義
- AC: 点検対象階層を登録し、一覧で確認できる
- テスト観点: 階層整合性、必須項目、エラー時復帰

### M2: Inspection Preparation (Template and Job)
- [BE] テンプレート（section/item/result_type/version）と業務ジョブ作成APIを実装
- [FE] テンプレート作成画面・業務作成画面を実装
- [PO] 「業務開始/完了」の運用定義を確定
- AC: 会社共通テンプレートを作成し、対象階層へジョブ割当できる
- テスト観点: version固定、入力型整合、ジョブ作成バリデーション

### M3: Core Execution (Inspection to Issue)
- [BE] 業務開始/結果一括保存/完了/不具合作成APIを実装
- [FE] 点検実施画面と不具合報告画面を実装（入力保持、再送可能）
- [Design] 実施画面の入力負荷最適化と不具合報告UXを最終化
- AC: 1つのジョブで点検実施から不具合報告まで完結する
- テスト観点: 状態遷移（scheduled -> in_progress -> completed）、必須入力、API失敗時再試行

### M4: Owner Visibility and Ops Minimum
- [FE] ダッシュボード/不具合一覧（物件別直近点検と未解決件数）を実装
- [BE] `/health`、監査ログ、基本メトリクス出力を実装
- [Research] 週次計測運用（完了率/報告率/リードタイム）を定義
- AC: オーナーが物件単位で状況を俯瞰でき、運用ログで追跡可能
- テスト観点: フィルタ整合、監査ログ必須項目、ヘルスチェック応答

## Role Allocation Summary
- PO: スコープ固定、AC承認準備、運用ルール確定
- Design: 状態設計、画面導線、入力体験最適化
- BE: データモデル、RBAC、ジョブ/不具合API、運用基盤
- FE: 画面導線、APIクライアント、エラー復帰、レスポンシブ
- Research: ICP/価格/チャネル仮説、無料枠評価、計測運用
