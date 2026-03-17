# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A copy-based dotfiles sync system. Files are copied (not symlinked) between `~` and this repo using rsync via a Makefile.

## Commands

```
make pull          # Copy dotfiles from ~ into repo (backup)
make push          # Dry-run: preview what would be deployed
make push APPLY=1  # Actually deploy dotfiles from repo to ~
make diff          # Show what differs between ~ and repo
make help          # List targets
```

## How It Works

**Two-direction sync:**
- `pull` = live system → repo (for backup/commit)
- `push` = repo → live system (for deploying to a new machine)

**Three layers of secret protection:**
1. Hardcoded in `Makefile` (`SECRETS` variable): `.ssh`, `.aws`, `.gnupg`, `.netrc` are always excluded
2. `.dotfiles-blacklist`: user-editable rsync exclude patterns (one per line, `#` for comments)
3. `.gitignore`: mirrors secrets as a last-resort barrier against `git add .`

**Home dir dotfiles** are synced by default (blacklist controls what to skip). Files live at the repo root mirroring `~`.

**Non-home files** (e.g., `/etc/hosts`) are opt-in via `.dotfiles-whitelist` (one absolute path per line). They preserve their directory structure in the repo (e.g., `repo/etc/hosts`).

## Key Files

- `Makefile` — all sync logic
- `.dotfiles-blacklist` — what to exclude from `~` during pull (rsync `--exclude-from` syntax)
- `.dotfiles-whitelist` — non-home paths to include (absolute paths, one per line)
- `.gitignore` — defense-in-depth for secrets and caches

## Adding New Exclusions

Add patterns to `.dotfiles-blacklist`. Uses rsync exclude syntax:
- `name` matches at any depth
- `name/` matches directories only
- `/name` anchored to sync root
- Nested patterns work: `.config/gcloud` excludes that subdir while syncing the rest of `.config/`

After adding to the blacklist, also add sensitive items to `.gitignore`.

## Repo Infrastructure

These files are excluded from sync in both directions (defined in `REPO_FILES` in the Makefile): `.git/`, `Makefile`, `.gitignore`, `.dotfiles-blacklist`, `.dotfiles-whitelist`, `docs/`, `scripts/`, `README*`, `LICENSE*`.
