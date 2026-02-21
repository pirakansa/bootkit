# bootkit

個人用ツールインストーラー。`ppkgmgr` + マニフェストで各種 CLI ツールをセットアップします。

- `ppkgmgr`: https://github.com/pirakansa/ppkgmgr

## 使い方

### マニフェストを直接指定してインストール

```bash
# codex (上書きあり)
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/codex.yml

# copilot-cli (上書きあり)
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/copilot-cli.yml

# nodejs (上書きあり)
ppkgmgr dl --overwrite https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/nodejs.yml

# gitconfig (上書きなし)
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/gitconfig.yml

# vimrc (上書きなし)
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/vimrc.yml

# vscode-settings (上書きなし)
ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/common/vscode-settings.yml
```

## 利用可能なツール

| ツール | 説明 | マニフェスト |
|---|---|---|
| `codex` | [OpenAI Codex CLI](https://github.com/openai/codex) | `manifests/linux-x64/codex.yml` |
| `copilot-cli` | [GitHub Copilot CLI](https://github.com/github/copilot-cli) | `manifests/linux-x64/copilot-cli.yml` |
| `nodejs` | [Node.js](https://nodejs.org/) | `manifests/linux-x64/nodejs.yml` |
| `gitconfig` | `.gitconfig` テンプレート | `manifests/common/gitconfig.yml` |
| `vimrc` | `.vimrc` テンプレート | `manifests/common/vimrc.yml` |
| `vscode-settings` | VS Code `settings.json` テンプレート | `manifests/common/vscode-settings.yml` |

## ディレクトリ構成

```
bootkit/
├── assets/               # 設定ファイル実体
│   ├── gitconfig
│   ├── vimrc
│   └── vscode-settings.json
├── manifests/
│   ├── linux-x64/        # Linux x64 バイナリ用マニフェスト
│   └── common/           # 設定ファイル用マニフェスト
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
./devcontainers/setup.sh rust

# テンプレート一覧
./devcontainers/setup.sh --list
```

詳細は [devcontainers/README.md](devcontainers/README.md) を参照。

## ツールの追加方法

1. `manifests/linux-x64/<tool>.yml`（バイナリ）または `manifests/common/<tool>.yml`（設定）を作成
2. 必要なら `assets/` に設定ファイル実体を追加
3. README の「マニフェストを直接指定してインストール」にコマンド例を追加