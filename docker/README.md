## Docker Deployment

This directory contains the Docker Compose deployment stack for Dify.

### Source of Truth

- Application env variables come from:
  - `api/docs/backend-env.reference.json`
  - `web/docs/frontend-env.reference.json`
- `.env.example` is generated from those two references and only includes variables explicitly marked as required for deployment.
- Most application settings are intentionally omitted from `.env.example` because backend/frontend code defaults already exist.
- Docker-only orchestration settings live under `compose-source/`.
- `docker-compose.yaml` and `docker-compose.middleware.yaml` are generated from:
  - `docker-compose-template.yaml`
  - `compose-source/shared-docker-services.template.yaml`
  - `compose-source/docker-compose.middleware.template.yaml`

### Generated Artifacts

Run `./generate_docker_compose` to regenerate all generated deployment files:

- `.env.example`
- `middleware.env.example`
- `docker-compose.yaml`
- `docker-compose.middleware.yaml`

The generator entrypoint is [render_deployment_configs.py](./render_deployment_configs.py).

### Main Deployment

1. Ensure Docker and Docker Compose are installed.
1. Regenerate deployment artifacts after changing env reference sources, compose templates, or `compose-source/` inputs:

   ```bash
   ./generate_docker_compose
   ```

1. Create your local env file:

   ```bash
   cp .env.example .env
   ```

1. Fill in the required values in `.env`.
1. Start the full stack:

   ```bash
   docker compose up -d
   ```

### Middleware for Local Source Development

`docker-compose.middleware.yaml` is for running database, cache, sandbox, plugin daemon, and bundled middleware services while developing `api/` and `web/` locally.

1. Regenerate deployment artifacts:

   ```bash
   ./generate_docker_compose
   ```

1. Create the middleware env file:

   ```bash
   cp middleware.env.example middleware.env
   ```

1. Override any middleware-specific Docker settings you need in `middleware.env`.
1. Start middleware services:

   ```bash
   docker compose --env-file middleware.env -f docker-compose.middleware.yaml -p dify up -d
   ```

### Why `.env.example` Is Small

- `.env.example` is no longer a full dump of every supported environment variable.
- It only contains values that are marked as required in the backend/frontend env references.
- If a variable is absent from `.env.example`, Docker deployment should rely on code defaults, Compose defaults, or middleware-only defaults.
- This keeps first-time deployment simpler and reduces drift between docs and shipped examples.

### Keeping `.env` Updated

Use `./dify-env-sync.sh` to merge newly added keys from `.env.example` into your local `.env` without overwriting existing values.

What it does:

- Backs up the current `.env` into `env-backup/`
- Adds newly introduced keys from `.env.example`
- Preserves existing custom values
- Shows removed or changed keys for review

Typical workflow after an upgrade:

```bash
./generate_docker_compose
./dify-env-sync.sh
```

### Validation

Validate generated configuration before committing changes:

```bash
python3 render_deployment_configs.py --check
docker compose -f docker-compose.yaml --env-file .env config
docker compose -f docker-compose.middleware.yaml --env-file middleware.env config
```

### Notes

- Do not edit `docker-compose.yaml`, `docker-compose.middleware.yaml`, `.env.example`, or `middleware.env.example` by hand.
- Update app env metadata in the backend/frontend env reference sources, then regenerate.
- Update Docker-only defaults or shared service fragments in `compose-source/`, then regenerate.
- Certbot-specific usage remains documented in `certbot/README.md`.
