# 🐈 Schrodinger

Schrodinger is a very simple CI tool for \*nix Docker hosts. It will clone your repo, build a multi-stage Dockerfile, and run it.

**Note** that Schrodinger should only be run in an environment with trusted users as users can arbitrarily run any Docker images on the host.

## Installation (Ubuntu 18.04)

Schrodinger runs in Docker.

TODO: Replace with Dockerhub image once on registry.

First, generate a `RAILS_MASTER_KEY` for your Schrodinger instance. Include it in subsequent commands.

```bash
docker build --build-arg RAILS_MASTER_KEY=xxx -t schrodinger .
docker run \
    -e RAILS_MASTER_KEY=xxx \
    -e RAILS_LOG_TO_STDOUT=true \
    -v /usr/bin/docker:/usr/bin/docker \
    -v /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --privileged=true \
    --restart=always \
    -t schrodinger
```

## Development

- Install Docker.
- Make sure [`docker` is accessible without sudo](https://askubuntu.com/a/477554).
- Clone this repository.
- `rails db:seed` to seed the database.
- `./start.sh` to start the local development server.
