# 📦 Schrodinger [beta]

[![](https://img.shields.io/docker/pulls/gleslie2008/schrodinger.svg)](https://hub.docker.com/r/gleslie2008/schrodinger)

**Schrodinger** is a simple CI tool for running your build, test, and deployments in Docker containers.

Run the **Schrodinger** container in your Docker host, create Pipelines to automatically scan your repos for changes, and **Schrodinger** will automatically run them its host's Docker engine.

<center>
  <img src=".readme/1.png" width="600" /> <img src=".readme/2.png" width="600" />
</center>

## Getting Started

There's a couple steps to get started:

- Install Docker on your host.
- Make sure [`docker` is accessible without sudo](https://askubuntu.com/a/477554).
- [Generate a ssh key pair on your host machine](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key) and grant it read access to any repositories you want Schrodinger to build ([GitHub, for example](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)).
- Add a `Dockerfile.schrodinger` to any repos you've added to a Pipeline to define build/test/deploy.

You can also configure a repo for the sample project, [`schrodinger-test`](https://gitlab.com/gleslie/schrodinger-test). Use the SSH repo, and a `master` trigger.

## Installation

Tested on Ubuntu and MacOS.

```bash
docker run \
    -d \
    --name schrodinger \
    -p 80:3000 \
    -e RAILS_LOG_TO_STDOUT=true \
    -e GIT_IDENTITY_FILE=id_rsa \
    -e SCAN_SCHEDULE=5m \
    -v $(which docker):/usr/bin/docker \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.ssh:/app/.ssh:ro \
    -v schrodinger:/persistent/ \
    --privileged=true \
    gleslie2008/schrodinger:latest
```

Ubuntu may require an additional dependency mount:

`-v /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7`

Editable arguments:

- `-e RAILS_LOG_TO_STDOUT`: if present, **Schrodinger** will log to stdout and be captured in Docker logs.
- `-e GIT_IDENTITY_FILE`: specify the private key file **Schrodinger** should use for cloning repositories with SSH. It should be in `/app/.ssh/` in the container.
- `-e SCAN_SCHEDULE`: how often to re-scan repositories for changes. Defaults to `1m`. See [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler) for syntax.
- `-v $HOME/.ssh:/app/.ssh:ro`: mounts the user's `.ssh` directory in read-only mode. This directory should contain the public and private keys **Schrodinger** will use to clone your repositories.
- `-v schrodinger:/persistent/`: mounts a directory that will be used for storing the sqlite database.

Required arguments:

- `-v /usr/bin/docker:/usr/bin/docker`: mounts the Docker binary.
- `-v /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7`: mounts a dependency required on Linux systems. Untested on other systems.
- `-v /var/run/docker.sock:/var/run/docker.sock`: mounts the Docker socket, required for communicating with Docker on the host.

## Caveats

It should only be run in a trusted environment with trusted users, because:

- It runs in privileged mode and mounts the Docker socket, so it has control of its Docker host.
- Secrets are stored in plaintext.
- Git host key checking is disabled to automatically accept hosts when cloning repositories.

## Development

- Install Docker.
- Make sure [`docker` is accessible without sudo](https://askubuntu.com/a/477554).
- Clone this repository.
- `rails db:migrate` to run all migrations.
- `rails db:seed` to seed the database.
- `./start.sh` to start the local development server (see file for other tasks run).

## Documentation

### Pipelines

Create a Pipeline to monitor a set of branches on a repository. If a new commit exists for a monitored branch, the repository will be cloned, and the image defined by the `Dockerfile.schrodinger` will be built and run.

- Triggers: what branches to monitor for changes.
- Domain: any Secrets with a matching domain will automatically inject into the Pipeline's Docker containers as build arguments and environment variables.

### Secrets

Create a secret to inject a configuration value or secret during the build or run of your Docker image. Secrets are automatically hidden in Pipeline logs.

- Domain: any Pipelines with a matching domain will automatically inject the secret to its Docker container as a build argument and environment variable.

### `Dockerfile.schrodinger`

The `Dockerfile.schrodinger` is an ordinary Dockerfile with `schrodinger` appended so **Schrodinger** knows where to find it. You can easily use a multi-stage pipeline to build, test, and deploy code through **Schrodinger**. [Learn more about multi-stage builds from Docker's documentation](https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds).

Example `Dockerfile.schrodinger`:

This example will test and build a static website with node, then upload it to an S3 bucket.

```Dockerfile
FROM node:10
RUN mkdir /app
WORKDIR /app
COPY . /app
RUN npm install
RUN npm test
RUN npm run build

FROM amazon/aws-cli:latest
WORKDIR /app
COPY --from=0 /app .
CMD aws s3 cp /app/ s3://bucket/ --recursive
```
