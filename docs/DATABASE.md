# 🐘 Database Architecture & Schema Documentation

The Mausam Backend uses **PostgreSQL 16** managed through **Prisma ORM**.

---

## 1. Schema Modules & Tables

### A. Authentication & Access Control
- `users`: Core account record, password hashes, verification state.
- `roles`: RBAC roles (`USER`, `ADMIN`, `SUPER_ADMIN`).
- `permissions`: Fine-grained permission strings (`weather:view`, `alert:create`, etc.).
- `user_roles` & `role_permissions`: Join tables with cascading constraints.
- `refresh_tokens`: Token rotation hashes, family IDs (with reuse attack detection).
- `login_sessions`: Device session tracking, IP addresses, and user agents.
- `device_tokens`: FCM tokens registered by the Flutter mobile application.

### B. User Profiles & Locations
- `user_profiles`: Persona assignment, full name, avatar, bio, date of birth.
- `user_preferences`: Unit preferences (°C/°F, km/h), notification flags, UI theme.
- `user_interests`: Custom interest tags with priority ratings.
- `locations`: Spatial reference table for cities and official IMD meteorological stations (lat, lon, elevation, station code).
- `saved_locations` & `favorite_locations`: User customized location bookmarks.

### C. Meteorological & Environmental Observations
- `weather_observations`: Real-time weather readings (temperature, feels-like, wind, rain, pressure, condition code).
- `weather_forecasts`: Forecast parent record grouped by location and date.
- `hourly_forecasts`: 24-hour detailed steps.
- `daily_forecasts`: 7-day extended outlook.
- `aqi_observations`: Indian AQI values, categories, and sub-pollutant concentrations (PM2.5, PM10, O3, NO2, SO2, CO).
- `uv_observations`: UV index levels and exposure classifications.
- `pollen_observations`: Grass, Tree, Weed, and Olive pollen counts.
- `visibility_observations`: Visibility range and fog risk flags.

### D. Personalization & Recommendations
- `personalization_profiles`: Dynamic score multipliers per user.
- `homepage_cards`: Card definitions, default priority, and configuration schemas.
- `card_priorities`: Matrix mapping personas to base card priority scores.
- `recommendations` & `recommendation_histories`: Actionable suggestions and interaction tracking.

### E. Domain Modules
- `farms` & `soil_observations` & `farming_advisories`: Agriculture domain.
- `marine_observations`: Coastal wave height, tide, and swimming safety.
- `trips` & `packing_recommendations`: Travel planning.
- `family_profiles` & `school_locations`: School weather tracking.
- `commute_routes`: Traffic & route fog hazard tracking.
- `outdoor_events`: Event thermal comfort forecasts.

### F. Alerts, Notifications & System Admin
- `alerts`, `alert_rules`, `alert_targets`: Severe weather warnings.
- `notifications` & `notification_deliveries`: User notification history and delivery statuses.
- `analytics_events`: Anonymous telemetry and app interaction analytics.
- `audit_logs` & `admin_actions`: Immutable audit trail of administrative modifications.
- `system_settings` & `data_source_statuses`: Global settings and third-party API health tracker.

---

## 2. Indexing Strategy
- Composite unique index on `Location(latitude, longitude)` for spatial query acceleration.
- B-Tree indexes on `User(email)`, `RefreshToken(tokenHash)`, `RefreshToken(familyId)`.
- Foreign key composite indexes on time-series records: `WeatherObservation(locationId, observationTime)`, `AQIObservation(locationId, observationTime)`.
- Index on `Alert(effectiveFrom, expiresAt)` for active warning feeds.
