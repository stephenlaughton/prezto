####################
# functions
####################

# print available colors and their numbers
function colours() {
    for i in {0..255}; do
        printf "\x1b[38;5;${i}m colour${i}"
        if (( $i % 5 == 0 )); then
            printf "\n"
        else
            printf "\t"
        fi
    done
}

# Create a new directory and enter it
function md() {
    mkdir -p "$@" && cd "$@"
}

function hist() {
    history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

# find shorthand
function f() {
    find . -name "$1"
}

function ng-stop() {
    sudo launchctl stop homebrew.mxcl.nginx
}

function ng-start() {
    sudo launchctl start homebrew.mxcl.nginx
}
function ng-restart() {
     sudo launchctl start homebrew.mxcl.nginx
}


# Start an HTTP server from a directory, optionally specifying the port
function server() {
    local port="${1:-8000}"
    open "http://localhost:${port}/"
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# take this repo and copy it to somewhere else minus the .git stuff.
function gitexport(){
    mkdir -p "$1"
    git archive master | tar -x -C "$1"
}

# get gzipped size
function gz() {
    echo "orig size    (bytes): "
    cat "$1" | wc -c
    echo "gzipped size (bytes): "
    gzip -c "$1" | wc -c
}

# All the dig info
function digga() {
    dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
function escape() {
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
    echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
    perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
    echo # newline
}

# Extract archives - use: extract <file>
# Credits to http://dotfiles.org/~pseup/.bashrc
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) rar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.tbz2) tar xjf $1 ;;
            *.tgz) tar xzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# function scpp() {
#     scp "$1" nnisi@nisi.org:~/nisi.org/i;
#     echo "http://nicknisi.com/i/$1" | pbcopy;
#     echo "Copied to clipboard: http://nicknisi.com/i/$1"
# }

# install a grunt plugin and save to devDependencies
function gi() {
    npm install --save-dev grunt-"$@"
}

# install a grunt-contrib plugin and save to devDependencies
function gci() {
    npm install --save-dev grunt-contrib-"$@"
}

# syntax highlight the contents of a file or the clipboard and place the result on the clipboard
function hl() {
    if [ -z "$3" ]; then
        src=$( pbpaste )
    else
        src=$( cat $3 )
    fi

    if [ -z "$2" ]; then
        style="moria"
    else
        style="$2"
    fi

    echo $src | highlight -O rtf --syntax $1 --font Inconsoloata --style $style --line-number --font-size 24 | pbcopy
}

# set the background color to light
function light() {
    printf "hello from light\n"
    export BACKGROUND="light" && reload!
}

function dark() {
    printf "hello from dark\n"
    export BACKGROUND="dark" && reload!
}

# list and change theme
function themes() {
    basename `ls  $DOTFILES/.config/base16-shell/*.dark.sh`
    echo "Current theme is $THEME"
}

# change theme to given name
function theme() {
    export THEME="base16-$1" && reload!
}

# smart git alias with auto-status
function g() {
    if [[ $# > 0 ]]; then
        # if there are arguments, send them to git
        git $@
    else
        # otherwise, run git status
        git status
    fi
}

function reload!() {
    source ~/.zshrc

    if [[ -n "$TMUX" ]]; then
        if [[ $BACKGROUND == dark ]]; then
            tmux source-file ~/.dotfiles/tmux/dark_theme.conf
        else
            tmux source-file ~/.dotfiles/tmux/light_theme.conf
        fi
        
    fi
}
