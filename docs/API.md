# 📡 REST API Reference

Base URL: `http://localhost:5000/api/v1`

---

## 1. Authentication (`/auth`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/auth/register` | `POST` | Register a new user | No |
| `/auth/login` | `POST` | Login with email/password (returns Access + Refresh tokens) | No |
| `/auth/refresh` | `POST` | Exchange refresh token for fresh access token (Token rotation) | No |
| `/auth/logout` | `POST` | Revoke active refresh token | No |
| `/auth/me` | `GET` | Get authenticated user info, roles, and profile | Yes (Bearer) |
| `/auth/change-password` | `POST` | Update account password | Yes (Bearer) |

---

## 2. Personalization & Homepage (`/home`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/home` | `GET` | Dynamic personalized homepage with ranked cards and recommendations | Optional (Personalized if Bearer token present) |

**Query Parameters**:
- `latitude` (optional): User current GPS latitude
- `longitude` (optional): User current GPS longitude
- `locationId` (optional): Specific saved location ID

---

## 3. Weather & Meteorological Data (`/weather`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/weather/current` | `GET` | Current temperature, humidity, pressure, condition, wind | No |
| `/weather/forecast` | `GET` | Complete 24h hourly + 7d daily weather forecast | No |
| `/weather/hourly` | `GET` | 24-hour hourly forecast timeline | No |
| `/weather/daily` | `GET` | 7-day extended forecast outlook | No |

---

## 4. Environment & Air Quality (`/environment`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/environment/report` | `GET` | Full environmental report (AQI, UV, Pollen, Visibility) | No |
| `/environment/aqi` | `GET` | Real-time Indian AQI, category, and sub-pollutants (PM2.5, PM10) | No |
| `/environment/uv` | `GET` | UV index and exposure advisories | No |
| `/environment/pollen` | `GET` | Pollen counts (Grass, Tree, Weed) and health warnings | No |
| `/environment/visibility` | `GET` | Visibility distance and fog risk indicator | No |

---

## 5. Actionable Recommendations (`/recommendations`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/recommendations` | `GET` | Persona-aware actionable advice (Rainwear, Best running time, Sunscreen) | Optional |
| `/recommendations/interact` | `POST` | Log user interaction (Viewed, Clicked, Actioned) | Yes |

---

## 6. Meteorological Alerts & Warnings (`/alerts`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/alerts/active` | `GET` | Get active severe weather warnings and advisories | No |
| `/alerts/:id` | `GET` | Get alert details by UUID | No |
| `/alerts` | `POST` | Publish a new meteorological alert | Yes (ADMIN / SUPER_ADMIN) |

---

## 7. User Profile & Preferences (`/users`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/users/profile` | `GET` | Get user profile and persona | Yes |
| `/users/profile` | `PATCH` | Update profile details (Name, Persona, Bio) | Yes |
| `/users/preferences` | `GET` | Get unit preferences (C/F, km/h) & notification toggles | Yes |
| `/users/preferences` | `PATCH` | Update preferences | Yes |
| `/users/interests` | `GET` | Get user interest tags | Yes |
| `/users/interests` | `POST` | Add/update interest tag | Yes |
| `/users/interests/:interest` | `DELETE` | Remove interest tag | Yes |

---

## 8. Locations (`/locations`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/locations/search` | `GET` | Search Indian cities and IMD weather stations | No |
| `/locations/nearby` | `GET` | Geospatial Haversine lookup of nearby stations | No |
| `/locations/user/saved` | `GET` | List user saved locations (Home, Work) | Yes |
| `/locations/user/saved` | `POST` | Save a location for quick access | Yes |
| `/locations/user/saved/:id` | `DELETE` | Remove a saved location | Yes |
| `/locations/user/favorites` | `GET` | List ordered favorite locations | Yes |
| `/locations/user/favorites` | `POST` | Add to favorites | Yes |

---

## 9. Domain-Specific Feeds (`/domains`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/domains/agriculture/farms` | `GET` / `POST` | Agro-meteorological farm records & advisories | Yes |
| `/domains/marine` | `GET` | Coastal marine conditions, wave height, swimming safety | No |
| `/domains/fitness` | `GET` | Outdoor fitness comfort score & running window | No |
| `/domains/travel/trips` | `GET` | Trips and packing recommendations | Yes |
| `/domains/family` | `GET` | School weather monitoring and family advisories | Yes |
| `/domains/commute` | `GET` | Commute route weather and fog warnings | Yes |
| `/domains/events` | `GET` | Outdoor event suitability analysis | Yes |

---

## 10. Admin Web APIs (`/admin`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/admin/dashboard` | `GET` | Master analytics overview, data source health, audit logs | Yes (ADMIN) |
| `/admin/users` | `GET` | Paginated user management table | Yes (ADMIN) |
| `/admin/personalization/rules` | `GET` | Inspect personalization rules and card weights | Yes (ADMIN) |
| `/admin/personalization/card-priority` | `PUT` | Tune persona card weights in real-time | Yes (ADMIN) |
| `/admin/system/settings` | `GET` / `PUT` | Configure system sync intervals and fallback settings | Yes (ADMIN) |

---

## 11. Push Notifications & Devices (`/notifications`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/notifications` | `GET` | Get notification history | Yes |
| `/notifications/device-token` | `POST` | Register FCM push device token from Flutter | Yes |
| `/notifications/:id/read` | `PATCH` | Mark notification as read | Yes |
| `/notifications/read-all` | `PATCH` | Mark all notifications as read | Yes |

---

## 12. Analytics Telemetry (`/analytics`)

| Endpoint | Method | Description | Auth Required |
|---|---|---|---|
| `/analytics/events` | `POST` | Ingest user interaction events (Card clicks, App open) | Optional |
| `/analytics/summary` | `GET` | Aggregate event counts | Yes (ADMIN) |
