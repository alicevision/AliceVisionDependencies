#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
. "${CURRDIR}/env.sh"

pushd .

export CERES_VERSION="$1"
export CERES_INSTALL="$2"

export CERES_ROOT="${TRAVIS_BUILD_DIR}/ceres-${CERES_VERSION}"
export CERES_SOURCE="${CERES_ROOT}/source"
export CERES_BUILD="${CERES_ROOT}/build"

downloadEigen

echo "Download Ceres"
mkdir --parent "$CERES_BUILD"
mkdir --parent "$CERES_INSTALL"
cd "$CERES_ROOT"
download_files_from_tar "http://ceres-solver.org/ceres-solver-${CERES_VERSION}.tar.gz" "$CERES_SOURCE"

echo "Build Ceres"

cd "$CERES_BUILD"
cmake \
  -DCMAKE_INSTALL_PREFIX="${CERES_INSTALL}" \
  -DEIGEN_INCLUDE_DIR="${DEPS_INSTALL_DIR}/include/eigen3" \
  -DMINIGLOG=ON \
  $CERES_SOURCE

make -j 2

echo "Install Ceres"
make install


popd
