# API / Backend design

## Endpoints
- Base path: `/api/v1`
- Content-Type: `application/json`

### 1. Company / User context
| Method | Path | Purpose |
|---|---|---|
| GET | `/me` | ログインユーザーの所属会社・ロールを取得 |
| POST | `/companies` | 会社作成（初期セットアップ） |
| GET | `/companies/:company_id` | 会社詳細取得 |

### 2. Location hierarchy
| Method | Path | Purpose |
|---|---|---|
| POST | `/companies/:company_id/properties` | 物件作成 |
| GET | `/companies/:company_id/properties` | 物件一覧 |
| POST | `/properties/:property_id/stores` | 店舗作成 |
| GET | `/properties/:property_id/stores` | 店舗一覧 |
| POST | `/stores/:store_id/spaces` | スペース作成 |
| GET | `/stores/:store_id/spaces` | スペース一覧 |

### 3. Assets
| Method | Path | Purpose |
|---|---|---|
| POST | `/spaces/:space_id/assets` | 点検対象資産を作成 |
| GET | `/spaces/:space_id/assets` | 資産一覧 |
| PATCH | `/assets/:asset_id` | 資産更新（設置日、状態など） |

### 4. Inspection templates and jobs
| Method | Path | Purpose |
|---|---|---|
| POST | `/inspection_templates` | 点検テンプレート作成（大項目/項目定義） |
| GET | `/inspection_templates` | テンプレート一覧 |
| GET | `/inspection_templates/:template_id` | テンプレート詳細 |
| POST | `/inspection_jobs` | 点検ジョブ作成（対象と実施予定日を指定） |
| GET | `/inspection_jobs` | 点検ジョブ一覧（status/dateで絞り込み） |
| GET | `/inspection_jobs/:job_id` | 点検ジョブ詳細 |

### 5. Inspection execution and issues
| Method | Path | Purpose |
|---|---|---|
| POST | `/inspection_jobs/:job_id/start` | 実施開始（started_at記録） |
| POST | `/inspection_jobs/:job_id/results` | 項目結果を一括保存（良否/数値/コメント） |
| POST | `/inspection_jobs/:job_id/complete` | 実施完了（completed_at記録） |
| POST | `/inspection_jobs/:job_id/issues` | 不具合報告作成 |
| GET | `/issues` | 不具合一覧（company/property/status/filter） |
| PATCH | `/issues/:issue_id` | 不具合ステータス更新（open/in_progress/closed） |

### Example payload (inspection result)
```json
{
  "items": [
    {
      "template_item_id": "tmpl_item_001",
      "result_type": "pass_fail",
      "result_value": "pass",
      "numeric_value": null,
      "comment": "問題なし"
    },
    {
      "template_item_id": "tmpl_item_002",
      "result_type": "numeric",
      "result_value": null,
      "numeric_value": 21.5,
      "comment": "室温"
    }
  ]
}
```

## Data model
- `companies`
  - id, name, created_at, updated_at
- `users`
  - id, company_id, name, email, role(`owner`/`worker`), created_at, updated_at
- `properties`
  - id, company_id, name, address, created_at, updated_at
- `stores`
  - id, property_id, name, created_at, updated_at
- `spaces`
  - id, store_id, name, floor_label, created_at, updated_at
- `assets`
  - id, space_id, name, category, serial_number, installed_on, status, created_at, updated_at
- `inspection_templates`
  - id, company_id, name, version, is_active, created_at, updated_at
- `inspection_template_sections`
  - id, template_id, name, sort_order
- `inspection_template_items`
  - id, section_id, name, result_type(`pass_fail`/`numeric`), unit, sort_order, required
- `inspection_jobs`
  - id, company_id, template_id, target_type(`property`/`store`/`space`), target_id, scheduled_for, status(`scheduled`/`in_progress`/`completed`), assigned_user_id, started_at, completed_at
- `inspection_results`
  - id, job_id, template_item_id, result_value, numeric_value, comment, recorded_by
- `issues`
  - id, company_id, job_id, property_id, store_id, space_id, asset_id, title, description, severity(`low`/`medium`/`high`), status(`open`/`in_progress`/`closed`), reported_by, reported_at, resolved_at
- `audit_logs`
  - id, company_id, actor_user_id, action, resource_type, resource_id, diff_json, created_at

### Data model notes
- 会社テナント境界は`company_id`で一貫管理する。
- 点検テンプレートはバージョン管理し、ジョブ作成時に`template_id`を固定する。
- 結果入力は`inspection_results`へappend/updateし、ジョブ完了時点で監査ログに確定差分を記録する。

## Auth / Permissions
- 認証方式（MVP）:
  - 開発初期は固定ダミーユーザーでログイン済み扱い（セッション/トークンの外部連携は後続）
  - APIレイヤでは`current_user`を必須にし、未認証時は`401`
- 認可（RBAC）:
  - `owner`: 会社配下の全リソースを作成/閲覧/更新可能
  - `worker`: 点検ジョブ閲覧、点検結果入力、不具合作成まで可能。テンプレート作成や会社設定更新は不可
- テナント分離:
  - すべての取得/更新で`company_id == current_user.company_id`を強制
  - 他社データは`404`で秘匿
- 監査対象アクション:
  - テンプレート作成/更新、ジョブ完了、不具合ステータス変更

## Non-functional (perf, audit, observability)
- Perf
  - 一覧API（物件/ジョブ/不具合）は1リクエスト`p95 <= 300ms`（MVP目標）
  - ページング標準化: `page` / `per_page`（初期20, 最大100）
  - 不具合一覧は`company_id + status + reported_at`の複合indexを前提
- Audit
  - `audit_logs`に「誰が」「いつ」「何を」変更したかをJSON差分で保存
  - 最低保持期間: 1年（MVP運用想定）
- Observability
  - 構造化ログ: `request_id`, `user_id`, `company_id`, `path`, `status`, `duration_ms`
  - エラー監視: 5xx発生率、主要API失敗率、ジョブ完了失敗数
  - ドメインメトリクス: 作成ジョブ数、完了率、不具合件数、平均クローズ日数

### API AC / Test viewpoints (DISCOVERY)
- AC
  - 会社配下データのみ参照可能であること
  - 点検ジョブが`scheduled -> in_progress -> completed`で遷移できること
  - 点検結果入力と不具合報告が同一ジョブに紐づいて保存されること
- テスト観点
  - 認証なし`401`、他社データアクセス`404`
  - 入力バリデーション（必須項目、result_type整合）
  - 一覧APIのページング・フィルタ条件の妥当性
