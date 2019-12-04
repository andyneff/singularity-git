A docker designed to be turned into a singularity image to add a modern git to an old machine

## Getting started

```
source 'setup.env'
just import
```

Now you have a working `git.simg` file, test it out with

```
just git --version
```

## Git usage:

```
./git --version
```

Its best to add an alias in your bashrc file

```bash
alias "git={singularity-git_repo_dir}/git"
```

## ssh-agent

An ssh-agent container has also been added. By default, your `SSH_AUTH_SOCK` will automatically be mounted in and used by the container, however if you aren't on a GUI, the ssh-agent isn't handled for you, and can be easy to lose track of. Next thing you know, you have dozens of `ssh-agent` processed running

```bash
just ssh-agent
```

Will start a singularity instance running and as long as `SSH_AUTH_SOCK` is unset, the git container will automatically connect to it.

## Non-overlay fs support

For older operating systems without overlay fs, mount points must be made static.

This can be accomplished by simply editing your `local.env` (on the docker host) to include:

```bash
DOCKER2SINGULARITY_VERSION=v2.6
GIT_REPO_DIR_DOCKER=/code
GIT_SSH_SOCK_DOCKER=/ssh_sock
```
