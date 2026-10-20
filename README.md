# homebrew-hivemind

Homebrew tap for [hivemind](https://github.com/akhil-gautam/hivemind) — run CLI
agents on several Macs over the home WiFi and drive them from one browser page.

```sh
brew tap akhil-gautam/hivemind
brew install hivemind
```

The tap is private, so Homebrew needs a GitHub token with `repo` scope:

```sh
export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)
```
