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

## Non-overlay fs support

For older operating systems without overlay fs, mount points must be made static.

This can be accomplished by simply editing your `local.env` (on the docker host) to include:

```bash
DOCKER2SINGULARITY_VERSION=v2.6
GIT_CWD_DIR_DOCKER=/code
GIT_SSH_SOCK_DOCKER=/ssh_sock
```
