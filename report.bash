#!/usr/bin/env bash

set -euxo pipefail

pr_number="$1"
output_dir="$2"
report="$output_dir/report.md"

tree "$output_dir"

echo >"$report" # clear old report, if it exists

for runner in X64-Linux ARM64-Linux X64-macOS ARM64-macOS; do
    runner_report=$(cat "$output_dir/nixpkgs-review-files-pr-$pr_number-$runner/pr-$pr_number/report.md")

    # The `nixpkgs-review` header is included with the first runner (X64-Linux)
    # so we don't need to include the ones from subsequent runners.
    if [ "$runner" != "X64-Linux" ]; then
        runner_report=$(echo "$runner_report" | sed '1,5d')
    fi

    echo "$runner_report" >>"$report"
done

cat "$report"
