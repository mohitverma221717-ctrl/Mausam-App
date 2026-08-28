# 🔒 Security & Hardening Architecture

---

## 1. Authentication & Session Security
- **Short-Lived Access Tokens**: Signed with `JWT_SECRET` and set to a 15-minute expiration window.
- **Long-Lived Refresh Tokens**: Stored hashed (SHA-256) in PostgreSQL.
- **Refresh Token Rotation & Family IDs**: Every refresh request invalidates the previous refresh token and issues a new token pair within the same token family.
- **Token Reuse Attack Detection**: If a revoked refresh token is presented, the server immediately revokes all tokens within that family, invalidating all sessions for that compromised user.
- **Password Hashing**: Uses bcrypt with 12 salt rounds (or Argon2).

---

## 2. API & Network Protection
- **Helmet**: Sets HTTP security headers (CSP, HSTS, X-Content-Type-Options, X-Frame-Options).
- **CORS**: Configurable origin whitelisting via `CORS_ORIGIN`.
- **Redis Rate Limiting**: Distributed rate limiter protecting public endpoints (`/api/v1/*`) and authentication endpoints (`/auth/login`, `/auth/register`).
- **Request Tracing**: Unique `X-Request-Id` (UUID v4) generated for every incoming request.

---

## 3. Data Protection & Secrets Handling
- **Structured Pino Logger Redaction**: Automatically scrubs passwords, authorization headers, refresh tokens, API keys, and Firebase private keys from all logs.
- **Parameter Validation**: Every input is strictly validated against Zod schemas before reaching business logic.
- **SQL Injection Prevention**: Prisma ORM executes parameterized queries for 100% of database interactions.
- **Non-Root Docker Containers**: Production containers run under an unprivileged `nodejs` user.
