# depends on OMF

## nvm - calling `nvm use` automatically in a directory with a .nvmrc file
function __check_nvm --on-variable PWD --description 'Do nvm stuff'
  if test -f .nvmrc
    set node_version (nvm version)
    set nvmrc_node_version (nvm version (cat .nvmrc))

    if [ $nvmrc_node_version = 'N/A' ]
      nvm install
    else if [ $nvmrc_node_version != $node_version ]
      nvm use
    end
  end
end

## nvm - activate NVM
nvm >> /dev/null

## nvm - check current dir upon Fish session start
__check_nvm
