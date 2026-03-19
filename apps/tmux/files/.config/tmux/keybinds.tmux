# Reload config with r
unbind r
bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

# Vi copy mode
setw -g mode-keys vi
