# Runlog: Integrator (2026-02-17)

## Input Prompt (summary)
- `docs/` を確認し、DISCOVERYを「承認判断できる状態」に整備する。
- 対象: `docs/decision_log.md` 整理、`docs/task_breakdown.md` をMVP実装順へ再構成、`docs/approval.md` は `status: pending` 維持。
- 追加: `articles/runlog/YYYYMMDD-integrator.md` に実施ログを残す。

## What was decided / proposed
- Integrator提案として、MVPを最短導線（会社登録 -> 点検 -> 不具合報告）に限定。
- 未決事項を6件に整理し、解消順と担当を提案。
- タスク分解をM0-M3で再編し、各チケットにAC/テスト観点を追加。
- 承認ステータスは `pending` のまま維持（人間承認待ち）。

## Remaining Issues
- Q1: MVP範囲の最終確定（PO）
- Q2: 認証方針（ダミーユーザー固定で進めるか）の確定（PO/BE）
- Q3: 点検テンプレート入力型/版管理の確定（Design/BE）
- Q4: 画像添付の要否と無料枠リスクの確定（Research/PO）
- Q5: オーナー向け出力形式（CSVのみか）の確定（PO/FE）
- Q6: 監視/運用最低ラインの確定（BE）

## Artifacts (diff summary)
- `docs/decision_log.md`
  - Open Questions表、解消順、担当、Proposal/Decisionログを追加。
- `docs/task_breakdown.md`
  - MVP実装順（M0-M3）へ再構成し、各ロールのAC/テスト観点を明記。
- `docs/approval.md`
  - `status: pending` を維持したまま承認チェックリストを追加。
- `articles/runlog/20260217-integrator.md`
  - 本ログを新規作成。

## Commands Executed
- `rg --files docs articles/runlog`
- `date +%Y%m%d`
- `sed -n '1,220p' docs/approval.md`
- `sed -n '1,260p' docs/decision_log.md`
- `sed -n '1,260p' docs/task_breakdown.md`
- `sed -n '1,260p' docs/po.md`
- `sed -n '1,260p' docs/design.md`
- `sed -n '1,260p' docs/api.md`
- `sed -n '1,260p' docs/frontend.md`
- `sed -n '1,260p' docs/idea.md`
- `ls -la articles`
- `ls -la articles/runlog && rg --files articles/runlog && for f in articles/runlog/*.md; do ...; done`

## Failures and Fixes
- `rg --files articles/runlog` は `.gitkeep` のみで実質対象ファイルなしのため exit code 1 となった。
- 修正: 既存runlogが未作成であることを確認したうえで、新規 `20260217-integrator.md` を追加して解消。

---

## Integration Update (role branches merged in DISCOVERY)

### Input Prompt (summary)
- 各役割（PO/Design/BE/FE/Research）の push 済みブランチ差分を確認し、DISCOVERYを統合する。
- `docs/decision_log.md` と `docs/task_breakdown.md` を統合更新し、`docs/approval.md` は `pending` 維持。
- 最後にDISCOVERY統合PRを作成する。

### Who decided what
- PO案の採用: MVPは「会社登録 -> 階層登録 -> 点検実施 -> 不具合報告 -> オーナー確認」を成立条件とする。
- Design案の採用: 主要導線（セットアップ/実施/確認）と empty/loading/error 状態定義を統合前提にする。
- BE案の採用: 会社境界/RBAC、テンプレートversion固定、ジョブ状態遷移をAPI基準として扱う。
- FE案の採用: ルート構成、APIクライアント集約、エラー復帰（入力保持/再試行）をMVP標準にする。
- Research案の採用: 一次ICPを複数物件オーナー中心で検証し、価格/チャネル仮説は実験で継続検証する。

### Remaining Issues
- 認証をどこまでMVPに含めるか（固定ダミーのままか）
- 不具合画像添付とCSV出力をMVP必須にするか
- 通知チャネル（メール/外部連携）をMVP対象に入れるか
- 監視/監査/計測の運用責任境界をどこで切るか

