.PHONY: all
all:
	# Nothing to make by default.
	# But you might want to run `make upgrade-nvim` when `kickstarter.nvim` upstream has changes to pull.

# Using `git subtree` to manage `.config/nvim/` as a clone of `kickstarter.nvim`
# basics: https://gist.github.com/SKempin/b7857a6ff6bddb05717cc17a44091202
.PHONY: upgrade-nvim
upgrade-nvim:
	git subtree pull --prefix .config/nvim https://github.com/nvim-lua/kickstart.nvim.git master --squash
