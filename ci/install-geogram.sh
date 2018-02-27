#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
. "${CURRDIR}/env.sh"

pushd .

export GEOGRAM_VERSION="$1"
export GEOGRAM_INSTALL="$2"

export GEOGRAM_ROOT="${TRAVIS_BUILD_DIR}/geogram-${GEOGRAM_VERSION}"
export GEOGRAM_SOURCE="${GEOGRAM_ROOT}/source"
export GEOGRAM_BUILD="${GEOGRAM_ROOT}/build"

echo "Download Geogram"
mkdir --parent "$GEOGRAM_BUILD"
mkdir --parent "$GEOGRAM_INSTALL"
git clone --depth 1 --branch "v${GEOGRAM_VERSION}" https://github.com/alicevision/geogram.git "${GEOGRAM_SOURCE}"

echo "Build Geogram"
cd $GEOGRAM_BUILD
cmake                                        \
  -DCMAKE_BUILD_TYPE=Release                 \
  -DCMAKE_INSTALL_PREFIX="$GEOGRAM_INSTALL"  \
  -DGEOGRAM_WITH_TETGEN=OFF                  \
  -DGEOGRAM_WITH_HLBFGS=OFF                  \
  -DGEOGRAM_WITH_GRAPHICS=OFF                \
  -DGEOGRAM_WITH_EXPLORAGRAM=OFF             \
  -DGEOGRAM_WITH_LUA=OFF                     \
  -DVORPALINE_PLATFORM="Linux64-gcc-dynamic" \
  "$GEOGRAM_SOURCE"

make -j 2

echo "Install Geogram"
make install

popd
