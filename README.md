# opencode-termux-auto

Auto-build [OpenCode](https://github.com/anomalyco/opencode) for Termux.

每 24 小时自动检测 [anomalyco/opencode](https://github.com/anomalyco/opencode) 新版本，下载预编译二进制，包装为 Termux 兼容的 .deb 和 .pkg.tar.xz 包，发布到 Releases。

## 一键安装

`ash
curl -fsSL https://raw.githubusercontent.com/zexjpg/opencode-termux-auto/main/install-opencode.sh | bash
`

安装指定版本：

`ash
curl -fsSL https://raw.githubusercontent.com/zexjpg/opencode-termux-auto/main/install-opencode.sh | bash -s -- 1.15.13
`

脚本会自动：
1. 安装 glibc / openssl-glibc 依赖
2. 从 GitHub Releases 下载最新 .deb
3. 通过 dpkg 安装

## 从 Releases 手动安装

下载地址：[Releases](https://github.com/zexjpg/opencode-termux-auto/releases)

`ash
# 安装依赖
apt install -y glibc-repo
apt update
apt install -y glibc openssl-glibc

# 安装 deb
apt install /path/to/opencode_<version>_aarch64.deb

# 或 pacman
pacman -U /path/to/opencode-<version>-aarch64.pkg.tar.xz
`

## 使用

`ash
opencode --version
opencode run "hello"
opencode run --mode=dev .
opencode serve
opencode web
`

## 国内加速

脚本默认通过 \gh-proxy.com\ 镜像加速下载，如果直连速度更快，设置环境变量：

`ash
NO_MIRROR=1 curl -fsSL ... | bash
`

## 原理

`
anomalyco/opencode (npm)
  → opencode-linux-arm64 预编译二进制
    → bun-termux-loader 包装为 Bionic 兼容
      → deb/pacman 打包 → GitHub Release
`

## Credits

- [anomalyco/opencode](https://github.com/anomalyco/opencode) — upstream
- [Hope2333/opencode-termux](https://github.com/Hope2333/opencode-termux) — 原始 Termux 移植
- [Hope2333/bun-termux-loader](https://github.com/Hope2333/bun-termux-loader) — Android 兼容层