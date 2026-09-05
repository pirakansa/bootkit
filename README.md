# bootkit

`vorbere` で利用するマニフェストをまとめた、個人用ブートストラップリポジトリです。  
CLI ツール本体の配布マニフェストと、dotfiles などの設定ファイル配布マニフェストを管理しています。

- `vorbere`: https://github.com/pirakansa/Vorbere

## 方針

- 利用者向けの導線は `vorbere` を入口に統一します。
- 配布対象はマニフェスト単位で管理し、用途ごとに `manifests/` で分類します。

## クイックスタート

```bash
# 例: .gitconfig を配置（既存ファイルを保持）
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/gitconfig.yml sync
```

## 利用可能なマニフェスト

### CLI ツール（Linux x64）

| ツール | 説明 | マニフェスト |
|---|---|---|
| `gh-cli` | [GitHub CLI](https://github.com/cli/cli) | `manifests/linux-x64/gh-cli.yml` |
| `mani` | [mani](https://github.com/alajmo/mani) | `manifests/linux-x64/mani.yml` |
| `nodejs` | [Node.js](https://nodejs.org/) | `manifests/linux-x64/nodejs.yml` |
| `opencode` | [OpenCode](https://github.com/anomalyco/opencode) | `manifests/linux-x64/opencode.yml` |

### 共通マニフェスト（vorbere）

| ツール | 説明 | マニフェスト |
|---|---|---|
| `gitconfig` | `.gitconfig` テンプレート | `manifests/common/gitconfig.yml` |
| `vimrc` | `.vimrc` テンプレート | `manifests/common/vimrc.yml` |
| `vscode-settings` | VS Code `settings.json` テンプレート | `manifests/common/vscode-settings.yml` |

### Dev Container マニフェスト（vorbere）

| ツール | 説明 | マニフェスト |
|---|---|---|
| `devcontainer-go` | Go 用 `.devcontainer` マニフェスト | `manifests/devcontainers/devcontainer-go.yml` |
| `devcontainer-node` | Node.js 用 `.devcontainer` マニフェスト | `manifests/devcontainers/devcontainer-node.yml` |
| `devcontainer-python` | Python 用 `.devcontainer` マニフェスト | `manifests/devcontainers/devcontainer-python.yml` |
| `devcontainer-rust` | Rust 用 `.devcontainer` マニフェスト | `manifests/devcontainers/devcontainer-rust.yml` |
| `devcontainer-gcc` | GCC 用 `.devcontainer` マニフェスト | `manifests/devcontainers/devcontainer-gcc.yml` |
| `devcontainer-ubuntu` | Ubuntu 用 `.devcontainer` マニフェスト | `manifests/devcontainers/devcontainer-ubuntu.yml` |

## マニフェスト適用例

```bash
# CLI 系（上書きあり）
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/gh-cli.yml sync --overwrite
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/mani.yml sync --overwrite
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/nodejs.yml sync --overwrite
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/opencode.yml sync --overwrite

# 共通マニフェスト（上書きなし）
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/gitconfig.yml sync
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/vimrc.yml sync
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/vscode-settings.yml sync

# Dev Container マニフェスト（.devcontainer に展開）
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/devcontainers/devcontainer-go.yml sync --overwrite
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/devcontainers/devcontainer-node.yml sync --overwrite
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/devcontainers/devcontainer-python.yml sync --overwrite
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/devcontainers/devcontainer-rust.yml sync --overwrite
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/devcontainers/devcontainer-gcc.yml sync --overwrite
vorbere --config https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/devcontainers/devcontainer-ubuntu.yml sync --overwrite
```

## Dev Container マニフェスト

`devcontainers/` 以下に、`gcc` / `go` / `node` / `python` / `rust` / `ubuntu` 向けの devcontainer 定義ファイルがあります。  
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

全体構成とテスト方法は `features/README.md` を参照してください。  
詳細は `features/src/persistence/README.md` を参照してください。

## ディレクトリ構成

```text
bootkit/
├── assets/                  # 設定ファイル実体
├── manifests/
│   ├── linux-x64/           # Linux x64 向けマニフェスト
│   ├── common/              # 共通設定ファイル向けマニフェスト
│   └── devcontainers/       # Dev Container 向けマニフェスト
├── agents/                  # エージェント設定・スキル定義
├── devcontainers/
│   ├── gcc/                 # GCC 開発向け devcontainer 定義ファイル
│   ├── go/                  # Go 開発向け devcontainer 定義ファイル
│   ├── node/                # Node.js 開発向け devcontainer 定義ファイル
│   ├── python/              # Python 開発向け devcontainer 定義ファイル
│   ├── rust/                # Rust 開発向け devcontainer 定義ファイル
│   └── ubuntu/              # Ubuntu 汎用 devcontainer 定義ファイル
├── features/                # Dev Container Features 実装とテスト
└── .github/workflows/       # validate / test / release
```

## 新しいマニフェストを追加する

1. `manifests/linux-x64/<tool>.yml`（バイナリ）または `manifests/common/<tool>.yml`（設定）を追加する。
2. 必要に応じて `assets/` に実ファイルを追加する。
3. この `README.md` の一覧と適用例を更新する。
