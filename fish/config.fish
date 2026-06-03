# ---- Paths ----
set -x PATH $HOME/.local/bin $PATH

# ---- Pyenv ----
if command -v pyenv >/dev/null 2>&1
    set -x PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
    pyenv init - | source
end

# ---- Vi key bindings ----
function fish_user_key_bindings
    fish_vi_key_bindings
    bind -M insert -m default kj backward-char force-repaint
end

# ---- Right prompt ----
function fish_right_prompt
    echo (set_color 4a4440)"$USER@"(uname -n)
end

# ---- Vi mode indicator ----
function fish_mode_prompt
    switch "$fish_bind_mode"
        case default
            echo -n (set_color bf5959)"n "
        case insert
            echo -n (set_color 857870)"i "
        case visual
            echo -n (set_color c99a6e)"v "
        case "*"
            echo -n "? "
    end
end

# ---- Prompt ----
function fish_prompt
    set -l last_status $status
    set -l cwd (prompt_pwd | string replace -r "^~" (set_color --bold c99a6e)"~"(set_color e2d9d0))

    set_color e2d9d0
    echo -n $cwd

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo -n (set_color 4a4440)" on "
        echo -n (set_color c99a6e)(git branch --show-current)
    end

    echo -n (set_color 4a4440)" → "
    set_color normal
end

# ---- Environment ----
set -x EDITOR code
set -x WLR_NO_HARDWARE_CURSORS 1
set -x GDK_BACKEND wayland
set -x QT_QPA_PLATFORM wayland
set -gx ZINK_DISABLE_OVERRIDE 1

# ---- Aliases ----
if command -v eza >/dev/null 2>&1
    alias ls "eza --icons"
else
    alias ls "ls --color=auto -F"
end
alias treelist "tree -a -I '.git'"

# ---- FZF ----
set -x FZF_DEFAULT_OPTS "
--bind='ctrl-j:down,ctrl-k:up,ctrl-t:toggle-all,ctrl-space:toggle-preview'
--color=fg:#857870,hl:#c99a6e,fg+:#e2d9d0,bg+:#252220,hl+:#c99a6e,info:#857870,pointer:#c99a6e,prompt:#c99a6e
"

# ---- Syntax colors ----
set -g fish_color_normal         e2d9d0
set -g fish_color_command        c99a6e
set -g fish_color_keyword        bf9070
set -g fish_color_quote          89a87a
set -g fish_color_redirection    857870
set -g fish_color_end            c99a6e
set -g fish_color_error          bf5959
set -g fish_color_param          d4b896
set -g fish_color_comment        4a4440
set -g fish_color_selection      --background=252220
set -g fish_color_search_match   --background=252220
set -g fish_color_operator       c99a6e
set -g fish_color_escape         bf9070
set -g fish_color_autosuggestion 4a4440

set -g fish_pager_color_progress    4a4440
set -g fish_pager_color_prefix      c99a6e
set -g fish_pager_color_completion  e2d9d0
set -g fish_pager_color_description 857870

# ---- bun ----
set -gx PATH $HOME/.bun/bin $PATH

# ---- SSH agent ----
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
end
