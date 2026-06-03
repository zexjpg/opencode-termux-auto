# opencode-termux-auto

Auto-build [OpenCode](https://github.com/anomalyco/opencode) for Termux.

## How it works

A GitHub Actions workflow runs daily (06:00 UTC) and checks npm for a new version of `opencode-linux-arm64`. If found, it:

1. Downloads the binary from npm
2. Wraps it with [bun-termux-loader](https://github.com/Hope2333/bun-termux-loader) for Android/Termux compatibility
3. Packages as `.deb` and `.pkg.tar.xz`
4. Publishes to [GitHub Releases](https://github.com/zexjpg/opencode-termux-auto/releases)

## Manual Trigger

Go to Actions → "Auto-build OpenCode for Termux" → "Run workflow" → optionally specify a version.

## Install on Termux

```bash
# Install dependencies
apt install -y glibc-repo
apt update
apt install -y glibc openssl-glibc

# Download latest .deb from Releases and install
apt install /path/to/opencode_<version>_aarch64.deb
```

## Credits

- [anomalyco/opencode](https://github.com/anomalyco/opencode) — upstream project
- [Hope2333/opencode-termux](https://github.com/Hope2333/opencode-termux) — original Termux port
- [Hope2333/bun-termux-loader](https://github.com/Hope2333/bun-termux-loader) — binary loader for Android