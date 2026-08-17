#!/bin/sh

# Print a build identifier derived from the nearest MyWrt release tag.
# Mark it dirty when tracked, staged, or untracked source changes exist.

set -eu

TOPDIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$TOPDIR"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 1

VERSION=$(git describe \
	--tags \
	--match 'mywrt-v[0-9]*' \
	--always \
	--long)

if ! git diff --quiet --ignore-submodules -- || \
	! git diff --cached --quiet --ignore-submodules -- || \
	git ls-files --others --exclude-standard | grep -q .; then
	VERSION="${VERSION}-dirty"
fi

printf '%s\n' "$VERSION"
