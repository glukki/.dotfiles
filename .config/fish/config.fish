## dirs
abbr -a cdp cd /Volumes/projects/

# pnpm
set -gx PNPM_HOME "/Users/glukki/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
