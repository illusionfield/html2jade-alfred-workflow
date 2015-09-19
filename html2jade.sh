## Functions ##
function installNpm {
  npm install html2jade
  return
}

function cleanNpm {
  rm -rf node_modules
  installNpm
  return
}

function convertToJade {
  test -z "$(pbpaste)" && return
  pbpaste | "$(npm bin)/html2jade" --bodyless --noemptypipe | pbcopy
  return
}

## Main ##
[[ $1 == "clean" ]] && cleanNpm && exit 0

command -v pbpaste >/dev/null || exit 0
command -v pbcopy >/dev/null || exit 0
test -e $(npm bin)/html2jade || installNpm

convertToJade
