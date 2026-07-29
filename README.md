# hack4goodsgf.com

Custom WordPress image for hack4goodsgf.com.

The image extends the Docker Official WordPress Apache image with:

- The PhpRedis extension required by the Redis Object Cache plugin.
- PHP upload and execution limits suitable for the initial backup-plugin restore.
- A static `/healthz.html` endpoint for Kubernetes probes.

Plugins, themes, and uploads are intentionally not baked into the image during the
initial migration. Kubernetes persists `wp-content` so the existing site backup can
restore those files. Once the migration is stable, plugins and themes can move into
the image while uploads move to S3-compatible object storage.

## Build

```bash
docker build -t hack4goodsgf.com .
docker run --rm hack4goodsgf.com php -m
```

## Publishing

Conventional commits merged to `main` create semantic version tags and GitHub
Releases. Each release publishes native AMD64 and ARM64 images to GHCR and creates
multi-architecture tags:

- `ghcr.io/sgfdevs/hack4goodsgf.com:<version>`
- `ghcr.io/sgfdevs/hack4goodsgf.com:latest`

The version tag is intended for the future image-tag update workflow.
