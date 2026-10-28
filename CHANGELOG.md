# 更新日志

本文件记录 `wist-atlas-stack` 的所有重要变更。格式遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，
版本号遵循[语义化版本](https://semver.org/lang/zh-CN/)。

## [0.1.0] - 2026-10-28

### 新增

- 首个编排版本：compose 组合 `web` + `atlas` + `postgres`。
- `web` 由 nginx 托管前端静态资源，并把 `/api` 反代到 `atlas`；浏览器同域访问。
- `atlas` 启动时自动执行内置 migration；宿主端口默认只绑 `127.0.0.1`。
- `sys/setting/vars.yml` 提供镜像源 / tag / 端口 / 库名默认值，支持 gops 变量链路。
- 新增 `.env.example` 与 `scripts/build-local.sh`，没有 registry 时也能本地起栈。

### 配套

- 后端：`wist-atlas v0.3.0`
- 前端：`wist-atlas-web v0.1.0`
