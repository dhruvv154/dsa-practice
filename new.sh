#!/usr/bin/env bash
# Usage: ./new.sh <topic-folder> <number-slug> [ext]
# Example: ./new.sh arrays-hashing 0001-two-sum
set -e
cd "$(dirname "$0")"

if [ $# -lt 2 ]; then echo "Usage: ./new.sh <topic-folder> <number-slug> [ext]" >&2; exit 1; fi
topic="$1"; name="$2"; ext="${3:-py}"

if [ ! -d "$topic" ]; then echo "No topic folder '$topic'" >&2; exit 1; fi

file="$topic/$name.$ext"
if [ -e "$file" ]; then echo "$file already exists" >&2; exit 1; fi

cp TEMPLATE.py "$file"
echo "Created $file"
