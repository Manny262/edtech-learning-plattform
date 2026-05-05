# Docker Setup Guide: Django + Vue + PostgreSQL
A step-by-step guide for containerizing Django REST backend, Vue.js frontend, and PostgreSQL database in Development.

## 1. Backend - Django Dockerfile

1. use docker init:
```bash
    cd .\backend\ && 
    docker init
```
2. answer the following questions:
```bash
? What application platform does your project use? Python
? What version of Python do you want to use? (3.13.13) 3.14.2

? What version of Python do you want to use? 3.14.2
? What port do you want your app to listen on? (8000)

? What port do you want your app to listen on? 8000
? What is the command you use to run your app? (gunicorn 'test-edtech-learning-plattform.backend..venv.Lib.site-packages.asgiref.wsgi' --bind=0.0.0.0:8000) py manage.py runserver
```

## 2. Frontend - Vue Dockerfile:

1. Build a dockerfile in the "frontend" folder:
**`frontend/Dockerfile`**

```dockerfile 
    FROM node:22.13.0-alpine

    WORKDIR /app

    COPY package*.json ./
    RUN npm ci
    EXPOSE 5173
    CMD ["npm", "run", "dev", "--", "--host"]
```
2. enable polling in vite.config.js:
```JavaScript
    server: {
        watch: {
            usePolling: true,
            },..
    }
```
## 3. Configure Docker Compose:

1. Go to the project directory
2. Create a compose file:
```yaml
services:
  db:
    image: postgres:18.2
    restart: always
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    env_file: .env
    volumes:
        - postgres_data:/var/lib/postgresql
    ports:
      - "5433:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $POSTGRES_USER -d $POSTGRES_DB"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build:
      context: ./backend
    env_file: .env
    environment:
      DB_HOST: db
      DB_PORT: 5432
    depends_on:
      db:
        condition: service_healthy
    volumes:
      - ./backend:/app
    command: sh -c "python manage.py migrate  &&  
                    python manage.py runserver 0.0.0.0:8000"
    ports:
      - 8000:8000
  frontend:
    build:
      context: ./frontend
    environment:
      VITE_API_URL: http://backend:8000
    volumes:
      - ./frontend:/app
      - /app/node_modules
    ports:
      - "5173:5173"
    depends_on:
      - backend
volumes:
  postgres_data:
```

## Quick Reference

```
docker compose up --build          # start everything
docker compose down                # stop and remove containers
docker compose down -v             # also remove volumes (deletes DB data!)
docker compose exec backend bash   # shell into Django container
docker compose exec db psql -U myuser -d mydb  # PostgreSQL prompt
docker compose logs -f backend     # tail Django logs
```