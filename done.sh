#!/usr/bin/env bash
# Usage: ./done.sh "Two Sum: hashmap O(n)"
cd "$(dirname "$0")"

if [ $# -lt 1 ]; then echo "Usage: ./done.sh \"<commit message>\"" >&2; exit 1; fi

git pull --rebase --autostash || exit 1
git add -A
git commit -m "$1" && git push