### Commands Executed
- `git branch --all`
- `git diff --name-status main..codex/02design-discovery -- docs`
- `git diff --name-status main..codex/03be-discovery -- docs`
- `git diff --name-status main..codex/04fe-discovery -- docs`
- `git diff --name-status main..codex/06research-discovery -- docs`
- `git show codex/02design-discovery:docs/design.md`
- `git show codex/02design-discovery:docs/po.md`
- `git show codex/03be-discovery:docs/api.md`
- `git show codex/04fe-discovery:docs/frontend.md`
- `git show codex/06research-discovery:docs/experiments.md`
- `git show codex/06research-discovery:docs/growth.md`
- `git show codex/02design-discovery:docs/decision_log.md`
- `git show codex/03be-discovery:docs/decision_log.md`
- `git show codex/04fe-discovery:docs/decision_log.md`
- `git show codex/06research-discovery:docs/decision_log.md`
- `git checkout codex/02design-discovery -- docs/po.md docs/design.md`
- `git checkout codex/03be-discovery -- docs/api.md`
- `git checkout codex/04fe-discovery -- docs/frontend.md`
- `git checkout codex/06research-discovery -- docs/experiments.md docs/growth.md`

### Failures and Fixes
- `git checkout ...` 初回実行で sandbox 制約により `.git/worktrees/.../index.lock` 作成失敗。
- 修正: 権限昇格で同コマンドを再実行し、docs取り込みを完了。

---

## Build Start Update (approved after DISCOVERY)

### Input Prompt (summary)
- `docs/approval.md` が `approved` になったため、BUILDフェーズへ着手。
- M1（Setup Foundation）として、Company/Property/Store/Space/Asset の基盤APIと最小UIを実装開始。

### Implemented
- Backend (Rails API)
  - `api/v1` に階層登録の Create/List/Show エンドポイントを追加。
  - `Company/Property/Store/Space/Asset` のモデル・関連・バリデーションを追加。
  - 階層テーブルのmigrationを追加。
  - `ApplicationController` に `404` / `422` の共通エラーレスポンスを追加。
- Frontend (Nuxt skeleton)
  - ルート: `/`, `/companies/new`, `/properties`
  - API client共通化 (`frontend/lib/api/client.ts`) と会社/物件APIモジュール追加。
  - 会社登録フォームと物件一覧の最小画面を追加。

### Commands Executed
- `bash scripts/bootstrap.sh`
- `find backend -maxdepth 3 -type f | sort`
- `find frontend -maxdepth 3 -type f | sort`
- `sed -n '1,220p' backend/config/routes.rb`
- `sed -n '1,240p' backend/Gemfile`
- `sed -n '1,220p' backend/app/controllers/application_controller.rb`
- `sed -n '1,220p' backend/config/application.rb`
- `sed -n '1,260p' backend/config/database.yml`
- `ruby -c backend/app/controllers/api/v1/*.rb`
- `ruby -c backend/app/models/*.rb`

### Failures and Fixes
- `bootstrap.sh` で `bundle install` が権限/ネットワーク制約で失敗（`bundler.lock`作成不可、`rubygems.org` 到達不可）。
- `npx nuxi@latest init frontend` が `registry.npmjs.org ENOTFOUND` で失敗。
- 修正: 外部依存インストールは保留し、実装コード（Rails/Nuxtの最小構成）を手動で作成して着手を継続。

### Follow-up (dependency resolution and build verification)
- 依存解決を実施
  - `backend`: `bundle config set --local path vendor/bundle` + `bundle install`
  - `frontend`: `npm install`
- 実行確認を実施
  - `bundle exec rails db:migrate` 成功
  - `bundle exec rails runner` で Company -> Property -> Store -> Space -> Asset 作成成功
  - `npm run build` 成功
- 追加実装
  - フロントに階層登録導線を拡張（`/properties/:propertyId`, `/stores/:storeId`, `/spaces/:spaceId`）
  - `rack-cors` を有効化して開発時のクロスオリジンアクセスを許可

