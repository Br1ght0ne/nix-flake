#!/usr/bin/env bash
set -euo pipefail

check_gui_cache() {
    local paths_json paths app path hash response status failed=0
    paths_json=$(nix eval --json --no-update-lock-file "$@" .#darwinConfigurations \
        --apply "$(cat scripts/gui-cache-paths.nix)")
    paths=$(jq -er 'unique_by([.app, .path])[] | [.app, .path] | @tsv' <<<"$paths_json")

    while IFS=$'\t' read -r app path; do
        hash=${path##*/}
        hash=${hash%%-*}
        if ! response=$(curl --silent --show-error --max-time 30 \
            --write-out $'\n%{http_code}' "https://cache.nixos.org/$hash.narinfo"); then
            printf 'ERROR %s: cache request failed for %s\n' "$app" "$path" >&2
            failed=1
            continue
        fi
        status=${response##*$'\n'}
        if [[ "$status" == 200 ]] && grep -Fxq "StorePath: $path" <<<"${response%$'\n'*}"; then
            printf 'CACHED %s: %s\n' "$app" "$path"
        elif [[ "$status" == 404 ]]; then
            printf 'MISSING %s: no substitute for %s\n' "$app" "$path" >&2
            failed=1
        else
            printf 'ERROR %s: unexpected cache response (HTTP %s) for %s\n' "$app" "$status" "$path" >&2
            failed=1
        fi
    done <<<"$paths"
    return "$failed"
}

case "${1:-}" in
    check)
        check_gui_cache
        ;;
    update)
        # Stage on the same filesystem so the final lockfile replacement is atomic.
        candidate_dir=$(mktemp -d ./.nixpkgs-update.XXXXXXXX)
        trap 'rm -rf -- "$candidate_dir"' EXIT
        cp flake.lock "$candidate_dir/original.lock"
        nix flake update nixpkgs --reference-lock-file "$candidate_dir/original.lock" \
            --output-lock-file "$candidate_dir/flake.lock"
        if [[ ! -f "$candidate_dir/flake.lock" ]]; then
            # Nix may skip writing when the input is already current.
            cp "$candidate_dir/original.lock" "$candidate_dir/flake.lock"
        fi
        check_gui_cache --reference-lock-file "$candidate_dir/flake.lock"
        if ! cmp -s flake.lock "$candidate_dir/original.lock"; then
            printf 'flake.lock changed during the update. Retry against the current lockfile.\n' >&2
            exit 1
        fi
        if cmp -s flake.lock "$candidate_dir/flake.lock"; then
            printf 'The current nixpkgs pin passed the GUI cache check.\n'
        else
            mv "$candidate_dir/flake.lock" flake.lock
            printf 'Updated the nixpkgs pin after the GUI cache check passed.\n'
        fi
        ;;
    *)
        printf 'Usage: %s {check|update}\n' "$0" >&2
        exit 2
        ;;
esac
