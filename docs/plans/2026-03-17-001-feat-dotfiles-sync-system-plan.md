---
title: "feat: Dotfiles sync system with Makefile"
type: feat
status: completed
date: 2026-03-17
origin: docs/brainstorms/2026-03-17-dotfiles-sync-requirements.md
---

# feat: Dotfiles sync system with Makefile

## Overview

Build a Makefile-based dotfiles sync system that captures all non-blacklisted dotfiles from `~` into this repo (`make pull`) and deploys them to a fresh machine (`make push`). Non-home files are opt-in via a whitelist. The entire system is three files: a Makefile, a blacklist, and a whitelist.

## Problem Statement / Motivation

Setting up a new machine means hunting for scattered dotfiles with no history or backup. This repo should be one command away from capturing the current state and one command away from deploying it. (see origin: docs/brainstorms/2026-03-17-dotfiles-sync-requirements.md)

## Proposed Solution

Three files in the repo root:

1. **`Makefile`** — implements `pull`, `push`, and `diff` targets
2. **`.dotfiles-blacklist`** — one pattern per line, controls what `pull` skips from `~`
3. **`.dotfiles-whitelist`** — one absolute path per line, controls what non-home files are synced

### How `make pull` works

1. Reads `.dotfiles-blacklist` (refuses to run if missing)
2. Uses `rsync -av -L --copy-unsafe-links --exclude-from=.dotfiles-blacklist` to copy dotfiles from `~` to the repo root
3. Uses rsync include/exclude rules to only grab entries starting with `.` from `~`
4. Also excludes repo infrastructure (`.git/`, `Makefile`, `docs/`, etc.) so they aren't overwritten by home-dir versions
5. Reads `.dotfiles-whitelist` and copies each listed path into the repo preserving its directory structure (e.g., `/etc/hosts` → `repo/etc/hosts`)
6. Non-destructive: overwrites repo copies but never deletes files from the repo

### How `make push` works

1. `make push` is **dry-run only** by default — shows what would change
2. `make push APPLY=1` actually deploys files
3. Copies dotfiles from repo root to `~`, skipping repo infrastructure files
4. Copies whitelisted non-home files to their absolute paths
5. Non-home files requiring sudo print a clear error with instructions
6. Merge semantics: adds/overwrites but never deletes files from the destination

### Safety layers (defense in depth)

1. **Hardcoded secrets list in the Makefile** — `.ssh`, `.aws`, `.gnupg`, `.netrc` are always excluded from pull regardless of blacklist contents
2. **`.dotfiles-blacklist`** — user-editable exclusions for caches, history, app state
3. **`.gitignore`** — mirrors the secrets + blacklist as a second barrier against `git add .`
4. Pull refuses to run without a blacklist file present

## Technical Considerations

### rsync flag selection

- **Pull** (home → repo): `rsync -av -L --copy-unsafe-links --exclude-from=.dotfiles-blacklist`
  - `-a`: preserves permissions, timestamps, directory structure
  - `-L`: dereferences symlinks (captures actual content, not broken refs)
  - `--copy-unsafe-links`: handles broken symlinks gracefully
  - No `--delete`: pull never removes files from repo (R8)

- **Push** (repo → home): `rsync -av` (or `-avn` for dry-run)
  - No `-L` needed (repo files are already real files)
  - No `--delete`: push never removes files from home (merge semantics)

- macOS ships with openrsync which supports all needed flags

### Filtering dotfiles only from `~`

rsync include/exclude rules, processed in order:

```
--exclude-from=.dotfiles-blacklist    # 1. Remove blacklisted items
--exclude='HARDCODED_SECRETS'         # 2. Always exclude secrets
--include='.*'                        # 3. Include top-level dotfiles
--include='.*/**'                     # 4. Include contents of dotfile dirs
--exclude='*'                         # 5. Exclude everything else (non-dotfiles)
```

### Repo infrastructure exclusion

These are always excluded from both pull and push to prevent the sync system from overwriting itself:

```
.git/
Makefile
.dotfiles-blacklist
.dotfiles-whitelist
.gitignore
docs/
scripts/
README*
LICENSE*
```

Note: `.claude/` is NOT in this list — it is a synced dotfile directory. The blacklist handles excluding `.claude/` caches (sessions, debug, etc.) while keeping config files like `CLAUDE.md` and `settings.json`.

