# Docker Compose Commands Cheatsheet

## Basic Commands

### Start all services
```bash
docker-compose up
```

### Start in detached mode (background)
```bash
docker-compose up -d
```

### Build and start services
```bash
docker-compose up --build
```

### Stop all services
```bash
docker-compose down
```

### Stop and remove volumes
```bash
docker-compose down -v
```

### View logs
```bash
docker-compose logs

# Follow logs
docker-compose logs -f

# Logs for specific service
docker-compose logs java-app
docker-compose logs -f nginx
```

### List running services
```bash
docker-compose ps
```

### Restart services
```bash
docker-compose restart

# Restart specific service
docker-compose restart java-app
```

### Stop services (without removing)
```bash
docker-compose stop
```

### Start stopped services
```bash
docker-compose start
```

### Execute command in running container
```bash
docker-compose exec java-app sh
docker-compose exec postgres psql -U appuser -d appdb
docker-compose exec redis redis-cli
```

### View resource usage
```bash
docker-compose top
```

### Scale services
```bash
docker-compose up -d --scale java-app=3
```

### Validate docker-compose.yml
```bash
docker-compose config
```

### Pull latest images
```bash
docker-compose pull
```

### Build services
```bash
docker-compose build

# Build without cache
docker-compose build --no-cache
```

### Remove stopped containers
```bash
docker-compose rm
```

## Access the Application

After running `docker-compose up`:

- **Via Nginx (Port 80)**: http://localhost
- **Direct to Java App (Port 8080)**: http://localhost:8080
- **Nginx Health**: http://localhost/nginx-health
- **Java App Health**: http://localhost:8080/health
- **PostgreSQL**: localhost:5432 (user: appuser, password: apppassword, db: appdb)
- **Redis**: localhost:6379

## Service Architecture

```
┌─────────────┐
│   Client    │
└──────┬──────┘
       │
       │ Port 80
       ▼
┌─────────────┐
│    Nginx    │ (Reverse Proxy)
└──────┬──────┘
       │
       │ Port 8080
       ▼
┌─────────────┐
│  Java App   │
└──────┬──────┘
       │
       ├─────────────┬─────────────┐
       │             │             │
       ▼             ▼             ▼
  ┌────────┐   ┌──────────┐  ┌────────┐
  │  Redis │   │ Postgres │  │ Network│
  └────────┘   └──────────┘  └────────┘
```

## Troubleshooting

### View service status
```bash
docker-compose ps
```

### Check logs for errors
```bash
docker-compose logs --tail=50
```

### Restart a problematic service
```bash
docker-compose restart java-app
```

### Rebuild a specific service
```bash
docker-compose up -d --build java-app
```

### Remove everything and start fresh
```bash
docker-compose down -v
docker-compose up --build
```

## Environment Variables

Override environment variables:
```bash
ENVIRONMENT=development docker-compose up
```

Or create a `.env` file in the same directory.

## Tips

- Use `docker-compose up -d` for background execution
- Use `docker-compose logs -f` to follow logs in real-time
- Use `docker-compose down -v` to clean up volumes
- Check `docker-compose config` to validate your YAML file
- Use `docker-compose exec` instead of `docker exec` for simplicity
