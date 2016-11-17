#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
. "${CURRDIR}/env.sh"

pushd .

export OPENCV_VERSION="$1"
export OPENCV_INSTALL="$2"

export OPENCV_ROOT="${TRAVIS_BUILD_DIR}/opencv-${OPENCV_VERSION}"
export OPENCV_SOURCE="${OPENCV_ROOT}/source"
export OPENCV_CONTRIB="${OPENCV_ROOT}/contrib"
export OPENCV_BUILD="${OPENCV_ROOT}/build"


mkdir --parent "$OPENCV_CONTRIB"
mkdir --parent "$OPENCV_BUILD"
mkdir --parent "$OPENCV_INSTALL"

echo "Download OpenCV"
git clone --recursive --branch "${OPENCV_VERSION}" --depth 1 https://github.com/Itseez/opencv.git "$OPENCV_SOURCE"
git clone --branch "${OPENCV_VERSION}" --depth 1  https://github.com/Itseez/opencv_contrib.git "$OPENCV_CONTRIB"

echo "Build OpenCV"
cd $OPENCV_BUILD
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$OPENCV_INSTALL" \
  -DOPENCV_EXTRA_MODULES_PATH="$OPENCV_CONTRIB/modules" \
  "$OPENCV_SOURCE"
make -j 2

echo "Install OpenCV"
make install

popd
