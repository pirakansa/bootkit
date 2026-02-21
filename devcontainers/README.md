# devcontainers

各言語向けの Dev Container テンプレート集。`curl | bash` でプロジェクトに `.devcontainer/` をセットアップします。

## 使い方

### テンプレートをプロジェクトにコピー

```bash
# カレントディレクトリのプロジェクトに適用
curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/devcontainers/setup.sh | bash -s -- rust

# 指定ディレクトリに適用
curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/devcontainers/setup.sh | bash -s -- go ~/projects/myapp
```

### 利用可能なテンプレート一覧

```bash
curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/devcontainers/setup.sh | bash -s -- --list
```

## テンプレート

| テンプレート | ベースイメージ | 主なツール |
|---|---|---|
| `rust` | `mcr.microsoft.com/devcontainers/rust:1-bookworm` | clippy, rustfmt, rust-analyzer |
| `go` | `mcr.microsoft.com/devcontainers/go:1-bookworm` | gopls, golangci-lint |
| `python` | `mcr.microsoft.com/devcontainers/python:3-bookworm` | ruff, mypy, pytest |

## 構成

各テンプレートは以下のファイルで構成されています：

```
devcontainers/
├── setup.sh              # セットアップスクリプト
├── README.md
├── rust/
│   ├── devcontainer.json
│   └── Dockerfile
├── go/
│   ├── devcontainer.json
│   └── Dockerfile
└── python/
    ├── devcontainer.json
    └── Dockerfile
```

セットアップ後、プロジェクト側には以下が作成されます：

```
your-project/
└── .devcontainer/
    ├── devcontainer.json
    └── Dockerfile
```

## カスタマイズ

コピー後のファイルは自由に編集できます。よくあるカスタマイズ：

- `devcontainer.json` の `extensions` に VS Code 拡張を追加
- `Dockerfile` に追加パッケージやツールを記述
- `postCreateCommand` でプロジェクト固有のセットアップを実行

## テンプレートの追加方法

1. `devcontainers/<template-name>/` ディレクトリを作成
2. `devcontainer.json` と `Dockerfile` を配置
3. `devcontainers/setup.sh` の `TEMPLATES` 配列にテンプレート名を追加
