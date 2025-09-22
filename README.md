Frappe Docker with App Manager

A minimal setup to run Frappe/ERPNext in Docker with simple app management via `apps.json`.

Requirements
- Docker 24+
- Docker Compose V2

Quick start
```bash
# build images
./build.sh

# start the stack
docker compose up -d

# view logs
docker compose logs -f
```

Apps management
- Define apps and branches in `apps.json`.
- Rebuild and restart after changes:
```bash
./build.sh && docker compose up -d
```

Update apps
```bash
scripts/check-app-updates.sh
```

Files
- compose.yml: services and volumes
- Dockerfile: image build for bench/site
- apps.json: list of apps to include
- resources/: nginx template and entrypoint
- scripts/: helper scripts
- build.sh: build convenience script

Common commands
```bash
# open bench container shell
docker compose exec backend bash

# list running containers
docker compose ps

# stop and remove
docker compose down
```

Notes
- Data persists in Docker volumes defined in `compose.yml`.
- On first run, a default site is created during build.
