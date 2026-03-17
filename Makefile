.PHONY: pull push diff help

# Configuration
HOME_DIR := $(HOME)
BLACKLIST := .dotfiles-blacklist
WHITELIST := .dotfiles-whitelist

# Hardcoded secrets — always excluded regardless of blacklist
SECRETS := --exclude='.ssh' --exclude='.aws' --exclude='.gnupg' --exclude='.netrc' \
           --exclude='.docker' --exclude='.kube'

# Repo infrastructure — never synced in either direction
REPO_FILES := --exclude='.git' --exclude='Makefile' --exclude='.gitignore' \
              --exclude='.dotfiles-blacklist' --exclude='.dotfiles-whitelist' \
              --exclude='docs' --exclude='scripts' --exclude='README*' \
              --exclude='LICENSE*' --exclude='CLAUDE.md'

# Only sync dotfiles (entries starting with .) — excludes non-home dirs like etc/
DOTFILES_ONLY := --include='.*' --include='.*/**' --exclude='*'

# rsync flags
PULL_FLAGS := -av -L --copy-unsafe-links
PUSH_FLAGS := -av

help: ## Show available targets
	@echo "Dotfiles sync:"
	@echo "  make pull   Pull dotfiles from system into repo"
	@echo "  make push   Push dotfiles from repo to system"
	@echo "  make diff   Show differences between system and repo"

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

push: ## Push dotfiles from repo to ~
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
