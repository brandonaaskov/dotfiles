
complete -C /usr/local/bin/terraform terraform
. "$HOME/.cargo/env"
source /opt/homebrew/etc/bash_completion # avalanche completion

alias forge="~/.foundry/bin/forge" # note, this overrides Herd's Forge binary

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
. "/Users/brandonaaskov/.deno/env"
. "$HOME/.langflow/uv/env"
