# bootkit

`ppkgmgr` のマニフェストをまとめた、個人用ブートストラップリポジトリです。  
CLI ツール本体の配布マニフェストと、dotfiles などの設定ファイル配布マニフェストを管理しています。

- `ppkgmgr`: https://github.com/pirakansa/ppkgmgr

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

### 設定ファイル（共通）

| ツール | 説明 | マニフェスト |
|---|---|---|
| `gitconfig` | `.gitconfig` テンプレート | `manifests/common/gitconfig.yml` |
| `vimrc` | `.vimrc` テンプレート | `manifests/common/vimrc.yml` |
| `vscode-settings` | VS Code `settings.json` テンプレート | `manifests/common/vscode-settings.yml` |
| `devcontainer-go` | Go 用 `.devcontainer` テンプレート | `manifests/common/devcontainer-go.yml` |
| `devcontainer-node` | Node.js 用 `.devcontainer` テンプレート | `manifests/common/devcontainer-node.yml` |
| `devcontainer-rust` | Rust 用 `.devcontainer` テンプレート | `manifests/common/devcontainer-rust.yml` |

## マニフェスト適用例

```bash
# CLI 系（上書きあり）
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/codex.yml
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/copilot-cli.yml
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/gh-cli.yml
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/nodejs.yml

# 設定ファイル系（上書きなし）
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/gitconfig.yml
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/vimrc.yml
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/vscode-settings.yml

# Dev Container テンプレート（カレントディレクトリの .devcontainer/ に展開）
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/devcontainer-go.yml
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/devcontainer-node.yml
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/devcontainer-rust.yml
```

## Dev Container テンプレート

`devcontainers/` 以下に、`golang` / `node` / `rust` 向けテンプレートがあります。

`ppkgmgr` で適用する場合（カレントディレクトリの `.devcontainer/` に展開）:

```bash
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/devcontainer-go.yml
```

## ディレクトリ構成

```text
bootkit/
├── assets/                  # 設定ファイル実体
├── manifests/
│   ├── linux-x64/           # Linux x64 向けマニフェスト
│   └── common/              # 共通設定ファイル向けマニフェスト
├── devcontainers/
│   ├── golang/              # Go 開発向け devcontainer テンプレート
│   ├── node/                # Node.js 開発向け devcontainer テンプレート
│   └── rust/                # Rust 開発向け devcontainer テンプレート
├── features/                # Dev Container Features 本体とテスト
└── .github/workflows/       # validate / test / release
```

## 新しいマニフェストを追加する

1. `manifests/linux-x64/<tool>.yml`（バイナリ）または `manifests/common/<tool>.yml`（設定）を追加する。
2. 必要に応じて `assets/` に実ファイルを追加する。
3. この `README.md` の一覧と適用例を更新する。
