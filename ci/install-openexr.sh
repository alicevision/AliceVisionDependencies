#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
. "${CURRDIR}/env.sh"

pushd .

export OPENEXR_VERSION="$1"
export OPENEXR_INSTALL="$2"

export OPENEXR_ROOT="${TRAVIS_BUILD_DIR}/openexr-${OPENEXR_VERSION}"
export OPENEXR_SOURCE="${OPENEXR_ROOT}/source"

export ILMBASE_BUILD="${OPENEXR_ROOT}/build/IlmBase"
export OPENEXR_BUILD="${OPENEXR_ROOT}/build/OpenEXR"



echo "Download OpenEXR"
mkdir --parent "$ILMBASE_BUILD"
mkdir --parent "$OPENEXR_BUILD"
mkdir --parent "$OPENEXR_INSTALL"


git clone --depth 1 --branch "v${OPENEXR_VERSION}" https://github.com/openexr/openexr.git "$OPENEXR_SOURCE"


echo "Build IlmBase"
cd $ILMBASE_BUILD

cmake -DCMAKE_BUILD_TYPE=Release \
	  -DCMAKE_INSTALL_PREFIX=$OPENEXR_INSTALL \
	  "$OPENEXR_SOURCE/IlmBase"
	  
make -j 2 

echo "Install IlmBase"
make install

echo "Build OpenEXR"
cd $OPENEXR_BUILD

cmake -DCMAKE_BUILD_TYPE=Release \
	  -DILMBASE_PACKAGE_PREFIX=$OPENEXR_INSTALL \
	  -DCMAKE_INSTALL_PREFIX=$OPENEXR_INSTALL \
	  "$OPENEXR_SOURCE/OpenEXR"
	  
make -j 2 

echo "Install OpenEXR"
make install

popd
