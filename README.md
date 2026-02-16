# Codex Org Template (PO/Design/BE/FE/Integrator/Research)

このリポジトリは **「作りたいものを軽く提示 → 仮説/調査/設計 → 承認(OK) → 実装」** を
Codex の **役割別スレッド**（PO / Design / BE / FE / Integrator / Research）で回すためのテンプレです。

## 使い方（最短）
1. このリポジトリを **Template / Fork** して自分のプロジェクトにする
2. `docs/idea.md` に「作りたいもの」「想定ユーザー」「欲しい機能（箇条書きでOK）」を書く
3. Codex（App推奨）でこのリポジトリを開き、**Worktree** で以下の 6 スレッドを作る
   - PO / Design / BE / FE / Integrator / Research
4. 各スレッドで `codex/prompts/<role>.md` をそのまま貼って実行
5. Integrator が作る `docs/approval.md` の `status: pending` を確認
   - 問題なければ、チャットで **OK** と返す（または `status: approved` に変更してコミット）
6. Integrator が **BUILD フェーズ**に切り替えて、BE/FEが実装を開始

## ディレクトリ
- `docs/` : SSOT（仕様/設計/意思決定/タスク分解）
- `backend/` : Rails API（初期は空。必要なら bootstrap で生成）
- `frontend/` : Nuxt（初期は空。必要なら bootstrap で生成）
- `articles/` : 記事原稿と runlog（プロンプトを含めて再現可能に）
- `codex/` : 役割別プロンプトと運用ランブック
- `.codex/` : Codex のプロジェクト設定（任意）

## bootstrap（任意）
初期の Rails/Nuxt を自動生成したい場合:
```bash
./scripts/bootstrap.sh
```

> 前提: Ruby/Rails と Node がローカルに入っていること

## 参考
- `AGENTS.md` は Codex が自動で読む「プロジェクト指示書」です。

## CI / Gate
- PR作成時、`docs/approval.md` が `approved` でない状態で `backend/` または `frontend/` を変更するとCIが落ちます。
- `main` への直接push禁止は GitHub の Branch protection で設定してください（運用ルール）。

## 注意
README.md含めてこれはすべてAIが記載しています。
