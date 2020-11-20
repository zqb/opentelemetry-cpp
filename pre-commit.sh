#!/bin/bash

# This script is supposed to execute as pre-commit / per-merge-commit hook to recreate version.cc with latest build information from git

set -e

if [ -w "$(pwd)/sdk/src/version/version.cc" ]; then
    echo "Error: File is not writable. Check permissions again."
    exit 1
fi

# format: "v<MAJOR>.<MINOR>.<PATCH>-<PRERELEASE>+<BUILDMETADATA>-<NUMBER_OF_NEW_COMMITS>-g<LAST_COMMIT_HASH>""
semver_regex="^v(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(\\-([0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*))?(\\+[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?-([0-9]+)-g([0-9|a-z]+)$"

git_tag=$(git describe --tags --long)
echo $git_tag
if [[ $git_tag =~ $semver_regex ]]; then
    major="${BASH_REMATCH[1]}"
    minor="${BASH_REMATCH[2]}"
    patch="${BASH_REMATCH[3]}"
    pre_release="${BASH_REMATCH[5]}" #optional
    build_metadata="${BASH_REMATCH[6]}" #optional
    count_new_commits="${BASH_REMATCH[9]}"
    latest_commit_hash="${BASH_REMATCH[10]}"
else
    echo "-Error: Incorrect tag format recevived. Exiting.."
    exit 1

fi

if [ -z ${major} ] || [ -z ${minor} ] || [ -z ${patch} ] || [ -z ${count_new_commits} ] || [ -z ${latest_commit_hash} ]; then
    echo "Error: Incorrect tag format recevived. Exiting.."
    exit 1
fi

: ${pre_release:="NONE"} # use default string if not defined
: ${build_metadata:="NONE"} # use default string if not defined
latest_commit_hash=$(git rev-parse ${latest_commit_hash}) # get full hash from short

if [ -z ${latest_commit_hash} ]; then
    echo "Error: Incorrect short hash received. Exiting.."
    exit 1
fi

branch="$(git rev-parse --abbrev-ref HEAD)"
short_version="${major}.${minor}.${patch}"
full_version="${short_version}-${pre-release}-${build_metadata}-${count_new_commits}-${branch}-${latest_commit_hash}"
echo $short_version
echo $full_version
cat > $(pwd)/sdk/src/version/version.cc <<END

#include "opentelemetry/sdk/version/version.h"

OPENTELEMETRY_BEGIN_NAMESPACE
namespace sdk
{
namespace version
{
    const int MAJOR_VERSION = ${major};
    const int MINOR_VERSION = ${minor};
    const int PATCH_VERSION = ${patch};
    const char* PRE_RELEASE = "${pre_release}";
    const char* BUILD_METADATA = "${build_metadata}";
    const int COUNT_NEW_COMMITS = "$count_new_commits}"
    const char* BRANCH = "${branch}";
    const char* COMMIT_HASH = "${latest_commit_hash}";
    const char* SHORT_VERSION = "${short_version}";
    const char* FULL_VERSION = "${full_version}";
}
END

git add "$(pwd)/sdk/src/version/version.cc"