# Frontend design

## Routes
- `/` : ダッシュボード（今日の点検予定、未対応不具合、直近報告）
- `/companies/new` : 会社登録（MVPは単一会社の作成を想定）
- `/properties` : 物件一覧
- `/properties/:propertyId` : 物件詳細（店舗・スペース・資産のサマリ）
- `/tasks` : 業務（点検）一覧
- `/tasks/new` : 業務作成（対象: 物件/スペース、テンプレート選択）
- `/tasks/:taskId/execute` : 業務実施画面（大項目/項目の良否・数値入力）
- `/issues/new` : 不具合報告作成（業務実施中から遷移可）
- `/issues` : 不具合一覧

## State management
- Nuxt標準 + `useState` / composable中心で開始し、グローバル状態は最小化する。
- グローバルで保持する状態:
  - 認証コンテキスト（MVPはダミーユーザー）
  - 現在選択中の会社ID/物件ID
  - 通知トーストキュー
- 画面固有のフォーム状態はページコンポーネント内で閉じる。
- サーバーデータはAPIクライアント経由で取得し、必要に応じて `useAsyncData` を利用してSSR/CSRの整合を取る。

## API client strategy
- `~/lib/api/client.ts` に共通fetchラッパーを設置し、全API呼び出しを集約する。
- 責務:
  - Base URL と共通ヘッダーの付与
  - タイムアウト/リトライ（GETのみ）制御
  - HTTPエラーの標準化（`ApiError` へ変換）
- APIモジュールを機能単位で分割:
  - `~/lib/api/companies.ts`
  - `~/lib/api/properties.ts`
  - `~/lib/api/tasks.ts`
  - `~/lib/api/issues.ts`
- 型はOpenAPI確定前のため暫定で手書きTypeScript型を `~/types/api.ts` に集約し、API仕様確定後に生成型へ移行する。

## Error handling
- 表示方針:
  - 4xx: ユーザー修正可能エラーとしてフォーム近傍に表示
  - 5xx/ネットワーク: 画面上部バナー + 再試行導線を表示
- 画面遷移不能な致命エラーは Nuxt error boundary でフォールバック表示。
- APIエラーコードと日本語メッセージのマッピング表を `docs/api.md` と整合させる。
- 不具合報告や業務実施の保存失敗時は、入力値を保持して再送可能にする。

## Testing
- 単体テスト:
  - composable（状態遷移、入力バリデーション）
  - API client（エラー変換、リトライ、タイムアウト）
- コンポーネントテスト:
  - 業務実施フォーム（大項目/項目入力、必須チェック）
  - 不具合報告フォーム（入力/送信/失敗時保持）
- E2E（MVP必須シナリオ）:
  - 会社登録 -> 物件登録 -> 業務作成 -> 業務実施 -> 不具合報告
- テスト観点（AC紐付け）:
  - 主要導線がPC/スマホで操作可能
  - エラー時にユーザーが復帰できる（再試行/入力保持）
  - API失敗時に適切なメッセージが表示される
