BUILD フェーズ開始用（Integratorが使う）
事前条件: `docs/approval.md` が approved

1) `scripts/bootstrap.sh` を必要に応じて実行（backend/frontendの初期生成）
2) `docs/task_breakdown.md` のM0〜M1を実装に落とし、PRを小さく切る
3) backend: API + test + minimal auth (必要なら)
4) frontend: 画面骨格 + API疎通 + error handling
5) 変更ごとに `articles/runlog/` へ差分とプロンプト要約を残す
