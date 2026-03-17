---
date: 2026-03-17
topic: dotfiles-sync
---

# Dotfiles Sync System

## Problem Frame
Setting up a new machine requires manually tracking down and copying dotfiles and config scattered across the filesystem. There's no timeline of changes and no off-site backup. This repo should be a single command away from capturing the current system state and a single command away from deploying it to a fresh machine.

## Requirements

- R1. `make pull` copies dotfiles from the live system into this repo
- R2. `make push` deploys dotfiles from this repo onto the system
- R3. Home directory dotfiles (files and directories) are synced by default — a blacklist file in the repo controls what to skip
- R4. The default blacklist excludes: secrets (`.ssh`, `.aws`, `.gnupg`, `.netrc`), caches/package stores (`.cache`, `.npm`, `.nvm`, `.cargo`, `.bun`, `.pnpm-store`, etc.), history files (`.bash_history`, `.zsh_history`, `.zsh_sessions`), OS artifacts (`.Trash`, `.DS_Store`), and other large/transient directories
- R5. Non-home files (e.g., from `/etc/` or other paths) are only synced when explicitly listed in a whitelist file
- R6. Home dotfiles are stored at the repo root (e.g., `repo/.zshrc`, `repo/.claude/`). Whitelisted non-home files preserve their path under the repo (e.g., `repo/etc/hosts`)
- R7. Both blacklist and whitelist are plain text files in the repo, one path pattern per line, easy to edit by hand
- R8. `make pull` is non-destructive to the repo — it overwrites repo copies with live versions but never deletes files from the repo that no longer exist on the system (to preserve history)
- R9. `make push` should warn or dry-run before overwriting files on the live system

## Success Criteria
- Running `make pull` on the current machine populates the repo with all non-blacklisted home dotfiles plus whitelisted paths
- Running `make push` on a fresh machine deploys those files to the correct locations
- Sensitive files never appear in the repo or git history
- The workflow is simple enough that it gets used regularly (one command, no interactive prompts)

## Scope Boundaries
- No symlink-based management (e.g., GNU Stow) — this is a copy-based sync
- No automatic install of packages/tools (homebrew, apt, etc.) — just file sync
- No encryption (secrets are blacklisted, not encrypted)
- No cross-platform support required (macOS-first, Linux nice-to-have)

## Key Decisions
- **Blacklist over whitelist for home dir**: Sync everything by default, exclude known bad items. Ensures new dotfiles are captured automatically without manual updates.
- **Secrets are blacklisted, not encrypted**: Simpler and safer — secrets are managed outside this repo entirely.
- **Flat layout for home files**: Home dotfiles sit at the repo root for simplicity. Non-home files keep their full path structure.
- **Copy-based, not symlink-based**: `pull` and `push` copy files. No runtime dependency on the repo location.
- **Makefile as interface**: `make pull`, `make push`, potentially `make diff` to preview changes.

## Outstanding Questions

### Deferred to Planning
- [Affects R4][Needs research] What's the complete initial blacklist? Need to audit `~` for all cache dirs, package stores, and transient state that shouldn't be synced.
- [Affects R6][Technical] How to handle dotfile directories that contain a mix of config and cache (e.g., `.config/` has useful configs but also app caches)?
- [Affects R2][Technical] Should `make push` use rsync flags, cp, or something else for the copy mechanism?
- [Affects R9][Technical] Best UX for the push dry-run — separate `make push-dry` target, or interactive confirmation?

## Next Steps
→ `/ce:plan` for structured implementation planning