### Blacklist pattern syntax

Uses rsync's native `--exclude-from` syntax:
- `name` matches that filename at any depth
- `name/` matches directories only
- `/name` anchored to the sync root
- `#` lines are comments
- Empty lines are ignored

### Mixed directories (e.g., `.config/`)

The blacklist supports nested patterns. Pull syncs `.config/` by default but blacklist entries like `.config/Code/` or `.config/google-chrome/` exclude the large app caches within it. Same approach for `.claude/` — sync the directory but blacklist `.claude/sessions/`, `.claude/debug/`, etc.

### Whitelist for non-home paths

`.dotfiles-whitelist` contains absolute paths, one per line:

```
# Example
/etc/hosts
/Library/LaunchDaemons/com.example.plist
```

During pull, each path is copied into the repo preserving its directory structure. During push, the whitelist is read and files are copied back to their absolute paths. Paths requiring sudo will fail with a clear message.

## System-Wide Impact

- **Interaction graph**: Makefile targets are independent. No callbacks or side effects beyond file copies.
- **Error propagation**: rsync exits non-zero on failure; Makefile propagates this. Permission errors on non-home files are caught and reported.
- **State lifecycle risks**: Interrupted pull leaves repo in a partially-updated state — git provides the safety net (`git checkout .` to revert). Interrupted push is more concerning but individual file copies are atomic at the filesystem level.
- **API surface parity**: N/A — no external API.

## Acceptance Criteria

### Functional Requirements

- [ ] `make pull` copies all non-blacklisted dotfiles from `~` into the repo root
- [ ] `make pull` copies whitelisted non-home paths into repo preserving directory structure
- [ ] `make pull` refuses to run if `.dotfiles-blacklist` is missing
- [ ] `make pull` never copies hardcoded secrets (`.ssh`, `.aws`, `.gnupg`, `.netrc`) regardless of blacklist
- [ ] `make pull` never deletes files from the repo
- [ ] `make push` shows dry-run output by default (no files changed)
- [ ] `make push APPLY=1` deploys dotfiles from repo to `~`
- [ ] `make push APPLY=1` deploys whitelisted non-home files to their absolute paths
- [ ] `make push` excludes repo infrastructure files (`Makefile`, `.git/`, `docs/`, etc.)
- [ ] `make push` never deletes files from the destination
- [ ] `.gitignore` includes all secrets and blacklisted patterns as defense in depth
- [ ] `make diff` shows differences between live system and repo
- [ ] `make help` shows available targets

### Non-Functional Requirements

- [ ] Single command, no interactive prompts
- [ ] Works on macOS (primary) and Linux (best-effort)
- [ ] No external dependencies beyond rsync and standard unix tools

## Success Metrics

- Running `make pull` populates the repo with all expected dotfiles
- Running `make push APPLY=1` on a fresh machine deploys them correctly
- `.ssh/`, `.aws/`, `.gnupg/`, `.netrc` never appear in the repo or git history
- The workflow is used regularly (one command, no prompts)

(see origin: docs/brainstorms/2026-03-17-dotfiles-sync-requirements.md — Success Criteria)

## Dependencies & Risks

- **rsync availability**: macOS ships with openrsync; Linux has rsync. No install needed.
- **Blacklist completeness**: The initial blacklist must be comprehensive. Missing entries could pull in gigabytes of cache data. Mitigated by the `.gitignore` safety net and hardcoded secrets.
- **Accidental `make pull` on fresh machine**: Could overwrite curated repo content with defaults. Mitigated by requiring explicit `make pull` (not auto-run) and git as the safety net.

## Implementation Plan

### Phase 1: Core files

#### 1a. `.dotfiles-blacklist`

Create the comprehensive blacklist based on the home directory audit:

