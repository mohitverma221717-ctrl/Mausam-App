# 🧠 Personalization Engine Architecture (Core USP)

> **SIH Hackathon Problem Statement 26076**  
> **Topic**: Personalized Homepage for IMD "Mausam" Mobile Application

---

## 1. Core Philosophy

Traditional weather apps display a static, one-size-fits-all screen with temperature and a basic 7-day forecast. However, a farmer cares most about soil moisture and rain probabilities, an asthmatic patient cares about AQI and pollen spikes, and a morning runner cares about humidity and temperature windows.

The **Mausam Personalization Engine** dynamically calculates a personalized layout of homepage cards using a multi-factor weighting algorithm:

$$\text{Final Card Score} = \text{Base Persona Score} + \text{Environmental Situation Boosts} + \text{User Custom Adjustments}$$

---

## 2. Supported User Personas

| Persona | Primary Focus | Top Prioritized Cards |
|---|---|---|
| `HEALTH_CONSCIOUS` | Air Quality, Pollen, Respiratory Warnings | Air Quality Index, Pollen Report, Health Advisories |
| `OUTDOOR_FITNESS` | Optimal Workout Windows, UV, Wind | Workout Running Windows, Hourly Forecast, Air Quality |
| `AGRICULTURE_FARMER` | Rainfall, Soil Moisture, Crop Protection | Agro-Meteorology, Extended Forecast, Actionable Advice |
| `BEACH_SURFER` | Wave Height, Tides, Sea State | Marine & Coastal, UV Index, Wind Direction |
| `TRAVELER` | Destination Forecasts, Packing Lists | Travel & Packing Planner, 7-Day Forecast |
| `PARENT_FAMILY` | School Weather Advisories, Extreme Temp | School Weather Advisory, Air Quality, Daily Briefing |
| `COMMUTER` | Fog Alerts, Rain Timing, Visibility | Commute Weather & Fog Routing, Hourly Forecast |
| `EVENT_PLANNER` | Precipitation Risk, Thermal Comfort | Outdoor Events Suitability, Hourly Timeline |
| `GENERAL` | Balanced Overview | Current Conditions, Hourly, Daily Forecast, AQI |

---

## 3. Dynamic Environmental Situation Boosts

Even if a user is in the `GENERAL` persona, severe meteorological triggers will dynamically elevate critical cards to the top:

```
Trigger Condition                 Card Boosted              Priority Addition
─────────────────────────────────────────────────────────────────────────────
AQI > 200 (Severe Air Quality)    AIR_QUALITY               +40 Points
                                  HEALTH_ADVISORY           +30 Points
                                  SEVERE_ALERTS             +50 Points

Rain Probability >= 50%           HOURLY_FORECAST           +25 Points
                                  RECOMMENDATIONS (Umbrella)+35 Points

UV Index >= 8 (Extreme UV)        UV_INDEX                  +30 Points

Visibility < 2km (Dense Fog)      COMMUTE_ROUTING           +40 Points

Active Meteorological Warnings    SEVERE_ALERTS             Fixed Top (150 Pts)
```

---

## 4. Admin Dynamic Tuning

Administrators can tune persona base priorities and weight multipliers in real-time via the Admin Web API (`PUT /api/v1/admin/personalization/card-priority`) without requiring mobile app updates or server restarts.