### Additional Failures and Fixes
- `bundle install` 再実行時に `rubygems.org` 到達不可が再発。
- 修正: 権限昇格で再実行し、`rack-cors` を導入完了。
- 角括弧ルートファイル作成時に zsh glob 展開で失敗。
- 修正: ファイルパスをクォートして再生成。

### CI follow-up fixes
- Frontend CIの依存キャッシュを `yarn.lock` 前提から `npm` 前提へ変更（`frontend/package-lock.json` を使用）。
- Backend CIで検出された `Gemfile` の trailing empty line を削除。
- `rubocop` の `db/schema.rb` 生成スタイル差分でCIが落ちる問題に対応し、`Layout/SpaceInsideArrayLiteralBrackets` から `db/schema.rb` を除外。
- ローカル検証:
  - `cd backend && RUBOCOP_CACHE_ROOT=tmp/rubocop_cache bundle exec rubocop` -> no offenses
  - `cd frontend && npm run build` -> success

---

## M2 Build Update (Template and Job)

### Scope
- M2対象として「点検テンプレート作成」「点検ジョブ作成/一覧」の最小導線を実装。

### Backend changes
- 追加モデル:
  - `InspectionTemplate`
  - `InspectionTemplateSection`
  - `InspectionTemplateItem`
  - `InspectionJob`
- 追加API:
  - `GET/POST /api/v1/inspection_templates`
  - `GET /api/v1/inspection_templates/:id`
  - `GET/POST /api/v1/inspection_jobs`
  - `GET /api/v1/inspection_jobs/:id`
- 追加migration:
  - `20260218000005_create_inspection_templates.rb`
  - `20260218000006_create_inspection_template_sections.rb`
  - `20260218000007_create_inspection_template_items.rb`
  - `20260218000008_create_inspection_jobs.rb`

### Frontend changes
- 追加APIモジュール:
  - `frontend/lib/api/templates.ts`
  - `frontend/lib/api/jobs.ts`
- 追加画面:
  - `/tasks/new`（テンプレート作成 + ジョブ作成）
  - `/tasks`（ジョブ一覧）
- `frontend/pages/index.vue` にM2導線リンクを追加。

### Verification
- `cd backend && bundle exec rails db:migrate` 成功
- `cd backend && bundle exec rails runner ...` でテンプレート/ジョブ作成成功
- `cd backend && RUBOCOP_CACHE_ROOT=tmp/rubocop_cache bundle exec rubocop` 成功
- `cd frontend && npm ci` 実行
- `cd frontend && npm run build` 実行

### Failures and fixes
- rubocopでmigrationの配列表記（space inside brackets）違反を検出。
- 修正: 対象migration2件の配列表記を修正。
- `npm ci` 後にローカルNode 22環境で一部依存解決エラーが発生。
- 修正: `npm install` で依存を再解決し、`npm run build` の成功を確認。

---

## M3 Build Update (Execution and Issue flow)

### Scope
- M3対象として「点検実施（開始/結果保存/完了）」と「不具合報告（登録/一覧/クローズ）」を追加。

### Backend changes
- 追加モデル:
  - `InspectionResult`
  - `Issue`
- 追加migration:
  - `20260218000009_create_inspection_results.rb`
  - `20260218000010_create_issues.rb`
- API拡張:
  - `POST /api/v1/inspection_jobs/:id/start`
  - `POST /api/v1/inspection_jobs/:id/results`
  - `POST /api/v1/inspection_jobs/:id/complete`
  - `GET/POST/PATCH /api/v1/issues`
  - `GET /api/v1/inspection_jobs/:id` で template + results を返却

### Frontend changes
- 追加APIモジュール:
  - `frontend/lib/api/execution.ts`
  - `frontend/lib/api/issues.ts`
- 追加画面:
  - `/tasks/:taskId/execute`（実施開始、結果保存、完了）
  - `/issues/new`（不具合登録）
  - `/issues`（不具合一覧、close操作）
- 導線更新:
  - `/tasks` から `execute` へ遷移リンクを追加
  - トップ画面に `issues` への導線を追加