```
# Secrets (also hardcoded in Makefile as failsafe)
.ssh
.aws
.gnupg
.netrc
.docker
.kube
.mcp-auth
.graph-cli.json
.railway
.gk

# Package manager caches and stores
.npm
.bun
.nvm
.cargo
.rustup
.rvm
.gem
.bundle
.composer
.cocoapods
.pnpm-store
.pnpm-state
.yarn
.cache
.platformio
.minikube
.nuget
.mix
.hex
.deno
.swiftpm
.solc-select
.tflint.d
.ufbt
.foundry
.ityfuzz
.ipfs

# History files
.bash_history
.zsh_history
.zsh_sessions
.psql_history
.python_history
.node_repl_history
.lesshst
.viminfo
.wget-hsts

# OS artifacts
.DS_Store
.CFUserTextEncoding
.Trash

# Application state and caches (not useful config)
.vscode
.cursor
.cursor-tutor
.expo
.gitkraken
.dropbox
.dropbox_bi
.avalanche-cli
.avalanche-cli.bak
.avalanche-network-runner
.avalanchego
.wine
.redisinsight-v2
.cups
.android
.arduinoIDE
.BurpSuite
.cortex-debug
.pgadmin
.oracle_jre_usage
.vnc
.warp
.writerside
.rest-client

# IDE/editor caches
.apm
.degit
.copilot
.codex
.gemini
.junie
.composio
.chirp
.th-client

# Large framework caches
.oh-my-zsh/cache
.oh-my-zsh/log

# .config/ sensitive subdirs (keep config, skip secrets and caches)
.config/gcloud
.config/firebase
.config/stripe
.config/infracost
.config/opencode
.config/configstore

# Claude Code caches (keep config, skip cache)
.claude/debug
.claude/file-history
.claude/sessions
.claude/shell-snapshots
.claude/paste-cache
.claude/projects

# Zsh compiled files
.zcompdump*

# Misc transient
.local
.app-store
.adobe
.installbuilder
.matplotlib
.mem0
.ipython
.gnuradio
.node
.nuxt
.expose
.laravel-forge
```

#### 1b. `.dotfiles-whitelist`

Start empty with a comment explaining the format:

```
# Non-home files to sync (one absolute path per line)
# Example:
# /etc/hosts
```

#### 1c. `.gitignore`

Comprehensive safety net mirroring the blacklist — if rsync has a bug or someone manually copies a file, this is the last line of defense:

```
# Secrets — defense in depth (also in blacklist and hardcoded in Makefile)
.ssh/
.aws/
.gnupg/
.netrc
.docker/
.kube/
.mcp-auth/
.railway/
.gk/
.config/gcloud/
.config/firebase/
.config/stripe/
.config/infracost/

# Large caches that should never enter git
.npm/
.bun/
.nvm/
.cargo/
.rustup/
.rvm/
.gem/
.cache/
.yarn/
.pnpm-store/
.vscode/
.cursor/
.platformio/
.wine/

# History files
.bash_history
.zsh_history
.zsh_sessions/
.psql_history
.python_history
.node_repl_history

# OS
.DS_Store
.Trash/
```

#### 1d. `Makefile`

