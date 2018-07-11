#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
. "${CURRDIR}/env.sh"

pushd .

export OPENGV_VERSION="$1"
export OPENGV_INSTALL="$2"

export OPENGV_ROOT="${TRAVIS_BUILD_DIR}/opengv-${OPENGV_VERSION}"
export OPENGV_SOURCE="${OPENGV_ROOT}/source"
export OPENGV_BUILD="${OPENGV_ROOT}/build"

downloadEigen

echo "Download OpenGV"
mkdir --parent "$OPENGV_BUILD"
mkdir --parent "$OPENGV_INSTALL"
git clone --depth 1 https://github.com/laurentkneip/opengv.git "$OPENGV_SOURCE"


echo "Build OpenGV"
cd $OPENGV_BUILD
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$OPENGV_INSTALL" \
  -DCMAKE_CXX_FLAGS="-DEIGEN_DONT_ALIGN_STATICALLY=1 -DEIGEN_DONT_VECTORIZE=1" \
  -DINSTALL_OPENGV=ON \
  -DEIGEN_INCLUDE_DIR="${DEPS_INSTALL_DIR}/include/eigen3" \
  "$OPENGV_SOURCE"

make -j 2 VERBOSE=1 

echo "Install OpenGV"
make install




popd
