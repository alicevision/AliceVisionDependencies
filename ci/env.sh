#!/bin/bash
set -e

[ -z "${TRAVIS_BUILD_DIR}" ] && echo "No TRAVIS_BUILD_DIR env variable, use current folder." && export TRAVIS_BUILD_DIR=$PWD

# Same as travis_retry:
# https://raw.githubusercontent.com/tomjaguarpaw/neil/master/travis.sh
retry() {
  local result=0
  local count=1
  while [ $count -le 3 ]; do
    [ $result -ne 0 ] && {
      echo -e "\n${ANSI_RED}The command \"$@\" failed. Retrying, $count of 3.${ANSI_RESET}\n" >&2
    }
    "$@"
    result=$?
    [ $result -eq 0 ] && break
    count=$(($count + 1))
    sleep 1
  done

  [ $count -gt 3 ] && {
    echo -e "\n${ANSI_RED}The command \"$@\" failed 3 times.${ANSI_RESET}\n" >&2
  }

  return $result
}

# Check if the folder exists and is non empty
folder_not_empty()
{
    if [ -d "$1" ] && [ "$(ls -A $1)" ]; then
        # The folder exist and is non empty
        return 0
    fi
    return 1
}

# Check if the folder doesn't exist or is empty
folder_empty()
{
    if [ -d "$1" ] && [ "$(ls $1)" ]; then
        return 1
    fi
    # The folder doesn't exist or is empty
    return 0
}

# download_files_from_tar http://path/to/archive.tar.gz /path/to/source
download_files_from_tar()
{
    if folder_empty "$2"; then
        mkdir --parent "$2"
        retry wget --no-check-certificate --quiet -O - "$1" | tar --strip-components=1 -xz -C "$2"
    fi
    return 0
}

export PATH="${CMAKE_INSTALL}/bin:${PATH}"

export EIGEN_VERSION=3.2.8
export OPENEXR_VERSION=2.2.1


# downloadFromAliceVision TARGET_FULL_NAME INSTALL_PATH
downloadFromAliceVision()
{
    download_files_from_tar "https://github.com/alicevision/AliceVisionDependencies/releases/download/$1/$1.tgz" $2
    return 0
}


# Download the AliceVision eigen version.
# It is defined globally because this libraries is used by multiple targets.
downloadEigen()
{
    downloadFromAliceVision eigen-${EIGEN_VERSION} ${DEPS_INSTALL_DIR}
    return 0
}

downloadOpenEXR()
{
    downloadFromAliceVision openexr-${OPENEXR_VERSION} ${DEPS_INSTALL_DIR}
    return 0
}

