#!/usr/bin/env bash

typeset TOPLEVEL="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
typeset LOCAL_BIN="/usr/local/bin"
typeset LOCAL_SBIN="/usr/local/sbin"

typeset NPM_HOME="$TOPLEVEL/node_modules"
typeset NPM_BIN="$NPM_HOME/.bin"
export GEM_HOME="$TOPLEVEL/.gems"
typeset GEM_BIN="$GEM_HOME/bin"
typeset DEP_BINS="/usr/local/bin:/usr/local/sbin:$TOPLEVEL/local/bin:$NPM_BIN:$GEM_BIN"

export LANG=hu_HU.UTF-8
export LC_ALL=hu_HU.UTF-8
export LC_CTYPE=hu_HU.UTF-8

PATH="$(echo $PATH | grep -qi "$DEP_BINS" || echo "$DEP_BINS:")$PATH"

function __npm_installer {
  test -d "$NPM_BIN" && return true
  which "npm" &>/dev/null && \
    rm -rf "$NPM_HOME" && npm install && return true
}

function __gem_installer {
  test -d "$GEM_BIN" && test -f "$TOPLEVEL/Gemfile.lock" && return true
  test -x "$GEM_BIN/bundle" || \
    which "gem" &>/dev/null && \
      gem install "bundler" "--install-dir" "$GEM_HOME" || return
  "$GEM_BIN/bundle" install && return true
}

__npm_installer && __gem_installer || return #echo "Init Hiba!"

function awr {
  typeset TASK=$(command -v "$1") && test -z "$TASK" && return

  [[ "$1" == "sass-convert" ]] && \
    TASK="$TASK -F scss -T sass -s"
  
  [[ "$1" == "html2pug" ]] && \
    TASK="$TASK -f /dev/stdin"

  #echo "$TASK"
  pbpaste | "$TASK" | pbcopy
}
