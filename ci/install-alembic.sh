#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
. "${CURRDIR}/env.sh"

pushd .

export ALEMBIC_VERSION="$1"
export ALEMBIC_INSTALL="$2"

export ALEMBIC_ROOT="${TRAVIS_BUILD_DIR}/Alembic-${ALEMBIC_VERSION}"
export ALEMBIC_SOURCE="${ALEMBIC_ROOT}/source"
export ALEMBIC_BUILD="${ALEMBIC_ROOT}/build"

downloadOpenEXR

echo "Download Alembic"
mkdir --parent "${ALEMBIC_BUILD}"
mkdir --parent "${ALEMBIC_INSTALL}"

git clone --depth 1 --branch "${ALEMBIC_VERSION}" https://github.com/alembic/alembic.git "${ALEMBIC_SOURCE}"

echo "Build Alembic"
cd $ALEMBIC_BUILD

cmake -DCMAKE_BUILD_TYPE=Release \
	  -DCMAKE_INSTALL_PREFIX:PATH="${ALEMBIC_INSTALL}" \
	  -DILMBASE_ROOT:PATH="${DEPS_INSTALL_DIR}" \
	  -DALEMBIC_SHARED_LIBS:BOOL=ON \
		-DUSE_HDF5:BOOL=OFF \
	  "${ALEMBIC_SOURCE}"

make -j 2

echo "Install Alembic"
make install




popd