```makefile
.PHONY: pull push diff help

# Configuration
HOME_DIR := $(HOME)
BLACKLIST := .dotfiles-blacklist
WHITELIST := .dotfiles-whitelist

# Hardcoded secrets — always excluded regardless of blacklist
SECRETS := --exclude='.ssh' --exclude='.aws' --exclude='.gnupg' --exclude='.netrc'

# Repo infrastructure — never synced in either direction
REPO_FILES := --exclude='.git' --exclude='Makefile' --exclude='.gitignore' \
              --exclude='.dotfiles-blacklist' --exclude='.dotfiles-whitelist' \
              --exclude='docs' --exclude='scripts' --exclude='README*' \
              --exclude='LICENSE*'

# Only sync dotfiles (entries starting with .) — excludes non-home dirs like etc/
DOTFILES_ONLY := --include='.*' --include='.*/**' --exclude='*'

# rsync flags
PULL_FLAGS := -av -L --copy-unsafe-links
PUSH_FLAGS := -av

help: ## Show available targets
	@echo "Dotfiles sync:"
	@echo "  make pull          Pull dotfiles from system into repo"
	@echo "  make push          Dry-run: show what push would change"
	@echo "  make push APPLY=1  Actually push dotfiles to system"
	@echo "  make diff          Show differences between system and repo"

pull: _check-blacklist ## Pull dotfiles from ~ into repo
	@echo "Pulling home directory dotfiles..."
	rsync $(PULL_FLAGS) \
		--exclude-from=$(BLACKLIST) \
		$(SECRETS) $(REPO_FILES) \
		$(DOTFILES_ONLY) \
		$(HOME_DIR)/ ./
	@if [ -f $(WHITELIST) ]; then \
		echo "Pulling whitelisted non-home files..."; \
		while IFS= read -r path; do \
			[ -z "$$path" ] && continue; \
			echo "$$path" | grep -q '^#' && continue; \
			if [ -e "$$path" ]; then \
				dest=".$${path}"; \
				mkdir -p "$$(dirname "$$dest")"; \
				rsync $(PULL_FLAGS) "$$path" "$$dest"; \
			else \
				echo "  skip (not found): $$path"; \
			fi; \
		done < $(WHITELIST); \
	fi
	@echo "Done. Review changes with: git diff"

push: ## Push dotfiles from repo to ~ (dry-run by default)
ifdef APPLY
	@echo "Pushing dotfiles to $(HOME_DIR)..."
	rsync $(PUSH_FLAGS) \
		$(SECRETS) $(REPO_FILES) \
		$(DOTFILES_ONLY) \
		./ $(HOME_DIR)/
	@if [ -f $(WHITELIST) ]; then \
		echo "Pushing whitelisted non-home files..."; \
		while IFS= read -r path; do \
			[ -z "$$path" ] && continue; \
			echo "$$path" | grep -q '^#' && continue; \
			src=".$${path}"; \
			if [ -e "$$src" ]; then \
				mkdir -p "$$(dirname "$$path")" 2>/dev/null || \
					{ echo "  sudo required for: $$path"; continue; }; \
				rsync $(PUSH_FLAGS) "$$src" "$$path" 2>/dev/null || \
					echo "  sudo required for: $$path"; \
			fi; \
		done < $(WHITELIST); \
	fi
	@echo "Done."
else
	@echo "DRY RUN — showing what would change:"
	@echo ""
	@echo "Home directory dotfiles:"
	@rsync -avn \
		$(SECRETS) $(REPO_FILES) \
		$(DOTFILES_ONLY) \
		./ $(HOME_DIR)/ 2>/dev/null | tail -n +2 | grep -v '^\s*$$' || echo "  (no changes)"
	@if [ -f $(WHITELIST) ]; then \
		echo ""; \
		echo "Whitelisted non-home files:"; \
		while IFS= read -r path; do \
			[ -z "$$path" ] && continue; \
			echo "$$path" | grep -q '^#' && continue; \
			src=".$${path}"; \
			if [ -e "$$src" ]; then \
				rsync -avn "$$src" "$$path" 2>/dev/null | tail -n +2 | grep -v '^\s*$$' || true; \
			fi; \
		done < $(WHITELIST); \
	fi
	@echo ""
	@echo "Run 'make push APPLY=1' to apply."
endif

diff: ## Show differences between system and repo
	@echo "Files that differ between system and repo:"
	@rsync -avn \
		--exclude-from=$(BLACKLIST) \
		$(SECRETS) $(REPO_FILES) \
		$(DOTFILES_ONLY) \
		$(HOME_DIR)/ ./ 2>/dev/null | tail -n +2 | grep -v '^\s*$$' || echo "  (in sync)"

_check-blacklist:
	@if [ ! -f $(BLACKLIST) ]; then \
		echo "ERROR: $(BLACKLIST) not found."; \
		echo "This file is required to prevent syncing secrets and caches."; \
		echo "Create it or copy the default from the repo."; \
		exit 1; \
	fi
```

### Phase 2: Verification

- [x] Run `make pull` and verify dotfiles appear in the repo
- [x] Check that `.ssh/`, `.aws/`, `.gnupg/`, `.netrc` are NOT in the repo
- [x] Check that cache directories (`.npm/`, `.nvm/`, `.cache/`) are NOT in the repo
- [x] Run `make push` and verify dry-run output
- [x] Run `make diff` and verify it shows meaningful differences
- [x] Commit the initial pull

## Sources & References

### Origin

- **Origin document:** [docs/brainstorms/2026-03-17-dotfiles-sync-requirements.md](docs/brainstorms/2026-03-17-dotfiles-sync-requirements.md) — Key decisions carried forward: blacklist-first for home dir, secrets blacklisted not encrypted, flat layout for home files, copy-based not symlink-based, Makefile as interface

### Internal References

- Current repo: only contains `.bash_profile` with shell/git aliases
- Home directory audit: ~120 dotfiles/dirs, ~50GB+ in caches alone
