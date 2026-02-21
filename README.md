# bootkit

個人用ツールインストーラー。`curl | bash` で各種 CLI ツールをセットアップします。

実体のインストールは `ppkgmgr` + マニフェストで実行します（Linux x64 専用）。

## 使い方

### 特定のツールをインストール

```bash
curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/install.sh | bash -s -- codex
```

### 全ツールを一括インストール

```bash
curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/install.sh | bash -s -- --all
```

### 利用可能なツール一覧

```bash
curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/install.sh | bash -s -- --list
```

### マニフェストを直接指定してインストール

```bash
# codex (上書きあり)
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/codex.yml

# copilot-cli (上書きあり)
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/copilot-cli.yml

# nodejs (上書きあり)
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/nodejs.yml

# gitconfig (上書きなし)
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/gitconfig.yml

# vimrc (上書きなし)
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/vimrc.yml

# vscode-settings (上書きなし)
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/vscode-settings.yml

# 全バイナリ (上書きあり)
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/all-binaries.yml

# 全設定ファイル (上書きなし)
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/all-assets.yml
```

## 利用可能なツール

| ツール | 説明 | マニフェスト |
|---|---|---|
| `codex` | [OpenAI Codex CLI](https://github.com/openai/codex) | `manifests/linux-x64/codex.yml` |
| `copilot-cli` | [GitHub Copilot CLI](https://github.com/github/copilot-cli) | `manifests/linux-x64/copilot-cli.yml` |
| `nodejs` | [Node.js](https://nodejs.org/) | `manifests/linux-x64/nodejs.yml` |
| `gitconfig` | `.gitconfig` テンプレート | `manifests/linux-x64/gitconfig.yml` |
| `vimrc` | `.vimrc` テンプレート | `manifests/linux-x64/vimrc.yml` |
| `vscode-settings` | VS Code `settings.json` テンプレート | `manifests/linux-x64/vscode-settings.yml` |

> 対象プラットフォームは **Linux x64** のみです。
>
> `gitconfig` / `vimrc` / `vscode-settings` は `assets/` 配下の設定ファイルとして扱い、既存ファイルを上書きしません。

## オプション

| 環境変数 | 説明 | デフォルト |
|---|---|---|
| `BOOTKIT_INSTALL_DIR` | インストール先ディレクトリ | `~/.local/bin` |
| `BOOTKIT_LIB_DIR` | ライブラリ配置先 (nodejs等) | `~/.local/lib` |

前提コマンド:

- `ppkgmgr`

例：インストール先を変更する場合

```bash
BOOTKIT_INSTALL_DIR=/usr/local/bin curl -fsSL .../install.sh | bash -s -- codex
```

## ディレクトリ構成

```
bootkit/
├── install.sh            # メインディスパッチャー
├── assets/               # 設定ファイル実体
│   ├── gitconfig
│   ├── vimrc
│   └── vscode-settings.json
├── manifests/
│   └── linux-x64/        # ppkgmgr マニフェスト群
├── tools/
│   ├── codex/
│   ├── copilot-cli/
│   ├── gitconfig/
│   ├── nodejs/
│   ├── vimrc/
│   └── vscode-settings/
├── devcontainers/
│   ├── setup.sh          # devcontainer セットアップスクリプト
│   ├── rust/             # Rust テンプレート
│   ├── go/               # Go テンプレート
│   └── python/           # Python テンプレート
├── README.md
└── LICENSE
```

## Dev Container テンプレート

各言語向けの devcontainer 設定をプロジェクトにコピーできます。

```bash
# Rust テンプレートをカレントディレクトリに適用
curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/devcontainers/setup.sh | bash -s -- rust

# テンプレート一覧
curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/devcontainers/setup.sh | bash -s -- --list
```

詳細は [devcontainers/README.md](devcontainers/README.md) を参照。

## ツールの追加方法

1. `manifests/linux-x64/<tool>.yml` を作成
2. 必要なら `assets/` に設定ファイル実体を追加
3. `install.sh` の `TOOLS` 配列と `manifest_url_for_tool()` にツール名を追加
4. `manifests/linux-x64/all-binaries.yml` または `manifests/linux-x64/all-assets.yml` に追加

## アンインストール

```bash
rm ~/.local/bin/<tool-name>
```