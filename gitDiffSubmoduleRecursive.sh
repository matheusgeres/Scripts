#!/bin/bash
# Crie um alias para que o script rode como um programa
# alias git-submodule-recursive="~/sandbox/Scripts/gitDiffSubmoduleRecursive.sh"

FILE_CHANGE_GIT="/tmp/change-git"

# Função para verificar se tem diff
function checkDiff {
  GIT_DIR="--git-dir="$1"/.git"
  CURRENT_BRANCH=`git $GIT_DIR branch | grep \* | cut -d ' ' -f2`
  git $GIT_DIR fetch -a 1>/dev/null
  git $GIT_DIR diff $CURRENT_BRANCH origin/$2 | tee -a $FILE_CHANGE_GIT 1>/dev/null

  # Verificando se há diff com base no arquivo gerado
  if [ -s $FILE_CHANGE_GIT ]
  then
    echo "    ==> There is a diff! Push your branch, dude! :D"
    echo "    git $GIT_DIR push --set-upstream origin $CURRENT_BRANCH"
  else
    echo "    There is no diff! Enjoy your day! ;D"
  fi

  # Limpando o arquivo de change
  rm $FILE_CHANGE_GIT
}

# Obtém os submódulos
SUBMODULES=`git config --file .gitmodules --get-regexp path | awk '{ print $2 }'`

# Pega do parâmetro a branch de destino
BRANCH_DEST="$1"

IFS=$'\n'; set -f; listSub=($SUBMODULES)
for sub in "${listSub[@]}" ; do
  echo "--" "$sub" "--" 
  # echo `git --git-dir=$sub/.git branch`
  checkDiff $sub $BRANCH_DEST
done