# THIS IMAGE IS DEPRECATED

Hello!

I haven't used CloudLog in a while now. For this reason, I'm going to deprecate this Docker image. Please update accordingly.

If you've been happy with this image, feel free to fork or clone this repo and make it yours. It only needs a little bit of adjustment. See the instructions below.

See you on the bands,

73 DF5EX

## Final Version supported: 2.8.10

[Published 27 March 2026](https://github.com/magicbug/Cloudlog/releases/tag/2.8.10)

## How to keep using the image

#### Step 1) Shut down your stack with

```sh
docker compose down
```

#### Step 2) Download the 'Dockerfile'

Place the downloaded file in the same folder as your Docker Compose file

#### Step 3) Edit the Docker Compose File as follows

Replace:

```yaml
services:
  cloudlog-main:
    image: jk13xyz/cloudlog:latest
```

With:

```yaml
services:
  cloudlog-main:
    build:
      context: .
      dockerfile: Dockerfile
```

#### Step 4) Run the following command to restart the stack:

```sh
docker compose build --pull --no-cache
docker compose up -d
```

This builds the Cloudlog image and fully restarts the stack, as defined in your Compose file.

## In case of Updates

When the CloudLog team publishes an update, all you need to do is open the Dockerfile and edit this line at the top:

```Dockerfile
ARG VERSION=2.8.10
```

This variable defines the version you want to use. Simply enter the version number, as indicated on the CloudLog GitHub repository.

Then once more rerun:

```sh
docker compose build --pull --no-cache
docker compose up -d
```

## Forking the repo and using CI/GitHub Actions

You can also fork the repo and push it to Docker Hub and largely automate it. You'd still need to edit the version number and push the change to the repo. I haven't gotten around testing and trying to push on release. Either way, the workflow file (.github/workflows/ci.yml) should be part of a fork and works fine for what it does. All you'd need to do is get a Docker account and set up the following secrets in the repo settings:

```
DOCKER_USERNAME
DOCKER_PASSWORD
```
