# /osa - Claude Code Skills

Claude Code 向けのデザイン改善スキルパック。
`/osa` コマンドで起動し、フロントエンドのコードレベルでデザインを改善する。

## 概要

既存のフロントエンドコード（Nuxt 4 + TypeScript + Tailwind CSS）を読み取り、ターゲットデザインとの差分を分析してリデザイン・リファインを行うスキル群。

**主な機能:**

- 既存コードや repomix 出力からデザイントークンを自動抽出
- ターゲットデザインとの差分分析
- Replace（大胆なリデザイン）/ Refine（タクソノミー整理）の 2 モード
- カラー、タイポグラフィ、レイアウト、アニメーション等を体系的に改善

## インストール

```bash
curl -fsSL https://osa.xyz/claudecode-skills/install.sh | bash
```

インストール先を選択:

1. リポジトリ直下（`.claude/commands/`）
2. ユーザーホーム（`~/.claude/commands/`）

## 使い方

Claude Code 内で以下のコマンドを実行:

```
/osa
```

起動後のフロー:

1. **デザイン対象の選択** — 現在は Frontend Design のみ対応
2. **モード選択** — Replace または Refine
3. **ターゲットデザインの決定** — プロジェクト走査 / repomix 参照 / 手動指定
4. **対象ファイルの指定**
5. **差分分析と改善の実行**

## スキル構成

```
.claude/commands/
    osa.md               # エントリポイント（/osa で起動）
    skills/
        frontend-design.md      # フロントエンドデザインモジュール
        design-principles.md    # デザイン原則
        coding-conventions.md   # コーディング規約
```

| スキル | 役割 |
|--------|------|
| `osa.md` | エントリポイント。アップデートチェック後、対象モジュールを読み込む |
| `frontend-design.md` | デザイントークン抽出、差分分析、コード改善の実行フロー |
| `design-principles.md` | 余白・リズム、レスポンシブ、アニメーション等のデザイン原則 |
| `coding-conventions.md` | 命名規則、ディレクトリ構成、コード品質のルール |

## デザイン原則

- **情報設計が最優先** — 装飾ではなく余白とタイポグラフィで達成する
- **ジャンプ率の調整** — 情報の重要度に応じたサイズ・ウェイトの差
- **CSS Grid + 自然な折り返し** — メディアクエリを極力減らす
- **`--gutter` による余白の一括管理**
- **楽観的 UI** — 操作結果を即座に反映

## 技術スタック（対象プロジェクト）

- Nuxt 4.2.2 + TypeScript
- Tailwind CSS
- Vue Single File Component
- コンポーネントライブラリ不使用