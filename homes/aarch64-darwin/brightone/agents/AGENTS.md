# Sandbox environment

This agent runs inside an `agent-sandbox.nix` macOS sandbox (`sandbox-exec`).
`$HOME` is an ephemeral tmpfs; the real home is reachable only through the paths
below.

## Accessible paths

| Path | Access | Note |
|---|---|---|
| `$CWD` | read-write | the directory you were launched from |
| git repo root (auto-detected) | read-only | may differ from `$CWD` in worktrees |
| `~/dev` | read-write | |
| `~/.claude` | read-write | claude only |
| `~/.pi` | read-write | pi only |

## Tools on PATH

`bash` and `cacert` are always present. Everything else is listed below.

### Unix core

| Command | Package | Notes |
|---|---|---|
| `ls`, `cp`, `mv`, `cat`, `echo`, `date`, `chmod`, … | `coreutils` | GNU coreutils |
| `find`, `xargs` | `findutils` | |
| `diff`, `cmp`, `patch` | `diffutils` | |
| `less` | `less` | pager |
| `which` | `which` | |
| `grep`, `egrep` | `gnugrep` | |
| `sed` | `gnused` | GNU sed |
| `awk` | `gawk` | GNU awk |
| `curl` | `curl` | HTTP client |
| `git` | `git` | VCS |

### Search / inspection

```bash
fd pattern [dir]              # fast find replacement
rg pattern [dir]              # fast grep (ripgrep)
tree -L 2                     # directory listing
file foo.bin                  # identify file type
hexyl foo.bin                 # hex viewer
hexyl -n 256 foo.bin          # first 256 bytes
```

### Archives

```bash
gzip / gunzip                 # .gz
xz / unxz                     # .xz / .tar.xz
zstd / unzstd                 # .zst
tar -xzf foo.tar.gz           # uses gzip backend
tar -xJf foo.tar.xz           # uses xz backend
tar -x --zstd -f foo.tar.zst  # uses zstd backend
unzip foo.zip
```

### Data / query

```bash
jq '.key' file.json                         # JSON processor
jq -r '.[] | select(.active) | .name'       # filter + raw output
sqlite3 db.sqlite "SELECT * FROM t LIMIT 5" # embedded SQL
duckdb -c "SELECT * FROM 'data.parquet'"    # in-process analytics
duckdb -c "COPY (SELECT …) TO 'out.csv'"   # export
```

### GitHub CLI

```bash
gh issue list -R owner/repo
gh pr create --title "…" --body "…"
gh pr view 123 -R owner/repo --json title,body
gh api /repos/owner/repo/releases --jq '.[0].tag_name'
gh release list -R owner/repo -L 10
gh search issues -R owner/repo "keyword" --state open
```

### Benchmarking

```bash
hyperfine 'cmd1' 'cmd2'          # compare two commands
hyperfine --warmup 3 'cmd'
```

### Python

```bash
python3 script.py
python3 -m venv .venv && source .venv/bin/activate
python3 -m pip install requests
python3 -c "import json, sys; print(json.load(sys.stdin))"
```

### JavaScript / TypeScript

```bash
node script.js
bun run script.ts          # runs TS directly, no transpile step
bun test                   # test runner
bun build src/index.ts --outdir dist
pnpm install
pnpm run build
deno run --allow-net script.ts   # TS-first, no node_modules
deno eval "console.log(1+1)"
```

### Go

```bash
go build ./...
go test ./...
go run main.go
go mod tidy
```

### Rust

> `rustup` is not available. `cargo` and `rustc` are from nixpkgs at a fixed version.

```bash
cargo build --release
cargo test
cargo run -- args
cargo clippy --all-targets --all-features
cargo fmt
rustc --edition 2021 foo.rs
```

### C / C++ / build system

```bash
cc -O2 -o out foo.c           # clang wrapper (stdenv.cc)
c++ -std=c++17 -o out foo.cpp
make
make -j$(nproc)
cmake -B build -G Ninja .
cmake --build build
ninja -C build
pkg-config --cflags --libs openssl
```

### Shell quality

```bash
shellcheck script.sh
shfmt -w script.sh            # format in-place
shfmt -d script.sh            # diff only
```

### Spell-checking

```bash
typos                         # check current directory
typos --write-changes         # auto-fix
typos path/to/file.md
```

### Task runner / VCS

```bash
just                          # run default recipe (reads justfile)
just task-name
jj log                        # Jujutsu — git-compatible VCS
jj diff
jj commit -m "message"
jj git push
```

### Nix

```bash
nixfmt file.nix               # format a single file
nixfmt-tree                   # format all .nix files in tree (if available)
nurl https://github.com/owner/repo   # generate Nix fetch expression
statix check                  # lint .nix files in cwd
statix check path/to/file.nix
deadnix                       # find unused bindings
deadnix --edit                # remove them in-place
dix old.nix new.nix           # semantic diff (shows attribute changes)
om health                     # omnix flake health checks
nixpkgs-hammering -E '<nixpkgs>' pkgAttr   # lint a nixpkgs package
```
