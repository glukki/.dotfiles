## npm
abbr -a npmR npm run-script

function npmE
  set --append PATH ./node_modules/.bin
  eval $argv
end
complete -c npmE -f -a "(ls -1 ./node_modules/.bin/)"
