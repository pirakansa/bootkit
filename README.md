# bootkit

`ppkgmgr` のマニフェストをまとめた、個人用ブートストラップリポジトリです。  
CLI ツール本体の配布マニフェストと、dotfiles などの設定ファイル配布マニフェストを管理しています。

- `ppkgmgr`: https://github.com/pirakansa/ppkgmgr

## 方針

- 利用者向けの導線は `ppkgmgr` を入口に統一します。
- 配布対象はマニフェスト単位で管理し、用途ごとに `manifests/` で分類します。

## クイックスタート

```bash
# 例: Codex CLI をインストール（既存ファイルを上書き）
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/codex.yml

# 例: .gitconfig を配置（既存ファイルを保持）
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/gitconfig.yml
```

## 利用可能なマニフェスト

### CLI ツール（Linux x64）

| ツール | 説明 | マニフェスト |
|---|---|---|
| `codex` | [OpenAI Codex CLI](https://github.com/openai/codex) | `manifests/linux-x64/codex.yml` |
| `copilot-cli` | [GitHub Copilot CLI](https://github.com/github/copilot-cli) | `manifests/linux-x64/copilot-cli.yml` |
| `gh-cli` | [GitHub CLI](https://github.com/cli/cli) | `manifests/linux-x64/gh-cli.yml` |
| `nodejs` | [Node.js](https://nodejs.org/) | `manifests/linux-x64/nodejs.yml` |

### 共通マニフェスト（ppkgmgr）

| ツール | 説明 | マニフェスト |
|---|---|---|
| `gitconfig` | `.gitconfig` テンプレート | `manifests/common/gitconfig.yml` |
| `vimrc` | `.vimrc` テンプレート | `manifests/common/vimrc.yml` |
| `vscode-settings` | VS Code `settings.json` テンプレート | `manifests/common/vscode-settings.yml` |

### Dev Container マニフェスト（ppkgmgr）

| ツール | 説明 | マニフェスト |
|---|---|---|
| `devcontainer-go` | Go 用 `.devcontainer` マニフェスト | `manifests/devcontainers/devcontainer-go.yml` |
| `devcontainer-node` | Node.js 用 `.devcontainer` マニフェスト | `manifests/devcontainers/devcontainer-node.yml` |
| `devcontainer-rust` | Rust 用 `.devcontainer` マニフェスト | `manifests/devcontainers/devcontainer-rust.yml` |

## マニフェスト適用例

```bash
# CLI 系（上書きあり）
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/codex.yml
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/copilot-cli.yml
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/gh-cli.yml
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/nodejs.yml

# 共通マニフェスト（上書きなし）
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/gitconfig.yml
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/vimrc.yml
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/vscode-settings.yml

# Dev Container マニフェスト（.devcontainer に展開）
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/devcontainers/devcontainer-go.yml
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/devcontainers/devcontainer-node.yml
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/devcontainers/devcontainer-rust.yml
```

## Dev Container マニフェスト

`devcontainers/` 以下に、`go` / `node` / `rust` 向けの devcontainer 定義ファイルがあります。  
各マニフェストは、カレントディレクトリの `.devcontainer/` に展開します。  
実行コマンドは「マニフェスト適用例」を参照してください。

## Dev Container Features

`features/` には Dev Container Feature の実装とテストが含まれます。

- `features/src/persistence`: コンテナ再作成時にもユーザー領域データを保持する Feature。
- `features/src/hello`: Feature 開発・テスト用のサンプル Feature。
- `features/test/*`: Feature のテストシナリオ。

`persistence` Feature の利用例:

```json
"features": {
  "ghcr.io/<owner>/<repo>/persistence:1": {
    "claude": true,
    "codex": true,
    "gemini": false,
    "copilot-cli": true,
    "gh-cli": true
  }
}
```

詳細は `features/src/persistence/README.md` を参照してください。

## ディレクトリ構成

```text
bootkit/
├── assets/                  # 設定ファイル実体
├── manifests/
│   ├── linux-x64/           # Linux x64 向けマニフェスト
│   ├── common/              # 共通設定ファイル向けマニフェスト
│   └── devcontainers/       # Dev Container 向けマニフェスト
├── devcontainers/
│   ├── go/                  # Go 開発向け devcontainer 定義ファイル
│   ├── node/                # Node.js 開発向け devcontainer 定義ファイル
│   └── rust/                # Rust 開発向け devcontainer 定義ファイル
├── features/                # Dev Container Features 実装とテスト
└── .github/workflows/       # validate / test / release
```

## 新しいマニフェストを追加する

1. `manifests/linux-x64/<tool>.yml`（バイナリ）または `manifests/common/<tool>.yml`（設定）を追加する。
2. 必要に応じて `assets/` に実ファイルを追加する。
3. この `README.md` の一覧と適用例を更新する。
