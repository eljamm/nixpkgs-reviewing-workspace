#!/usr/bin/env bash

set -euxo pipefail

pr_number="$1"

gh workflow run 'nixpkgs-review.yml' --field pr-number="$pr_number"

exec ./watch.bash
