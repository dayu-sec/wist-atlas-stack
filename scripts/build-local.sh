#!/usr/bin/env sh
# 从同级代码仓构建 dev 镜像，供没有 registry 的本地编排使用。
set -eu

ATLAS_REPO="${ATLAS_REPO:-../wist-atlas}"
WEB_REPO="${WEB_REPO:-../wist-atlas-web}"
REGISTRY="${ATLAS_REGISTRY:-ghcr.io/dayu-sec}"

docker build -t "${REGISTRY}/wist-atlas:dev" "${ATLAS_REPO}"
docker build -t "${REGISTRY}/wist-atlas-web:dev" "${WEB_REPO}"

echo "built: ${REGISTRY}/wist-atlas:dev"
echo "built: ${REGISTRY}/wist-atlas-web:dev"
echo "set ATLAS_IMAGE_TAG=dev and ATLAS_WEB_IMAGE_TAG=dev in .env"
