# wist-atlas-stack

`wist-atlas`（资产与运行拓扑服务）+ `wist-atlas-web`（可视化前端）+ PostgreSQL 的一站式编排。

本仓**只做编排**：后端与前端镜像分别来自：

- [`wist-atlas`](https://github.com/dayu-sec/wist-atlas) 的 release 流水线
- [`wist-atlas-web`](https://github.com/dayu-sec/wist-atlas-web) 的 release 流水线

## 组件

| 服务 | 作用 | 端口（宿主:容器） | 镜像 |
|---|---|---|---|
| `web` | 前端入口：nginx 静态托管 + `/api` 反代 | `${WEB_BIND_IP}:${WEB_HOST_PORT}:80` | `${ATLAS_REGISTRY}/wist-atlas-web:${ATLAS_WEB_IMAGE_TAG}` |
| `atlas` | 资产与拓扑 API（axum） | `${ATLAS_BIND_IP}:${ATLAS_HOST_PORT}:8080` | `${ATLAS_REGISTRY}/wist-atlas:${ATLAS_IMAGE_TAG}` |
| `postgres` | 主存储 | `${PG_BIND_IP}:${PG_HOST_PORT}:5432` | `${PG_REGISTRY}/postgres:${PG_IMAGE_TAG}` |

浏览器只访问 `web`；`web` 把 `/api` 反代到 `atlas`，两者同域，不存在 CORS。
`atlas` 启动时自动执行内置 migration，空库可直接拉起。

> `atlas` 与 `web` 默认只绑 `127.0.0.1`。需要局域网访问时，把 `WEB_BIND_IP` 改成
> `0.0.0.0`，并自行在前面加 TLS / 鉴权——当前 atlas API 与 UI 都还没有登录态。

## 快速开始（gops）

```bash
gops sys update      # sys/setting/vars.yml -> sys/merged_vars.yml
gops sys localize    # 生成栈根 .env
gops run start       # 拉起 postgres / atlas / web
```

现场覆盖值写 ops-prj 的 `values/<系统名>/sys_value.yml`，不要改 `sys/setting/vars.yml`。

## 快速开始（docker compose）

```bash
cp .env.example .env
docker compose -f sys/docker-compose.yml --env-file .env up -d
```

入口：<http://127.0.0.1:8080>（默认 `WEB_BIND_IP=127.0.0.1`、`WEB_HOST_PORT=8080`）。

## 本地构建镜像

没有 registry 时，用同级代码仓直接构建：

```bash
./scripts/build-local.sh
# 然后在 .env 里把两个 tag 改成 dev
# ATLAS_IMAGE_TAG=dev
# ATLAS_WEB_IMAGE_TAG=dev
docker compose -f sys/docker-compose.yml --env-file .env up -d
```

脚本默认读取 `../wist-atlas` 与 `../wist-atlas-web`，可用 `ATLAS_REPO` / `WEB_REPO` 覆盖。

## 变量与密钥

- `sys/setting/vars.yml`：产品默认值（镜像源、tag、端口、库名）。
- `.env`：`gops sys localize` 生成，或由 `.env.example` 复制而来。
- 密钥：当前只有 PostgreSQL 密码。默认值仅用于本地；现场应改 `PG_PASSWORD`，
  或改用 `${SEC_ATLAS_PG_PASSWORD}` 由 `gops run start` 注入。

## 目录

```text
wist-atlas-stack/
  sys-prj.yml               # gops 项目描述（ignore / protect）
  sys/
    docker-compose.yml      # 编排定义
    sys_model.yml           # kind: docker-compose
    setting/vars.yml        # 系统变量默认值
  scripts/
    build-local.sh          # 从同级代码仓构建 dev 镜像
  .env.example              # 手工 compose 使用的默认变量
```
