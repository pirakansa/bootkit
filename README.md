# bootkit

個人用ツールインストーラー。`curl | bash` で各種 CLI ツールをセットアップします。

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

### ツール単体で直接インストール

```bash
curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/tools/codex/install.sh | bash
```

## 利用可能なツール

| ツール | 説明 | バージョン指定 |
|---|---|---|
| `codex` | [OpenAI Codex CLI](https://github.com/openai/codex) | `CODEX_VERSION=rust-v0.104.0` |
| `copilot-cli` | [GitHub Copilot CLI](https://github.com/github/copilot-cli) | `COPILOT_CLI_VERSION=v0.0.412` |
| `nodejs` | [Node.js](https://nodejs.org/) | `NODE_VERSION=v24.13.1` |

## オプション

| 環境変数 | 説明 | デフォルト |
|---|---|---|
| `BOOTKIT_INSTALL_DIR` | インストール先ディレクトリ | `~/.local/bin` |
| `BOOTKIT_LIB_DIR` | ライブラリ配置先 (nodejs等) | `~/.local/lib` |
| `BOOTKIT_PROXY` | curl で使用するプロキシ URL | |
| `BOOTKIT_INSECURE` | `1` で証明書検証をスキップ | |

例：インストール先を変更する場合

```bash
BOOTKIT_INSTALL_DIR=/usr/local/bin curl -fsSL .../install.sh | bash -s -- codex
```

## ディレクトリ構成

```
bootkit/
├── install.sh            # メインディスパッチャー
├── lib/
│   └── common.sh         # 共通関数（OS/arch検出、色出力など）
├── tools/
│   └── codex/
│       └── install.sh    # codex インストーラー
├── README.md
└── LICENSE
```

## ツールの追加方法

1. `tools/<tool-name>/install.sh` を作成
2. スクリプト内で `lib/common.sh` を source（テンプレートは `tools/codex/install.sh` を参照）
3. メインの `install.sh` の `TOOLS` 配列にツール名を追加

## アンインストール

```bash
rm ~/.local/bin/<tool-name>
```