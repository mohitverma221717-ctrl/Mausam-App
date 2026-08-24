# 🌦️ Mausam Backend

> **SIH Hackathon Project (Problem Statement ID: 26076)**  
> **Title**: Development of Personalized Homepage for "Mausam" Mobile Application  
> **Organization**: Ministry of Earth Sciences (MoES) / India Meteorological Department (IMD)

---

## 🏛️ Architecture Overview

The **Mausam Backend** is a production-grade, modular monolith built with:
- **Runtime**: Node.js & TypeScript (Strict Mode)
- **Framework**: Express.js
- **Database & ORM**: PostgreSQL 16 with Prisma ORM
- **In-Memory Cache & Queues**: Redis 7 with ioredis & BullMQ
- **Observability & Logging**: Structured Pino logging with request correlation IDs
- **Security**: Helmet, CORS, Rate Limiter (Redis-backed), Zod validation, JWT with refresh token rotation

---

## 🚀 Quick Start (Development)

### 1. Prerequisites
- **Node.js**: v20+ or v24+
- **Docker & Docker Compose**: (for PostgreSQL & Redis)

### 2. Install Dependencies
```bash
npm install
```

### 3. Start Database & Redis (Docker)
```bash
docker compose up -d
```

### 4. Setup Prisma & Seed Database
```bash
npx prisma generate
npx prisma migrate dev --name init
npm run prisma:seed
```

### 5. Start Development Server
```bash
npm run dev
```

The server will start on `http://localhost:5000`.

---

## 🔍 System Verification & Endpoints

| Endpoint | Method | Description |
|---|---|---|
| `/` | `GET` | API Information & Subsystem status |
| `/api/v1/health` | `GET` | Health check (PostgreSQL + Redis connectivity, Memory & Uptime) |
| `/api/v1/ping` | `GET` | Lightweight liveness probe |

---

## 🏗️ Project Structure

```
src/
├── app.ts                  # Express application setup
├── server.ts               # Server lifecycle & graceful shutdown
├── config/                 # Environment, DB, Redis, Logger configs
├── core/                   # Middlewares, Error handling, Security & Utilities
├── modules/                # Domain modules (System, Auth, Weather, etc.)
├── integrations/           # External API adapters (IMD, Open-Meteo, CPCB)
├── jobs/                   # Periodic sync jobs
├── queues/                 # BullMQ queue definitions
└── routes/                 # API v1 master routes
prisma/
├── schema.prisma           # Complete normalized schema (28+ models)
└── seed.ts                 # Database seeder (Roles, Admin, Cities, Card Priorities)
```
