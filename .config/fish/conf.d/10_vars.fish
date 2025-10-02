## secret vars

set -l FILE ~/.secrets/secrets.fish

if not test -e $FILE; or not source $FILE
  echo "Fish config is missing `secrets` file"
  echo "touch $FILE"
else
  set -l envVar
  for envVar in NPM_TOKEN HOMEBREW_GITHUB_API_TOKEN GEMFURY_TOKEN
    if not set -q $envVar
      echo Fish config is missing the "$envVar" variable. Set it with:
      echo 'echo "set -gx' $envVar '\'value\'" >> $FILE'
    end
  end
end

## public vars
set -gx EDITOR 'micro'
set -gx HOMEBREW_CLEANUP_MAX_AGE_DAYS '7'
