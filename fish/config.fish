# In your ~/.config/fish/config.fish
if status is-login
    set -gx PATH /Users/w/.pyenv/shims $PATH
    set -gx PATH /usr/local/bin $PATH
    set -gx PATH $HOME/.cargo/bin $PATH
    set -gx PATH /usr/local/opt/postgresql@16/bin $PATH
    eval "$(/opt/homebrew/bin/brew shellenv)"
    pyenv init --path | source
end

if status is-interactive
    pyenv init - | source
end

# nvm
set -gx NVM_DIR (brew --prefix nvm)

# direnv
eval (direnv hook fish)

# Functions
function exp
    ssh gordon-pub -t '~/run_exposure_logs.sh'
end

function chamberprod
    switch (count $argv)
        case 0
            echo "Usage: chamberprod exec <namespace> -- <command>"
            return 1
        case 1
            echo "Usage: chamberprod exec <namespace> -- <command>"
            return 1
        case '*'
            set -l command_parts $argv

            # Find the index of '--'
            set -l separator_index (contains -i -- -- $command_parts)

            if test -z "$separator_index"
                echo "Error: Missing -- to separate namespace and command"
                return 1
            end

            # Extract namespace and command
            set -l namespace $command_parts[2]
            set -l command $command_parts[(math $separator_index + 1)..-1]

            # Execute the command using aws-vault and chamber
            aws-vault exec -s PowerBottom69 -- chamber exec $namespace -- $command
    end
end

function redisgo
    redis-server --requirepass epsteindidnotkillhimself --save "" &
end

function runiw
    chamberprod exec projects/indicator-worker/prod -- cargo run --bin indicator_worker
end

function twscreen
    cd ~/twscreen/
    pyenv activate twscreener
    python src/pyscreen/main.py

    cd writerrs
    cargo run
    cd ..
    cd readerrs
    cargo run
    cd
end

abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
zoxide init fish | source
