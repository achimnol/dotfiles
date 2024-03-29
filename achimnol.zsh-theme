# Theme from https://github.com/andrew8088/oh-my-zsh/blob/master/themes/doubleend.zsh-theme
# A little bit customized for achimnol

function git_prompt_info() {
  ref=$(git_current_branch)
  if [ -z ${ref} ]; then return 0; fi
  echo -n "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX${ref}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  echo -n " $fg_bold[default][author:$(git_current_user_email)]$reset_color"
}

function get_pwd() {
  print -D $PWD
}

function pyvenv_info() {
  pe=$(pyenv_prompt_info)
  ve=$(virtualenv_prompt_info)
  if [ ${#ve} != 0 ]; then
    echo "[py:$ve[2,-2]]"
  else
    echo "[py:$pe]"
  fi
}

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
    ((git=${#git} - 10))
  else
    git=0
  fi

  local termwidth
  (( termwidth = ${COLUMNS} - 3 - ${#HOST} - ${#$(get_pwd)} - ${#$(pyvenv_info)} - 1 - ${git} ))

  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} "
  done
  echo $spacing
}

function precmd() {
print -rP '
$fg[blue]%m: $fg[yellow]$(get_pwd) $fg_bold[yellow]$(pyvenv_info) $(git_prompt_info)'
}

PROMPT='%{$reset_color%}%{$fg[white]%}%(!.#.>)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"
