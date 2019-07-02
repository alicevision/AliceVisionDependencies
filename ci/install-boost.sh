#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
. "${CURRDIR}/env.sh"

pushd .

export BOOST_VERSION="$1"
export BOOST_INSTALL="$2"

export BOOST_VERSION_FILENAME=$(echo ${BOOST_VERSION} | tr '.' '_')
export BOOST_ROOT="${TRAVIS_BUILD_DIR}/boost-${BOOST_VERSION}"
export BOOST_SOURCE="${BOOST_ROOT}/source"

echo "Download Boost."
mkdir --parent "$BOOST_ROOT"
mkdir --parent "$BOOST_INSTALL"
cd "$BOOST_ROOT"
download_files_from_tar "https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_VERSION_FILENAME}.tar.gz" "$BOOST_SOURCE"

echo "Build Boost."
cd "$BOOST_SOURCE"
./bootstrap.sh --with-libraries=atomic,container,date_time,exception,filesystem,graph,log,math,program_options,regex,serialization,stacktrace,system,test,thread,timer --prefix="$BOOST_INSTALL"
./b2 link=shared install

popd
