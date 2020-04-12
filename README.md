# 📦 Schrodinger

**Schrodinger** is a simple CI tool that runs as a Docker container. It utilizes the host to run Dockerfile-based build, test, and/or deploy containers, with simple built-in configuration/secret management.

It should only be run in a trusted environment with trusted users, because:

- It runs in privileged mode and mounts the Docker socket, so it has control of it's Docker host.
- Secrets are stored in plaintext.
- Git host key checking is disabled to automatically accept hosts when cloning repositories.

## Getting Started

There's a couple steps to get started:

- Install Docker on your host.
- Make sure [`docker` is accessible without sudo](https://askubuntu.com/a/477554).
- [Generate a ssh key pair on your host machine](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key) and grant it read access to any repositories you want Schrodinger to build ([GitHub, for example](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)).

## Installation

TODO: Replace with DockerHub image once on registry.

```bash
docker build -t schrodinger .
docker run \
    --name schrodinger \
    -p 80:3000 \
    -e RAILS_LOG_TO_STDOUT=true \
    -e GIT_IDENTITY_FILE=id_rsa \
    -v /usr/bin/docker:/usr/bin/docker \
    -v /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.ssh:/app/.ssh:ro \
    -v schrodinger:/persistent/ \
    --privileged=true \
    -t schrodinger
```

## Development

- Install Docker.
- Make sure [`docker` is accessible without sudo](https://askubuntu.com/a/477554).
- Clone this repository.
- `rails db:migrate` to run all migrations.
- `rails db:seed` to seed the database.
- `./start.sh` to start the local development server (see file for other tasks run).
