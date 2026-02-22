
# Persistence (persistence)

Persist userland data across dev containers by mounting host-side volumes.

## Example Usage

```json
"features": {
    "ghcr.io/<owner>/<repo>/persistence:1": {
        "claude": true,
        "codex": true,
        "gemini": false,
        "copilot-cli": true
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| claude | Mount Claude Code config (`~/.claude`) via volume. | boolean | false |
| codex | Mount Codex config (`~/.codex`) via volume. | boolean | false |
| gemini | Mount Gemini Code Assist config and cache directories via volumes. | boolean | false |
| copilot-cli | Mount GitHub Copilot CLI config (`~/.config/copilot`) via volume. | boolean | false |



---

_Note: Keep this README in sync with `devcontainer-feature.json`._