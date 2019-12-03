#!/usr/bin/env bash

source "${VSI_COMMON_DIR}/linux/just_env" "$(dirname "${BASH_SOURCE[0]}")"/'git.env'

# Plugins
source "${VSI_COMMON_DIR}/linux/docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_docker_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_git_functions.bsh"
source "${VSI_COMMON_DIR}/linux/just_singularity_functions.bsh"

cd "${GIT_CWD}"

# Main function
function caseify()
{
  local just_arg=$1
  shift 1
  case ${just_arg} in
    build) # Build Docker image
      if [ "$#" -gt "0" ]; then
        Docker-compose "${just_arg}" ${@+"${@}"}
        extra_args=$#
      else
        justify build recipes-auto "${GIT_CWD}/Dockerfile"
        Docker-compose build
      fi
      ;;
    docker_git) # Run git in docker
      Just-docker-compose run git ${@+"${@}"}
      extra_args=$#
      ;;

    import) # Build singularity images for git
      justify build
      justify singular-compose import git "${GIT_DOCKER_REPO}:git_${GIT_USERNAME}"
      ;;
    git) # Run git in singularity
      SINGULARITY_ADD_TMP_DIR=0 justify singular-compose run git ${@+"${@}"}
      extra_args=$#
      ;;

    shell) # Run shell in git image
      SINGULARITY_ADD_TMP_DIR=0 justify singular-compose shell git
      ;;

    sync) # Synchronize the many aspects of the project when new code changes \
          # are applied e.g. after "git checkout"
      if [ ! -e "${GIT_CWD}/.just_synced" ]; then
        # Add any commands here, like initializing a database, etc... that need
        # to be run the first time sync is run.
        touch "${GIT_CWD}/.just_synced"
      fi
      # Add any extra steps run when syncing everytime
      Docker-compose down
      justify git_submodule-update # For those users who don't remember!
      justify build
      ;;

    *)
      defaultify "${just_arg}" ${@+"${@}"}
      ;;
  esac
}

if ! command -v justify &> /dev/null; then caseify ${@+"${@}"};fi
