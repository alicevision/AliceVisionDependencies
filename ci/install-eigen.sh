#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
. "${CURRDIR}/env.sh"

pushd .

export EIGEN_VERSION=$1
export EIGEN_INSTALL=$2

export EIGEN_ROOT="${TRAVIS_BUILD_DIR}/eigen-${EIGEN_VERSION}"
export EIGEN_BUILD="${EIGEN_ROOT}/build"


echo "Download Eigen"
mkdir --parent "$EIGEN_ROOT"
hg clone -r "${EIGEN_VERSION}" https://bitbucket.org/eigen/eigen/ "$EIGEN_ROOT"
mkdir --parent "${EIGEN_BUILD}"

echo "Build Eigen"
cd "${EIGEN_BUILD}"
cmake -DCMAKE_INSTALL_PREFIX="${EIGEN_INSTALL}" "${EIGEN_ROOT}"

make -j 2

echo "Install Eigen"
make install


popd
