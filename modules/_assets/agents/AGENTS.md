# Sandbox environment

For `claude`, `pi`, and `codex-boxed` launched through `agent-sandbox.nix`, the
following sandbox instructions apply. `codex-boxed` disables its inner sandbox and
approval prompts; the outer sandbox enforces access. The `*-unboxed` commands and
plain `codex` skip the outer sandbox. Plain `codex` keeps Codex's normal permission
and sandbox settings for IDE compatibility while the outer sandbox is unfinished.
`$HOME` is an ephemeral tmpfs; the real home is reachable only through the paths
below.

## Accessible paths

| Path | Access | Note |
|---|---|---|
| `$CWD` | read-write | the directory you were launched from |
| git repo root (auto-detected) | read-only | may differ from `$CWD` in worktrees |
| `~/dev` | read-write | |
| `~/.agents` | read-write | shared by all agents |
| `~/.claude` | read-write | claude only |
| `~/.pi` | read-write | pi only |
| `~/.codex` | read-write | codex only |

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
nixpkgs-hammering -E '<nixpkgs>' pkgAttr   # lint a nixpkgs package
```


# Nixpkgs contribution process

When working in a Nixpkgs checkout, including
`~/dev/github.com/NixOS/nixpkgs`, resolve the following paths relative to that
checkout. Read its `CONTRIBUTING.md` and applicable subsystem guidance before
editing; the current repository policy takes precedence over this summary.

1. Inspect the working tree and preserve unrelated changes. Keep updates focused.
   Verify the upstream repository, latest requested release, download URL and
   source hash against upstream evidence.
2. Follow repository conventions. Run appropriate formatting, evaluation and
   build checks; for a package update, build the affected attribute when possible
   (for example, `nix-build -A thaw --no-out-link`). Report the platform, commands,
   results and limitations. Building does not establish runtime correctness.
3. Prepare a reviewable diff and a conventional commit message, such as
   `thaw: 1.2.0 -> 2.1.0`, including the required AI disclosure. Use the repository
   PR template and include testing evidence and a separate PR disclosure. Only
   mark checklist items that have actually been verified.
4. Ensure a responsible human reviews and understands the contribution before
   submission. Obtain user authorization before publishing, pushing or posting
   public messages. Verify fixes made in response to review feedback and disclose
   generated follow-up text separately.

## Usage and accountability

- Keep a responsible human in the loop. Prepare changes and validation evidence
  for human review before submission. Never claim that human review occurred
  unless it actually did.
- The submitting contributor must understand the contribution, reasonably expect
  it to be correct, and ensure appropriate licensing and credit. AI output needs
  manual review or suitable automated verification; unreviewed autonomous
  contributions and automated-only merge decisions are not permitted.
- Review and disclose verification automation in line with the policy. Report
  commands run, results, and limitations accurately; distinguish building a package
  from testing the application at runtime.
- Apply these requirements to follow-up discussion as well. The contributor must
  be able to answer questions and address feedback without merely relaying AI
  messages.

## Disclosure

- Disclose non-trivial generated output, including edited output, in code,
  documentation, commit messages, PR summaries, issues, reviews, and public
  development discussions.
- For LLM-assisted commits, include an `Assisted-by:` trailer identifying the tool
  and primary model name and version actually used. For example, replace the
  placeholders in `Assisted-by: Codex (<model name and version>)` with verified
  session details. Never invent model information; obtain it before submission
  if unavailable. A `Co-authored-by:` trailer does not satisfy this requirement.
- Disclose assistance separately in PR summaries and review comments; a commit
  trailer alone does not cover them. State the tool/model and the scope of its
  assistance, including relevant verification tooling.
- When preparing a contribution for the user to submit, include the required
  disclosure in the prepared commit message or public text. Do not submit public
  communication without authorization.

## Exemptions and drafts

Follow the policy’s exact exemptions. Reviewed deterministic editor/formatter
changes, short rote completions, and approved community automation may be exempt.
AI research, testing, debugging, or private review is outside disclosure scope
when no substantial output is included, but significant technical influence should
still be disclosed where relevant. Do not assume an entire contribution is exempt
because one step used an exempt tool.

Draft PRs still require some review and disclosure; complete review is required
before marking them ready. Translation retains responsibility, confidence, and
disclosure requirements. AI use in packaged upstream software is outside this
policy’s scope.
