-- CreateEnum
CREATE TYPE "UserRoleType" AS ENUM ('USER', 'ADMIN', 'SUPER_ADMIN');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'PENDING_VERIFICATION');

-- CreateEnum
CREATE TYPE "PersonaType" AS ENUM ('GENERAL', 'HEALTH_CONSCIOUS', 'OUTDOOR_FITNESS', 'BEACH_SURFER', 'TRAVELER', 'PARENT_FAMILY', 'AGRICULTURE_FARMER', 'COMMUTER', 'EVENT_PLANNER');

-- CreateEnum
CREATE TYPE "WeatherCondition" AS ENUM ('CLEAR', 'PARTLY_CLOUDY', 'CLOUDY', 'OVERCAST', 'FOG', 'DRIZZLE', 'RAIN', 'HEAVY_RAIN', 'THUNDERSTORM', 'SNOW', 'HAIL', 'DUST_STORM', 'CYCLONE');

-- CreateEnum
CREATE TYPE "AQICategory" AS ENUM ('GOOD', 'SATISFACTORY', 'MODERATE', 'POOR', 'VERY_POOR', 'SEVERE');

-- CreateEnum
CREATE TYPE "UVCategory" AS ENUM ('LOW', 'MODERATE', 'HIGH', 'VERY_HIGH', 'EXTREME');

-- CreateEnum
CREATE TYPE "PollenLevel" AS ENUM ('LOW', 'MODERATE', 'HIGH', 'VERY_HIGH');

-- CreateEnum
CREATE TYPE "CardType" AS ENUM ('CURRENT_WEATHER', 'HOURLY_FORECAST', 'DAILY_FORECAST', 'AIR_QUALITY', 'UV_INDEX', 'POLLEN_REPORT', 'HEALTH_ADVISORY', 'FITNESS_RUNNING_WINDOW', 'TRAVEL_PLANNER', 'FAMILY_SCHOOL_ADVISORY', 'FARM_AGRICULTURE', 'MARINE_COASTAL', 'COMMUTE_ROUTING', 'OUTDOOR_EVENTS', 'SEVERE_ALERTS', 'RECOMMENDATIONS');

-- CreateEnum
CREATE TYPE "AlertSeverity" AS ENUM ('INFO', 'WATCH', 'ADVISORY', 'WARNING', 'EMERGENCY');

-- CreateEnum
CREATE TYPE "AlertCategory" AS ENUM ('METEOROLOGICAL', 'AIR_QUALITY', 'HYDROLOGICAL', 'MARINE', 'GEOPHYSICAL', 'PUBLIC_SAFETY');

-- CreateEnum
CREATE TYPE "RecommendationSeverity" AS ENUM ('INFO', 'SUGGESTION', 'CAUTION', 'CRITICAL');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('WEATHER_ALERT', 'AQI_WARNING', 'DAILY_FORECAST', 'RAIN_WARNING', 'OUTDOOR_RECOMMENDATION', 'ADMIN_BROADCAST', 'SYSTEM_UPDATE');

-- CreateEnum
CREATE TYPE "DeliveryStatus" AS ENUM ('PENDING', 'SENT', 'DELIVERED', 'FAILED', 'SKIPPED');

-- CreateEnum
CREATE TYPE "DataSourceState" AS ENUM ('HEALTHY', 'DEGRADED', 'DOWN', 'MAINTENANCE');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "phoneNumber" TEXT,
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "status" "UserStatus" NOT NULL DEFAULT 'ACTIVE',
    "lastLoginAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" TEXT NOT NULL,
    "name" "UserRoleType" NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permissions" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "module" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_roles" (
    "userId" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("userId","roleId")
);

