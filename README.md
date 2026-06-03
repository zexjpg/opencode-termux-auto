# opencode-termux-auto

Auto-build [OpenCode](https://github.com/anomalyco/opencode) for Termux.

Checks npm daily for new \opencode-linux-arm64\ versions, downloads the pre-built binary, wraps it with bun-termux-loader for Android/Termux, and publishes .deb/.pkg.tar.xz packages to Releases.

## Quick Install

`ash
curl -fsSL https://raw.githubusercontent.com/zexjpg/opencode-termux-auto/main/install-opencode.sh | bash
`

Install a specific version:

`ash
curl -fsSL https://raw.githubusercontent.com/zexjpg/opencode-termux-auto/main/install-opencode.sh | bash -s -- 1.15.13
`

The script will:
1. Install glibc / openssl-glibc dependencies
2. Download the latest .deb from GitHub Releases
3. Install via dpkg

## Manual Install

Download from [Releases](https://github.com/zexjpg/opencode-termux-auto/releases).

`ash
# Dependencies
apt install -y glibc-repo
apt update
apt install -y glibc openssl-glibc

# Install deb
apt install /path/to/opencode_<version>_aarch64.deb
`

## Usage

`ash
opencode --version
opencode run "hello"
opencode run --mode=dev .
opencode serve
opencode web
`

## How it works

\\\
anomalyco/opencode (npm)
  -> opencode-linux-arm64 (pre-built binary)
    -> bun-termux-loader (Bionic wrapper)
      -> .deb / .pkg.tar.xz -> GitHub Release
\\\

## Credits

- [anomalyco/opencode](https://github.com/anomalyco/opencode) - upstream
- [Hope2333/opencode-termux](https://github.com/Hope2333/opencode-termux) - original Termux port
- [Hope2333/bun-termux-loader](https://github.com/Hope2333/bun-termux-loader) - Android loader