### Verification
- `cd backend && bundle exec rails db:migrate` 成功
- `cd backend && bundle exec rails runner ...` で job start -> result save -> complete -> issue create のスモーク成功
- `cd backend && RUBOCOP_CACHE_ROOT=tmp/rubocop_cache bundle exec rubocop` 成功
- `cd frontend && npm ci` 実行
- `cd frontend && npm run build` は Node 22 ローカルで依存欠落再発のため `npm install && npm run build` で成功確認

### Failures and fixes
- `npm ci` 直後の `npm run build` で `copy-paste` モジュール解決エラーが発生（ローカル Node 22）。
- 修正: `npm install` を再実行して build成功を確認。

---

## M4 Build Update (Owner visibility and ops minimum)

### Scope
- M4対象として「オーナーダッシュボード」と「運用最低機能（health + audit）」を実装。

### Backend changes
- 追加API:
  - `GET /api/v1/health`
  - `GET /api/v1/dashboard?company_id=...`
- 追加モデル/migration:
  - `AuditLog`
  - `20260218000011_create_audit_logs.rb`
- 監査ログ実装:
  - `ApplicationController` に `record_audit!` を追加
  - テンプレート作成、ジョブ作成/開始/結果保存/完了、不具合作成/更新で監査ログ記録
- ダッシュボード集計:
  - 物件ごとの最新完了点検ジョブ
  - 物件ごとの未解決不具合件数
  - 会社全体の合計値（物件数、未解決不具合数、完了ジョブ数）

### Frontend changes
- 追加APIモジュール:
  - `frontend/lib/api/dashboard.ts`
- 追加画面:
  - `/dashboard`（オーナー向けサマリー）
- 導線更新:
  - トップ画面にダッシュボードリンク追加

### Verification
- `cd backend && bundle exec rails db:migrate` 成功
- `cd backend && bundle exec rails routes | rg \"api/v1/(health|dashboard|issues)\"` でルート確認
- `cd backend && RUBOCOP_CACHE_ROOT=tmp/rubocop_cache bundle exec rubocop` 成功
- `cd backend && bundle exec rails runner ...` で dashboard集計/AuditLog保存のスモーク確認
- `cd frontend && npm install && npm run build` 成功

### Failures and fixes
- `npm ci` 実行時に `ENOTEMPTY` が発生。
- `npm install && npm run build` 実行中に npm内部エラー（Exit handler never called）が発生。
- 修正: `frontend/node_modules`/`.nuxt`/`.output` を再作成して再実行し、build成功を確認。

---

## Finalization Update (post M4)

### Objective
- M0-M4の実装完了をdocsへ反映し、MVP完了判定を明文化する。

### Updated docs
- `docs/task_breakdown.md`
  - `Execution Status (2026-02-18)` を追加し、M0-M4 completed を明記。
- `docs/decision_log.md`
  - `Build Decisions (2026-02-18)` を追加し、Q1-Q10の採択結果とMVP導線成立を記録。

### Verification policy
- PR作成後、30秒待機してCIを確認。
- CIが失敗した場合は修正して再確認ループ。
- CI通過後にmergeし、次の実行へ進む。

---

## Phase2 Step1 Update (CSV export)

### Scope
- オーナー向けダッシュボードのCSV出力を追加（任意機能）。

### Backend changes
- `GET /api/v1/dashboard` に `format.csv` を追加。
- CSV列:
  - `property_id`
  - `property_name`
  - `latest_inspection_job_id`
  - `latest_inspection_at`
  - `open_issue_count`

### Frontend changes
- `/dashboard` に `CSVダウンロード` リンクを追加。
- `frontend/lib/api/dashboard.ts` は既存のJSON取得を継続利用。

### Verification
- `cd backend && RUBOCOP_CACHE_ROOT=tmp/rubocop_cache bundle exec rubocop` 成功
- `cd frontend && npm ci` 実行
- `cd frontend && npm install && npm run build` 成功

### Failures and fixes
- rubocopで配列表記のスタイル違反を検出し修正。
- npm実行時にローカル環境で依存ディレクトリ不整合が発生。
- 修正: `frontend/node_modules`/`.nuxt`/`.output` を再生成して build成功を確認。
