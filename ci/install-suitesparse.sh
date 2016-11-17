#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
. "${CURRDIR}/env.sh"

pushd .

export SS_VERSION="$1"
export SS_INSTALL="$2"

export SS_ROOT="${TRAVIS_BUILD_DIR}/suitesparse-${SS_VERSION}"
export SS_SOURCE="${SS_ROOT}/source"

echo "Download SuiteSparse"
mkdir --parent "$SS_INSTALL"
cd "$SS_ROOT"
download_files_from_tar "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-${SS_VERSION}.tar.gz" "$SS_SOURCE"

echo "Build SuiteSparse"
cd "$SS_SOURCE"
make -j 2

echo "Install SuiteSparse"
make install INSTALL="$SS_INSTALL"
     
popd
