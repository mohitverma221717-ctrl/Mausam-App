# 🚀 Production Deployment Guide

---

## 1. Local Development Quickstart

```bash
# 1. Boot PostgreSQL & Redis
docker compose up -d

# 2. Install dependencies
npm install

# 3. Setup Database & Seed Data
npx prisma generate
npx prisma migrate dev --name init
npm run prisma:seed

# 4. Start Hot-Reload Dev Server
npm run dev
```

---

## 2. Production Docker Deployment

```bash
# 1. Build and run production stack with Docker Compose
docker compose -f docker-compose.prod.yml up -d --build

# 2. Run migrations in container
docker compose -f docker-compose.prod.yml exec app npx prisma migrate deploy

# 3. Verify health
curl -f http://localhost:5000/api/v1/health
```

---

## 3. Production Environment Checklist

Ensure the following variables in `.env` are configured with production values:
- `NODE_ENV=production`
- `DATABASE_URL` (Point to managed PostgreSQL instance, e.g. AWS RDS or Supabase)
- `REDIS_URL` (Point to managed Redis instance, e.g. AWS ElastiCache or Upstash)
- `JWT_SECRET` (Minimum 32 random characters)
- `JWT_REFRESH_SECRET` (Minimum 32 random characters)
- `CORS_ORIGIN` (Your mobile app bundle IDs or admin web domain)
- `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`
