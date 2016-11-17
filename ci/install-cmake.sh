#!/bin/bash
set -e
CURRDIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"

. ${CURRDIR}/env.sh

export CMAKE_VERSION_SHORT=3.4
export CMAKE_VERSION=3.4.1
export CMAKE_URL="https://cmake.org/files/v${CMAKE_VERSION_SHORT}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz"
export CMAKE_ROOT="${TRAVIS_BUILD_DIR}/cmake-${CMAKE_VERSION}"
export CMAKE_INSTALL="${CMAKE_ROOT}/install"

# CMAKE most recent version
if folder_not_empty ${CMAKE_INSTALL}; then
  echo "CMake found in cache.";
else
  echo "Download CMake.";
  download_files_from_tar ${CMAKE_URL} ${CMAKE_INSTALL}
fi
cmake --version

