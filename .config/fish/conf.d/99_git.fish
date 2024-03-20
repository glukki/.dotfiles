# should run after OMF to overwrite its git abbrs

## git shortcuts
abbr -a gap         git add -p
abbr -a gb          git branch -vv
abbr -a gcb         git checkout -b
abbr -a gsb         git status -sb
abbr -a glr         git pull --rebase --autostash
abbr -a glpr        "git log --pretty=format:'* %s' HEAD ^origin/main | tac"
abbr -a ggr         git grep
abbr -a gpfl        git push --force-with-lease
abbr -a gpft        git push --follow-tags
abbr -a gpr         git pull-request
abbr -a gprd        git pull-request -b dev
abbr -a gprstage    git pull-request -b stage
abbr -a grbi        git rebase --interactive --autostash
abbr -a grbim       git rebase --interactive --autostash --autosquash origin/main
abbr -a gstau       git stash save --include-untracked
abbr -a gcn!        git commit -v --no-edit --amend
abbr -a gcf         git commit --fixup
function gcfr
  set -l rev (git rev-parse $1);
  and git commit --fixup "$argv";
  and git rebase -i --autosquash "$rev^"
end
function gpsup
  git push --set-upstream origin (git branch | grep \* | cut -d ' ' -f2) $argv
end
