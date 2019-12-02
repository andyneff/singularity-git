#!/usr/bin/env false bash

function caseify()
{
  local cmd="${1}"
  shift 1
  case "${cmd}" in

# default CMD
    git-cmd) # Run example
      echo "Run git here: ${cmd} ${@+${@}}"
      extra_args=$#
      ;;

    *) # Default: Run command
      exec "${cmd}" ${@+"${@}"}
      ;;
  esac
}
