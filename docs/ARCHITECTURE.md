# Architecture Documentation: Mausam Backend

## 1. System Architecture

```
                                  ┌────────────────────────┐
                                  │   Flutter Mobile App   │
                                  └───────────┬────────────┘
                                              │
                                  ┌───────────▼────────────┐
                                  │    Admin Web Panel     │
                                  └───────────┬────────────┘
                                              │
                                              ▼
                                 [ REST API: /api/v1/* ]
                                              │
                                 ┌────────────▼───────────┐
                                 │     Express Engine     │
                                 │  - Request ID (UUID)   │
                                 │  - Helmet & CORS       │
                                 │  - Redis Rate Limiter  │
                                 │  - Zod Validation      │
                                 └────────────┬───────────┘
                                              │
                    ┌─────────────────────────┼─────────────────────────┐
                    ▼                         ▼                         ▼
         ┌────────────────────┐    ┌────────────────────┐    ┌────────────────────┐
         │ Core & Domain Svc  │    │  Engines / Logic   │    │ Background Workers │
         │ - Auth & RBAC      │    │ - Personalization  │    │ - BullMQ + Redis   │
         │ - Weather & AQI    │    │ - Card Priority    │    │ - IMD Sync         │
         │ - Marine & Agri    │    │ - Recommendations  │    │ - Push (FCM)       │
         │ - Commute & Health │    │ - Alert Evaluator  │    │ - Cron Jobs        │
         └──────────┬─────────┘    └──────────┬─────────┘    └──────────┬─────────┘
                    │                         │                         │
                    └─────────────────────────┼─────────────────────────┘
                                              │
                                 ┌────────────▼───────────┐
                                 │       Prisma ORM       │
                                 └────────────┬───────────┘
                                              │
                                 ┌────────────┴───────────┐
                                 ▼                        ▼
                      ┌────────────────────┐   ┌────────────────────┐
                      │   PostgreSQL 16    │   │      Redis 7       │
                      │ (Relational Data)  │   │  (Cache & Queues)  │
                      └────────────────────┘   └────────────────────┘
```

## 2. Personalization Engine (Core USP)

The personalization engine ranks and filters homepage cards based on dynamic weights mapped to user personas and environmental severity triggers:

```
[ User Persona ]  +  [ Real-time Weather & AQI ]  +  [ Custom Preferences ]
                                │
                                ▼
                   [ Context Analyzer Engine ]
                                │
                                ▼
               [ Dynamic Score Weighting Matrix ]
         (e.g., AQI > 300 triggers Severe Alert card boost)
                                │
                                ▼
                 [ Priority-Sorted Homepage ]
             (Delivered as JSON array to Flutter)
```