-- CreateTable
CREATE TABLE "role_permissions" (
    "roleId" TEXT NOT NULL,
    "permissionId" TEXT NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("roleId","permissionId")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" TEXT NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "familyId" TEXT NOT NULL,
    "isRevoked" BOOLEAN NOT NULL DEFAULT false,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "login_sessions" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "deviceType" TEXT,
    "lastActiveAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "login_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "device_tokens" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "device_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_profiles" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "fullName" TEXT,
    "avatarUrl" TEXT,
    "bio" TEXT,
    "dateOfBirth" TIMESTAMP(3),
    "gender" TEXT,
    "persona" "PersonaType" NOT NULL DEFAULT 'GENERAL',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_preferences" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tempUnit" TEXT NOT NULL DEFAULT 'C',
    "windSpeedUnit" TEXT NOT NULL DEFAULT 'km/h',
    "pressureUnit" TEXT NOT NULL DEFAULT 'hPa',
    "theme" TEXT NOT NULL DEFAULT 'system',
    "language" TEXT NOT NULL DEFAULT 'en',
    "notifyWeatherAlerts" BOOLEAN NOT NULL DEFAULT true,
    "notifyDailySummary" BOOLEAN NOT NULL DEFAULT true,
    "notifyAqiWarnings" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_preferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_interests" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "interest" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 5,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_interests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "locations" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "state" TEXT,
    "district" TEXT,
    "country" TEXT NOT NULL DEFAULT 'India',
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "elevation" DOUBLE PRECISION,
    "timezone" TEXT NOT NULL DEFAULT 'Asia/Kolkata',
    "geohash" TEXT,
    "isOfficialStation" BOOLEAN NOT NULL DEFAULT false,
    "stationCode" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "saved_locations" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "customName" TEXT,
    "isHome" BOOLEAN NOT NULL DEFAULT false,
    "isWork" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "saved_locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "favorite_locations" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "favorite_locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "weather_observations" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "observationTime" TIMESTAMP(3) NOT NULL,
    "temperature" DOUBLE PRECISION NOT NULL,
    "feelsLike" DOUBLE PRECISION NOT NULL,
    "minTemp" DOUBLE PRECISION,
    "maxTemp" DOUBLE PRECISION,
    "humidity" DOUBLE PRECISION NOT NULL,
    "pressure" DOUBLE PRECISION NOT NULL,
    "windSpeed" DOUBLE PRECISION NOT NULL,
    "windDirection" DOUBLE PRECISION NOT NULL,
    "windGust" DOUBLE PRECISION,
    "precipitation" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "precipitationProb" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "cloudCover" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "uvIndex" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "visibility" DOUBLE PRECISION NOT NULL DEFAULT 10.0,
    "condition" "WeatherCondition" NOT NULL DEFAULT 'CLEAR',
    "conditionCode" INTEGER NOT NULL DEFAULT 800,
    "iconCode" TEXT NOT NULL DEFAULT '01d',
    "dataSource" TEXT NOT NULL DEFAULT 'IMD',
    "isMock" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "weather_observations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "weather_forecasts" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "forecastDate" TIMESTAMP(3) NOT NULL,
    "dataSource" TEXT NOT NULL DEFAULT 'IMD',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "weather_forecasts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hourly_forecasts" (
    "id" TEXT NOT NULL,
    "forecastId" TEXT NOT NULL,
    "time" TIMESTAMP(3) NOT NULL,
    "temperature" DOUBLE PRECISION NOT NULL,
    "feelsLike" DOUBLE PRECISION NOT NULL,
    "humidity" DOUBLE PRECISION NOT NULL,
    "precipitationProb" DOUBLE PRECISION NOT NULL,
    "precipitation" DOUBLE PRECISION NOT NULL,
    "windSpeed" DOUBLE PRECISION NOT NULL,
    "windDirection" DOUBLE PRECISION NOT NULL,
    "condition" "WeatherCondition" NOT NULL,
    "iconCode" TEXT NOT NULL,
    "uvIndex" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "hourly_forecasts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "daily_forecasts" (
    "id" TEXT NOT NULL,
    "forecastId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "minTemp" DOUBLE PRECISION NOT NULL,
    "maxTemp" DOUBLE PRECISION NOT NULL,
    "condition" "WeatherCondition" NOT NULL,
    "precipitationProb" DOUBLE PRECISION NOT NULL,
    "precipitationSum" DOUBLE PRECISION NOT NULL,
    "sunrise" TIMESTAMP(3),
    "sunset" TIMESTAMP(3),
    "uvMax" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "windMax" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "daily_forecasts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sunrise_sunsets" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "sunrise" TIMESTAMP(3) NOT NULL,
    "sunset" TIMESTAMP(3) NOT NULL,
    "solarNoon" TIMESTAMP(3),
    "dayLengthSeconds" INTEGER,
    "dawn" TIMESTAMP(3),
    "dusk" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sunrise_sunsets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "aqi_observations" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "observationTime" TIMESTAMP(3) NOT NULL,
    "aqi" INTEGER NOT NULL,
    "category" "AQICategory" NOT NULL,
    "pm25" DOUBLE PRECISION,
    "pm10" DOUBLE PRECISION,
    "o3" DOUBLE PRECISION,
    "no2" DOUBLE PRECISION,
    "so2" DOUBLE PRECISION,
    "co" DOUBLE PRECISION,
    "dominantPollutant" TEXT,
    "healthAdvisory" TEXT,
    "dataSource" TEXT NOT NULL DEFAULT 'CPCB_IMD',
    "isMock" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "aqi_observations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "uv_observations" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "observationTime" TIMESTAMP(3) NOT NULL,
    "uvIndex" DOUBLE PRECISION NOT NULL,
    "maxUvIndex" DOUBLE PRECISION,
    "category" "UVCategory" NOT NULL,
    "exposureAdvisory" TEXT,
    "dataSource" TEXT NOT NULL DEFAULT 'IMD',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "uv_observations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pollen_observations" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "observationTime" TIMESTAMP(3) NOT NULL,
    "grassPollen" DOUBLE PRECISION,
    "treePollen" DOUBLE PRECISION,
    "weedPollen" DOUBLE PRECISION,
    "olivePollen" DOUBLE PRECISION,
    "overallCategory" "PollenLevel" NOT NULL DEFAULT 'LOW',
    "advisory" TEXT,
    "dataSource" TEXT NOT NULL DEFAULT 'OPEN_METEO',
    "isMock" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pollen_observations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "visibility_observations" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "observationTime" TIMESTAMP(3) NOT NULL,
    "visibilityKm" DOUBLE PRECISION NOT NULL,
    "category" TEXT NOT NULL,
    "fogRisk" BOOLEAN NOT NULL DEFAULT false,
    "dataSource" TEXT NOT NULL DEFAULT 'IMD',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "visibility_observations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "personalization_profiles" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "personaType" "PersonaType" NOT NULL DEFAULT 'GENERAL',
    "dynamicScoreWeights" JSONB,
    "lastEvaluatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "personalization_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "personalization_rules" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "targetPersona" "PersonaType",
    "conditionExpression" TEXT NOT NULL,
    "cardType" "CardType" NOT NULL,
    "priorityScore" INTEGER NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "personalization_rules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "homepage_cards" (
    "id" TEXT NOT NULL,
    "cardType" "CardType" NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "defaultPriority" INTEGER NOT NULL DEFAULT 10,
    "isEnabled" BOOLEAN NOT NULL DEFAULT true,
    "configSchema" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "homepage_cards_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "card_priorities" (
    "id" TEXT NOT NULL,
    "personaType" "PersonaType" NOT NULL,
    "cardType" "CardType" NOT NULL,
    "basePriority" INTEGER NOT NULL,
    "weightMultiplier" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "card_priorities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_card_preferences" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "cardType" "CardType" NOT NULL,
    "isHidden" BOOLEAN NOT NULL DEFAULT false,
    "customOrder" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_card_preferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "personalization_events" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "eventType" TEXT NOT NULL,
    "cardType" "CardType" NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "personalization_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recommendations" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "severity" "RecommendationSeverity" NOT NULL DEFAULT 'INFO',
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "validFrom" TIMESTAMP(3) NOT NULL,
    "validUntil" TIMESTAMP(3) NOT NULL,
    "source" TEXT NOT NULL DEFAULT 'IMD_RECOMMENDER',
    "confidence" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    "targetPersona" "PersonaType",
    "locationId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "recommendations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recommendation_rules" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "ruleType" TEXT NOT NULL,
    "criteriaJson" JSONB NOT NULL,
    "actionTemplate" JSONB NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "recommendation_rules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recommendation_histories" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "recommendationId" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "interactedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "recommendation_histories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "health_preferences" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "hasAsthma" BOOLEAN NOT NULL DEFAULT false,
    "hasRespiratoryIssues" BOOLEAN NOT NULL DEFAULT false,
    "hasPollenAllergy" BOOLEAN NOT NULL DEFAULT false,
    "hasHeartCondition" BOOLEAN NOT NULL DEFAULT false,
    "elderlyInHousehold" BOOLEAN NOT NULL DEFAULT false,
    "childrenInHousehold" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "health_preferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "health_advisories" (
    "id" TEXT NOT NULL,
    "condition" TEXT NOT NULL,
    "riskLevel" TEXT NOT NULL,
    "advisoryText" TEXT NOT NULL,
    "recommendedCare" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "health_advisories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fitness_preferences" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "preferredActivity" TEXT NOT NULL DEFAULT 'RUNNING',
    "preferredTimeSlot" TEXT NOT NULL DEFAULT 'MORNING',
    "targetDistanceKm" DOUBLE PRECISION,
    "maxAcceptableTemp" DOUBLE PRECISION NOT NULL DEFAULT 34.0,
    "minAcceptableTemp" DOUBLE PRECISION NOT NULL DEFAULT 10.0,
    "maxAcceptableAqi" INTEGER NOT NULL DEFAULT 150,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "fitness_preferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "running_windows" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3) NOT NULL,
    "suitabilityScore" INTEGER NOT NULL,
    "summary" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "running_windows_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "outdoor_scores" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "score" INTEGER NOT NULL,
    "breakdown" JSONB NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "outdoor_scores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trips" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tripName" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "trips_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trip_destinations" (
    "id" TEXT NOT NULL,
    "tripId" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "visitDate" TIMESTAMP(3) NOT NULL,
    "activityPlan" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "trip_destinations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "packing_recommendations" (
    "id" TEXT NOT NULL,
    "tripDestinationId" TEXT NOT NULL,
    "item" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "packing_recommendations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "family_profiles" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "childrenCount" INTEGER NOT NULL DEFAULT 0,
    "elderlyCount" INTEGER NOT NULL DEFAULT 0,
    "infantPresent" BOOLEAN NOT NULL DEFAULT false,
    "notifySchoolWeather" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "family_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "school_locations" (
    "id" TEXT NOT NULL,
    "familyProfileId" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "schoolName" TEXT NOT NULL,
    "startHour" TEXT NOT NULL DEFAULT '08:00',
    "endHour" TEXT NOT NULL DEFAULT '14:00',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "school_locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "school_weather_advisories" (
    "id" TEXT NOT NULL,
    "schoolLocationId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "advisoryText" TEXT NOT NULL,
    "riskLevel" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "school_weather_advisories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "farms" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "farmName" TEXT NOT NULL,
    "cropType" TEXT NOT NULL,
    "soilType" TEXT NOT NULL,
    "sowingDate" TIMESTAMP(3),
    "irrigationType" TEXT,
    "areaInAcres" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "farms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "soil_observations" (
    "id" TEXT NOT NULL,
    "farmId" TEXT NOT NULL,
    "observationTime" TIMESTAMP(3) NOT NULL,
    "soilMoisture" DOUBLE PRECISION NOT NULL,
    "soilTemperature" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "soil_observations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "farming_advisories" (
    "id" TEXT NOT NULL,
    "farmId" TEXT NOT NULL,
    "advisoryType" TEXT NOT NULL,
    "recommendation" TEXT NOT NULL,
    "cropStage" TEXT,
    "validUntil" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "farming_advisories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "marine_observations" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "observationTime" TIMESTAMP(3) NOT NULL,
    "waveHeightM" DOUBLE PRECISION NOT NULL,
    "wavePeriodSec" DOUBLE PRECISION NOT NULL,
    "waveDirection" DOUBLE PRECISION NOT NULL,
    "seaTempCelsius" DOUBLE PRECISION NOT NULL,
    "tideType" TEXT NOT NULL,
    "tideHeightM" DOUBLE PRECISION NOT NULL,
    "seaCondition" TEXT NOT NULL,
    "swimmingSafety" BOOLEAN NOT NULL DEFAULT true,
    "dataSource" TEXT NOT NULL DEFAULT 'INCOIS_IMD',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "marine_observations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "commute_routes" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "routeName" TEXT NOT NULL,
    "originLat" DOUBLE PRECISION NOT NULL,
    "originLon" DOUBLE PRECISION NOT NULL,
    "originName" TEXT,
    "destLat" DOUBLE PRECISION NOT NULL,
    "destLon" DOUBLE PRECISION NOT NULL,
    "destName" TEXT,
    "departureTime" TEXT NOT NULL DEFAULT '08:30',
    "returnTime" TEXT NOT NULL DEFAULT '17:30',
    "notifyAdvisories" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "commute_routes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "outdoor_events" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "eventName" TEXT NOT NULL,
    "eventDate" TIMESTAMP(3) NOT NULL,
    "locationLat" DOUBLE PRECISION NOT NULL,
    "locationLon" DOUBLE PRECISION NOT NULL,
    "venueName" TEXT,
    "eventType" TEXT NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "outdoor_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alerts" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "severity" "AlertSeverity" NOT NULL DEFAULT 'ADVISORY',
    "category" "AlertCategory" NOT NULL DEFAULT 'METEOROLOGICAL',
    "eventType" TEXT NOT NULL,
    "effectiveFrom" TIMESTAMP(3) NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "sender" TEXT NOT NULL DEFAULT 'IMD_OFFICIAL',
    "areaDescription" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "radiusKm" DOUBLE PRECISION,
    "locationId" TEXT,
    "isApproved" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "alerts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alert_rules" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "metric" TEXT NOT NULL,
    "operator" TEXT NOT NULL,
    "threshold" DOUBLE PRECISION NOT NULL,
    "severity" "AlertSeverity" NOT NULL,
    "messageTemplate" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "alert_rules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alert_targets" (
    "id" TEXT NOT NULL,
    "alertId" TEXT NOT NULL,
    "targetType" TEXT NOT NULL,
    "targetValue" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "alert_targets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alert_histories" (
    "id" TEXT NOT NULL,
    "alertId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "deliveredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" TEXT NOT NULL DEFAULT 'DELIVERED',

    CONSTRAINT "alert_histories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL DEFAULT 'WEATHER_ALERT',
    "dataPayload" JSONB,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "readAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_preferences" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "weatherAlerts" BOOLEAN NOT NULL DEFAULT true,
    "dailyBriefing" BOOLEAN NOT NULL DEFAULT true,
    "aqiWarnings" BOOLEAN NOT NULL DEFAULT true,
    "rainPredictions" BOOLEAN NOT NULL DEFAULT true,
    "quietHoursStart" TEXT,
    "quietHoursEnd" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notification_preferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_deliveries" (
    "id" TEXT NOT NULL,
    "notificationId" TEXT NOT NULL,
    "deviceTokenId" TEXT,
    "status" "DeliveryStatus" NOT NULL DEFAULT 'PENDING',
    "retryCount" INTEGER NOT NULL DEFAULT 0,
    "fcmMessageId" TEXT,
    "errorMessage" TEXT,
    "sentAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notification_deliveries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "analytics_events" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "eventName" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "appVersion" TEXT,
    "metadata" JSONB,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "analytics_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_activities" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "activityType" TEXT NOT NULL,
    "durationSeconds" INTEGER NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_activities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "homepage_interactions" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "cardType" "CardType" NOT NULL,
    "interactionType" TEXT NOT NULL,
    "dwellTimeMs" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "homepage_interactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "admin_actions" (
    "id" TEXT NOT NULL,
    "adminId" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "targetResource" TEXT NOT NULL,
    "targetId" TEXT,
    "changesJson" JSONB,
    "ipAddress" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "admin_actions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT,
    "payload" JSONB,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "system_settings" (
    "id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "description" TEXT,
    "isPublic" BOOLEAN NOT NULL DEFAULT false,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "system_settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "data_source_statuses" (
    "id" TEXT NOT NULL,
    "providerName" TEXT NOT NULL,
    "serviceType" TEXT NOT NULL,
    "status" "DataSourceState" NOT NULL DEFAULT 'HEALTHY',
    "responseTimeMs" INTEGER NOT NULL DEFAULT 0,
    "lastSyncAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "errorMessage" TEXT,
    "failureCount" INTEGER NOT NULL DEFAULT 0,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "data_source_statuses_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phoneNumber_key" ON "users"("phoneNumber");

-- CreateIndex
CREATE INDEX "users_email_idx" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_status_idx" ON "users"("status");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("name");

-- CreateIndex
CREATE UNIQUE INDEX "permissions_name_key" ON "permissions"("name");

-- CreateIndex
CREATE INDEX "permissions_module_idx" ON "permissions"("module");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_tokenHash_key" ON "refresh_tokens"("tokenHash");

-- CreateIndex
CREATE INDEX "refresh_tokens_userId_idx" ON "refresh_tokens"("userId");

-- CreateIndex
CREATE INDEX "refresh_tokens_tokenHash_idx" ON "refresh_tokens"("tokenHash");

-- CreateIndex
CREATE INDEX "refresh_tokens_familyId_idx" ON "refresh_tokens"("familyId");

-- CreateIndex
CREATE INDEX "login_sessions_userId_idx" ON "login_sessions"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "device_tokens_token_key" ON "device_tokens"("token");

-- CreateIndex
CREATE INDEX "device_tokens_userId_idx" ON "device_tokens"("userId");

-- CreateIndex
CREATE INDEX "device_tokens_token_idx" ON "device_tokens"("token");

-- CreateIndex
CREATE UNIQUE INDEX "user_profiles_userId_key" ON "user_profiles"("userId");

-- CreateIndex
CREATE INDEX "user_profiles_persona_idx" ON "user_profiles"("persona");

-- CreateIndex
CREATE UNIQUE INDEX "user_preferences_userId_key" ON "user_preferences"("userId");

-- CreateIndex
CREATE INDEX "user_interests_userId_idx" ON "user_interests"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "user_interests_userId_interest_key" ON "user_interests"("userId", "interest");

-- CreateIndex
CREATE UNIQUE INDEX "locations_stationCode_key" ON "locations"("stationCode");

-- CreateIndex
CREATE INDEX "locations_name_idx" ON "locations"("name");

-- CreateIndex
CREATE INDEX "locations_state_idx" ON "locations"("state");

-- CreateIndex
CREATE INDEX "locations_latitude_longitude_idx" ON "locations"("latitude", "longitude");

-- CreateIndex
CREATE INDEX "locations_geohash_idx" ON "locations"("geohash");

-- CreateIndex
CREATE UNIQUE INDEX "locations_latitude_longitude_key" ON "locations"("latitude", "longitude");

-- CreateIndex
CREATE INDEX "saved_locations_userId_idx" ON "saved_locations"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "saved_locations_userId_locationId_key" ON "saved_locations"("userId", "locationId");

-- CreateIndex
CREATE INDEX "favorite_locations_userId_idx" ON "favorite_locations"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "favorite_locations_userId_locationId_key" ON "favorite_locations"("userId", "locationId");

-- CreateIndex
CREATE INDEX "weather_observations_locationId_observationTime_idx" ON "weather_observations"("locationId", "observationTime");

-- CreateIndex
CREATE INDEX "weather_forecasts_locationId_idx" ON "weather_forecasts"("locationId");

-- CreateIndex
CREATE UNIQUE INDEX "weather_forecasts_locationId_forecastDate_key" ON "weather_forecasts"("locationId", "forecastDate");

-- CreateIndex
CREATE INDEX "hourly_forecasts_forecastId_time_idx" ON "hourly_forecasts"("forecastId", "time");

-- CreateIndex
CREATE INDEX "daily_forecasts_forecastId_date_idx" ON "daily_forecasts"("forecastId", "date");

-- CreateIndex
CREATE INDEX "sunrise_sunsets_locationId_idx" ON "sunrise_sunsets"("locationId");

-- CreateIndex
CREATE UNIQUE INDEX "sunrise_sunsets_locationId_date_key" ON "sunrise_sunsets"("locationId", "date");

-- CreateIndex
CREATE INDEX "aqi_observations_locationId_observationTime_idx" ON "aqi_observations"("locationId", "observationTime");

-- CreateIndex
CREATE INDEX "uv_observations_locationId_observationTime_idx" ON "uv_observations"("locationId", "observationTime");

-- CreateIndex
CREATE INDEX "pollen_observations_locationId_observationTime_idx" ON "pollen_observations"("locationId", "observationTime");

-- CreateIndex
CREATE INDEX "visibility_observations_locationId_observationTime_idx" ON "visibility_observations"("locationId", "observationTime");

-- CreateIndex
CREATE UNIQUE INDEX "personalization_profiles_userId_key" ON "personalization_profiles"("userId");

-- CreateIndex
CREATE INDEX "personalization_rules_targetPersona_idx" ON "personalization_rules"("targetPersona");

-- CreateIndex
CREATE INDEX "personalization_rules_cardType_idx" ON "personalization_rules"("cardType");

-- CreateIndex
CREATE UNIQUE INDEX "homepage_cards_cardType_key" ON "homepage_cards"("cardType");

-- CreateIndex
CREATE INDEX "card_priorities_personaType_idx" ON "card_priorities"("personaType");

-- CreateIndex
CREATE UNIQUE INDEX "card_priorities_personaType_cardType_key" ON "card_priorities"("personaType", "cardType");

-- CreateIndex
CREATE INDEX "user_card_preferences_userId_idx" ON "user_card_preferences"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "user_card_preferences_userId_cardType_key" ON "user_card_preferences"("userId", "cardType");

-- CreateIndex
CREATE INDEX "personalization_events_userId_idx" ON "personalization_events"("userId");

-- CreateIndex
CREATE INDEX "personalization_events_cardType_idx" ON "personalization_events"("cardType");

-- CreateIndex
CREATE INDEX "recommendations_locationId_idx" ON "recommendations"("locationId");

-- CreateIndex
CREATE INDEX "recommendations_type_idx" ON "recommendations"("type");

-- CreateIndex
CREATE INDEX "recommendations_targetPersona_idx" ON "recommendations"("targetPersona");

-- CreateIndex
CREATE INDEX "recommendation_histories_userId_idx" ON "recommendation_histories"("userId");

-- CreateIndex
CREATE INDEX "recommendation_histories_recommendationId_idx" ON "recommendation_histories"("recommendationId");

-- CreateIndex
CREATE UNIQUE INDEX "health_preferences_userId_key" ON "health_preferences"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "fitness_preferences_userId_key" ON "fitness_preferences"("userId");

-- CreateIndex
CREATE INDEX "running_windows_locationId_startTime_idx" ON "running_windows"("locationId", "startTime");

-- CreateIndex
CREATE INDEX "outdoor_scores_locationId_date_idx" ON "outdoor_scores"("locationId", "date");

-- CreateIndex
CREATE INDEX "trips_userId_idx" ON "trips"("userId");

-- CreateIndex
CREATE INDEX "trip_destinations_tripId_idx" ON "trip_destinations"("tripId");

-- CreateIndex
CREATE INDEX "packing_recommendations_tripDestinationId_idx" ON "packing_recommendations"("tripDestinationId");

-- CreateIndex
CREATE UNIQUE INDEX "family_profiles_userId_key" ON "family_profiles"("userId");

-- CreateIndex
CREATE INDEX "school_locations_familyProfileId_idx" ON "school_locations"("familyProfileId");

-- CreateIndex
CREATE INDEX "school_weather_advisories_schoolLocationId_date_idx" ON "school_weather_advisories"("schoolLocationId", "date");

-- CreateIndex
CREATE INDEX "farms_userId_idx" ON "farms"("userId");

-- CreateIndex
CREATE INDEX "farms_locationId_idx" ON "farms"("locationId");

-- CreateIndex
CREATE INDEX "soil_observations_farmId_observationTime_idx" ON "soil_observations"("farmId", "observationTime");

-- CreateIndex
CREATE INDEX "farming_advisories_farmId_idx" ON "farming_advisories"("farmId");

-- CreateIndex
CREATE INDEX "marine_observations_locationId_observationTime_idx" ON "marine_observations"("locationId", "observationTime");

-- CreateIndex
CREATE INDEX "commute_routes_userId_idx" ON "commute_routes"("userId");

-- CreateIndex
CREATE INDEX "outdoor_events_userId_idx" ON "outdoor_events"("userId");

-- CreateIndex
CREATE INDEX "alerts_severity_idx" ON "alerts"("severity");

-- CreateIndex
CREATE INDEX "alerts_category_idx" ON "alerts"("category");

-- CreateIndex
CREATE INDEX "alerts_locationId_idx" ON "alerts"("locationId");

-- CreateIndex
CREATE INDEX "alerts_effectiveFrom_expiresAt_idx" ON "alerts"("effectiveFrom", "expiresAt");

-- CreateIndex
CREATE INDEX "alert_targets_alertId_idx" ON "alert_targets"("alertId");

-- CreateIndex
CREATE INDEX "alert_histories_alertId_idx" ON "alert_histories"("alertId");

-- CreateIndex
CREATE INDEX "alert_histories_userId_idx" ON "alert_histories"("userId");

-- CreateIndex
CREATE INDEX "notifications_userId_isRead_idx" ON "notifications"("userId", "isRead");

-- CreateIndex
CREATE UNIQUE INDEX "notification_preferences_userId_key" ON "notification_preferences"("userId");

-- CreateIndex
CREATE INDEX "notification_deliveries_notificationId_idx" ON "notification_deliveries"("notificationId");

-- CreateIndex
CREATE INDEX "notification_deliveries_status_idx" ON "notification_deliveries"("status");

-- CreateIndex
CREATE INDEX "analytics_events_userId_idx" ON "analytics_events"("userId");

-- CreateIndex
CREATE INDEX "analytics_events_eventName_idx" ON "analytics_events"("eventName");

-- CreateIndex
CREATE INDEX "analytics_events_createdAt_idx" ON "analytics_events"("createdAt");

-- CreateIndex
CREATE INDEX "user_activities_userId_idx" ON "user_activities"("userId");

-- CreateIndex
CREATE INDEX "homepage_interactions_userId_idx" ON "homepage_interactions"("userId");

-- CreateIndex
CREATE INDEX "homepage_interactions_cardType_idx" ON "homepage_interactions"("cardType");

-- CreateIndex
CREATE INDEX "admin_actions_adminId_idx" ON "admin_actions"("adminId");

-- CreateIndex
CREATE INDEX "admin_actions_action_idx" ON "admin_actions"("action");

-- CreateIndex
CREATE INDEX "audit_logs_userId_idx" ON "audit_logs"("userId");

-- CreateIndex
CREATE INDEX "audit_logs_entity_idx" ON "audit_logs"("entity");

-- CreateIndex
CREATE UNIQUE INDEX "system_settings_key_key" ON "system_settings"("key");

-- CreateIndex
CREATE UNIQUE INDEX "data_source_statuses_providerName_key" ON "data_source_statuses"("providerName");

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "login_sessions" ADD CONSTRAINT "login_sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "device_tokens" ADD CONSTRAINT "device_tokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_profiles" ADD CONSTRAINT "user_profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_preferences" ADD CONSTRAINT "user_preferences_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_interests" ADD CONSTRAINT "user_interests_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "saved_locations" ADD CONSTRAINT "saved_locations_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "saved_locations" ADD CONSTRAINT "saved_locations_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favorite_locations" ADD CONSTRAINT "favorite_locations_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favorite_locations" ADD CONSTRAINT "favorite_locations_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "weather_observations" ADD CONSTRAINT "weather_observations_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "weather_forecasts" ADD CONSTRAINT "weather_forecasts_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hourly_forecasts" ADD CONSTRAINT "hourly_forecasts_forecastId_fkey" FOREIGN KEY ("forecastId") REFERENCES "weather_forecasts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "daily_forecasts" ADD CONSTRAINT "daily_forecasts_forecastId_fkey" FOREIGN KEY ("forecastId") REFERENCES "weather_forecasts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sunrise_sunsets" ADD CONSTRAINT "sunrise_sunsets_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aqi_observations" ADD CONSTRAINT "aqi_observations_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "uv_observations" ADD CONSTRAINT "uv_observations_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pollen_observations" ADD CONSTRAINT "pollen_observations_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "visibility_observations" ADD CONSTRAINT "visibility_observations_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "personalization_profiles" ADD CONSTRAINT "personalization_profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_card_preferences" ADD CONSTRAINT "user_card_preferences_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recommendations" ADD CONSTRAINT "recommendations_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recommendation_histories" ADD CONSTRAINT "recommendation_histories_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recommendation_histories" ADD CONSTRAINT "recommendation_histories_recommendationId_fkey" FOREIGN KEY ("recommendationId") REFERENCES "recommendations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "health_preferences" ADD CONSTRAINT "health_preferences_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fitness_preferences" ADD CONSTRAINT "fitness_preferences_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trips" ADD CONSTRAINT "trips_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trip_destinations" ADD CONSTRAINT "trip_destinations_tripId_fkey" FOREIGN KEY ("tripId") REFERENCES "trips"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trip_destinations" ADD CONSTRAINT "trip_destinations_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "packing_recommendations" ADD CONSTRAINT "packing_recommendations_tripDestinationId_fkey" FOREIGN KEY ("tripDestinationId") REFERENCES "trip_destinations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "family_profiles" ADD CONSTRAINT "family_profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "school_locations" ADD CONSTRAINT "school_locations_familyProfileId_fkey" FOREIGN KEY ("familyProfileId") REFERENCES "family_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "school_locations" ADD CONSTRAINT "school_locations_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "school_weather_advisories" ADD CONSTRAINT "school_weather_advisories_schoolLocationId_fkey" FOREIGN KEY ("schoolLocationId") REFERENCES "school_locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "farms" ADD CONSTRAINT "farms_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "farms" ADD CONSTRAINT "farms_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "soil_observations" ADD CONSTRAINT "soil_observations_farmId_fkey" FOREIGN KEY ("farmId") REFERENCES "farms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "farming_advisories" ADD CONSTRAINT "farming_advisories_farmId_fkey" FOREIGN KEY ("farmId") REFERENCES "farms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commute_routes" ADD CONSTRAINT "commute_routes_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "outdoor_events" ADD CONSTRAINT "outdoor_events_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alerts" ADD CONSTRAINT "alerts_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alert_targets" ADD CONSTRAINT "alert_targets_alertId_fkey" FOREIGN KEY ("alertId") REFERENCES "alerts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alert_histories" ADD CONSTRAINT "alert_histories_alertId_fkey" FOREIGN KEY ("alertId") REFERENCES "alerts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alert_histories" ADD CONSTRAINT "alert_histories_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_preferences" ADD CONSTRAINT "notification_preferences_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_deliveries" ADD CONSTRAINT "notification_deliveries_notificationId_fkey" FOREIGN KEY ("notificationId") REFERENCES "notifications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_deliveries" ADD CONSTRAINT "notification_deliveries_deviceTokenId_fkey" FOREIGN KEY ("deviceTokenId") REFERENCES "device_tokens"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "analytics_events" ADD CONSTRAINT "analytics_events_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_activities" ADD CONSTRAINT "user_activities_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "homepage_interactions" ADD CONSTRAINT "homepage_interactions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "admin_actions" ADD CONSTRAINT "admin_actions_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
