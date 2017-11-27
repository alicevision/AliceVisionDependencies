#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
. "${CURRDIR}/env.sh"

pushd .

export OIIO_VERSION="$1"
export OIIO_INSTALL="$2"

export OIIO_ROOT="${TRAVIS_BUILD_DIR}/openimageio-${OIIO_VERSION}"
export OIIO_SOURCE="${OIIO_ROOT}/source"
export OIIO_BUILD="${OIIO_ROOT}/build"

downloadOpenEXR

echo "Download OpenImageIO"
mkdir --parent "${OIIO_BUILD}"
mkdir --parent "${OIIO_INSTALL}"

git clone --depth 1 --branch "${OIIO_VERSION}" https://github.com/OpenImageIO/oiio.git "${OIIO_SOURCE}"

echo "Build OpenImageIO"
cd $OIIO_BUILD

cmake -DCMAKE_BUILD_TYPE=Release \
	  -DCMAKE_INSTALL_PREFIX="${OIIO_INSTALL}" \
	  -DOPENEXR_HOME="${DEPS_INSTALL_DIR}" \
	  -DILMBASE_HOME="${DEPS_INSTALL_DIR}" \
	  -DUSE_PYTHON=0 \
	  "${OIIO_SOURCE}"

make -j 2

echo "Install OpenImageIO"
make install




popd
