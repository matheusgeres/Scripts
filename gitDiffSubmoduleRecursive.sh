#!/bin/bash
# Crie um alias para que o script rode como um programa
# alias git-submodule-recursive="~/sandbox/Scripts/gitDiffSubmoduleRecursive.sh"

FILE_CHANGE_GIT="/tmp/change-git"
TABS_IDENT="    "
RED='\033[0;31m'
NC='\033[0m'
LIGHT_GREEN='\e[92m'
BLUE='\e[34m'
BLINK='\e[5m'
WHITE_BG='\e[107m'

# Função para verificar se tem diff
function checkDiff {
  GIT_DIR="--git-dir="$1"/.git"
  
  CURRENT_AUTHOR=`git config --global user.name`
  LAST_AUTHOR=`git $GIT_DIR log -1 --pretty=format:'%an'`
  MESSAGE_NODIFF="$TABS_IDENT There is no diff! Enjoy your day! ;D"

  if [ "$CURRENT_AUTHOR" == "$LAST_AUTHOR" ]
  then 
    CURRENT_BRANCH=`git $GIT_DIR branch | grep \* | cut -d ' ' -f2`
    git $GIT_DIR fetch -a 1>/dev/null
    git $GIT_DIR diff $CURRENT_BRANCH origin/$2 | tee $FILE_CHANGE_GIT 1>/dev/null

    # Verificando se há diff com base no arquivo gerado
    if [ -s $FILE_CHANGE_GIT ]
    then
      echo "$TABS_IDENT ==> There is a diff! Push your branch, dude! :D"
      echo -e "$TABS_IDENT $RED$BLINK(!)$NC$LIGHT_GREEN git $GIT_DIR push --set-upstream origin $CURRENT_BRANCH $NC"
    else
      echo $MESSAGE_NODIFF
    fi

    # Limpando o arquivo de change
    rm $FILE_CHANGE_GIT
  else
    echo $MESSAGE_NODIFF
  fi

  echo ""
}

# Obtém os submódulos
SUBMODULES=`git config --file .gitmodules --get-regexp path | awk '{ print $2 }'`

# Pega do parâmetro a branch de destino
BRANCH_DEST="$1"

IFS=$'\n'; set -f; listSub=($SUBMODULES)
for sub in "${listSub[@]}" ; do
  echo -e "$BLUE--" "$sub" "--$NC" 
  # echo `git --git-dir=$sub/.git branch`
  checkDiff $sub $BRANCH_DEST
done