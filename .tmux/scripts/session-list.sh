#!/bin/bash
current_session=$(tmux display-message -p '#{session_name}')
tmux list-sessions | cut -d: -f1 | sort | awk -v current="$current_session" '{
  if ($1 == current) {
    printf "#[fg=white]#[bg=colour81] %d:%s #[default] ", NR, $1
  } else {
    printf "#[fg=colour240]#[bg=colour6] %d:%s #[default] ", NR, $1
  }
}'
