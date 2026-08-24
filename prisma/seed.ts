import { PrismaClient, UserRoleType, PersonaType, CardType } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  // eslint-disable-next-line no-console
  console.log('🌱 Starting database seed for Mausam backend...');

  // 1. Seed Roles
  const roles = [
    { name: UserRoleType.USER, description: 'Standard citizen mobile app user' },
    { name: UserRoleType.ADMIN, description: 'IMD regional / central weather operator' },
    { name: UserRoleType.SUPER_ADMIN, description: 'System administrator with full access' },
  ];

  for (const r of roles) {
    await prisma.role.upsert({
      where: { name: r.name },
      update: { description: r.description },
      create: r,
    });
  }
  // eslint-disable-next-line no-console
  console.log('✅ Roles seeded');

  // 2. Seed Default Super Admin
  const adminEmail = 'admin@mausam.imd.gov.in';
  const salt = await bcrypt.genSalt(10);
  const passwordHash = await bcrypt.hash('MausamAdmin@2026', salt);

  const superAdminRole = await prisma.role.findUnique({ where: { name: UserRoleType.SUPER_ADMIN } });

  const adminUser = await prisma.user.upsert({
    where: { email: adminEmail },
    update: {},
    create: {
      email: adminEmail,
      passwordHash,
      isVerified: true,
      phoneNumber: '+919999999999',
      profile: {
        create: {
          fullName: 'IMD National Administrator',
          persona: PersonaType.GENERAL,
        },
      },
      preferences: {
        create: {
          tempUnit: 'C',
          windSpeedUnit: 'km/h',
          theme: 'system',
        },
      },
    },
  });

  if (superAdminRole) {
    await prisma.userRole.upsert({
      where: {
        userId_roleId: {
          userId: adminUser.id,
          roleId: superAdminRole.id,
        },
      },
      update: {},
      create: {
        userId: adminUser.id,
        roleId: superAdminRole.id,
      },
    });
  }
  // eslint-disable-next-line no-console
  console.log('✅ Super Admin user seeded: admin@mausam.imd.gov.in (Password: MausamAdmin@2026)');

  // 3. Seed Major Indian Stations / Locations
  const locations = [
    {
      name: 'New Delhi (Safdarjung)',
      state: 'Delhi',
      district: 'New Delhi',
      latitude: 28.5847,
      longitude: 77.2066,
      elevation: 216,
      isOfficialStation: true,
      stationCode: 'DEL_SFD_01',
    },
    {
      name: 'Mumbai (Colaba)',
      state: 'Maharashtra',
      district: 'Mumbai',
      latitude: 18.9067,
      longitude: 72.8147,
      elevation: 11,
      isOfficialStation: true,
      stationCode: 'MUM_COL_01',
    },
    {
      name: 'Bengaluru (City)',
      state: 'Karnataka',
      district: 'Bengaluru Urban',
      latitude: 12.9716,
      longitude: 77.5946,
      elevation: 920,
      isOfficialStation: true,
      stationCode: 'BLR_CTY_01',
    },
    {
      name: 'Chennai (Meenambakkam)',
      state: 'Tamil Nadu',
      district: 'Chennai',
      latitude: 12.9856,
      longitude: 80.1812,
      elevation: 16,
      isOfficialStation: true,
      stationCode: 'CHE_MBK_01',
    },
    {
      name: 'Kolkata (Alipore)',
      state: 'West Bengal',
      district: 'Kolkata',
      latitude: 22.5333,
      longitude: 88.3333,
      elevation: 6,
      isOfficialStation: true,
      stationCode: 'KOL_ALP_01',
    },
    {
      name: 'Shimla',
      state: 'Himachal Pradesh',
      district: 'Shimla',
      latitude: 31.1048,
      longitude: 77.1734,
      elevation: 2206,
      isOfficialStation: true,
      stationCode: 'SML_CTY_01',
    },
    {
      name: 'Hyderabad (Begumpet)',
      state: 'Telangana',
      district: 'Hyderabad',
      latitude: 17.4483,
      longitude: 78.4744,
      elevation: 531,
      isOfficialStation: true,
      stationCode: 'HYD_BGP_01',
    },
    {
      name: 'Ahmedabad',
      state: 'Gujarat',
      district: 'Ahmedabad',
      latitude: 23.0225,
      longitude: 72.5714,
      elevation: 53,
      isOfficialStation: true,
      stationCode: 'AMD_CTY_01',
    },
    {
      name: 'Srinagar',
      state: 'Jammu and Kashmir',
      district: 'Srinagar',
      latitude: 34.0837,
      longitude: 74.7973,
      elevation: 1585,
      isOfficialStation: true,
      stationCode: 'SXR_CTY_01',
    },
  ];

  for (const loc of locations) {
    await prisma.location.upsert({
      where: { latitude_longitude: { latitude: loc.latitude, longitude: loc.longitude } },
      update: loc,
      create: loc,
    });
  }
  // eslint-disable-next-line no-console
  console.log(`✅ Seeded ${locations.length} official IMD stations / locations`);

  // 4. Seed Homepage Cards
  const cards = [
    { cardType: CardType.SEVERE_ALERTS, title: 'Active Severe Alerts', defaultPriority: 100 },
    { cardType: CardType.CURRENT_WEATHER, title: 'Current Weather', defaultPriority: 90 },
    { cardType: CardType.HOURLY_FORECAST, title: 'Hourly Forecast', defaultPriority: 85 },
    { cardType: CardType.DAILY_FORECAST, title: '7-Day Forecast', defaultPriority: 80 },
    { cardType: CardType.AIR_QUALITY, title: 'Air Quality Index (AQI)', defaultPriority: 75 },
    { cardType: CardType.UV_INDEX, title: 'UV & Sun Index', defaultPriority: 70 },
    { cardType: CardType.POLLEN_REPORT, title: 'Pollen Levels', defaultPriority: 65 },
    { cardType: CardType.HEALTH_ADVISORY, title: 'Health & Air Advisories', defaultPriority: 60 },
    { cardType: CardType.FITNESS_RUNNING_WINDOW, title: 'Optimal Workout Windows', defaultPriority: 55 },
    { cardType: CardType.RECOMMENDATIONS, title: 'Actionable Advice', defaultPriority: 50 },
    { cardType: CardType.FARM_AGRICULTURE, title: 'Agro-Meteorology Advisory', defaultPriority: 45 },
    { cardType: CardType.COMMUTE_ROUTING, title: 'Commute Weather & Fog Risk', defaultPriority: 40 },
    { cardType: CardType.FAMILY_SCHOOL_ADVISORY, title: 'Family & School Weather', defaultPriority: 35 },
    { cardType: CardType.TRAVEL_PLANNER, title: 'Travel & Packing Forecast', defaultPriority: 30 },
    { cardType: CardType.MARINE_COASTAL, title: 'Marine & Sea State', defaultPriority: 25 },
    { cardType: CardType.OUTDOOR_EVENTS, title: 'Outdoor Events Suitability', defaultPriority: 20 },
  ];

  for (const c of cards) {
    await prisma.homepageCard.upsert({
      where: { cardType: c.cardType },
      update: { title: c.title, defaultPriority: c.defaultPriority },
      create: c,
    });
  }
  // eslint-disable-next-line no-console
  console.log(`✅ Seeded ${cards.length} Homepage Card definitions`);

  // 5. Seed Persona Card Priorities (Core USP)
  const personaPriorities: { persona: PersonaType; card: CardType; priority: number; weight: number }[] = [
    // Health Conscious
    { persona: PersonaType.HEALTH_CONSCIOUS, card: CardType.AIR_QUALITY, priority: 10, weight: 1.5 },
    { persona: PersonaType.HEALTH_CONSCIOUS, card: CardType.POLLEN_REPORT, priority: 10, weight: 1.4 },
    { persona: PersonaType.HEALTH_CONSCIOUS, card: CardType.HEALTH_ADVISORY, priority: 9, weight: 1.3 },
    { persona: PersonaType.HEALTH_CONSCIOUS, card: CardType.UV_INDEX, priority: 8, weight: 1.2 },

    // Outdoor Fitness
    { persona: PersonaType.OUTDOOR_FITNESS, card: CardType.FITNESS_RUNNING_WINDOW, priority: 10, weight: 1.5 },
    { persona: PersonaType.OUTDOOR_FITNESS, card: CardType.HOURLY_FORECAST, priority: 9, weight: 1.3 },
    { persona: PersonaType.OUTDOOR_FITNESS, card: CardType.AIR_QUALITY, priority: 8, weight: 1.2 },
    { persona: PersonaType.OUTDOOR_FITNESS, card: CardType.UV_INDEX, priority: 8, weight: 1.2 },

    // Agriculture / Farmer
    { persona: PersonaType.AGRICULTURE_FARMER, card: CardType.FARM_AGRICULTURE, priority: 10, weight: 1.5 },
    { persona: PersonaType.AGRICULTURE_FARMER, card: CardType.DAILY_FORECAST, priority: 9, weight: 1.3 },
    { persona: PersonaType.AGRICULTURE_FARMER, card: CardType.RECOMMENDATIONS, priority: 8, weight: 1.2 },

    // Beach / Marine
    { persona: PersonaType.BEACH_SURFER, card: CardType.MARINE_COASTAL, priority: 10, weight: 1.5 },
    { persona: PersonaType.BEACH_SURFER, card: CardType.UV_INDEX, priority: 9, weight: 1.3 },

    // Commuter
    { persona: PersonaType.COMMUTER, card: CardType.COMMUTE_ROUTING, priority: 10, weight: 1.5 },
    { persona: PersonaType.COMMUTER, card: CardType.HOURLY_FORECAST, priority: 9, weight: 1.3 },
  ];

  for (const pp of personaPriorities) {
    await prisma.cardPriority.upsert({
      where: { personaType_cardType: { personaType: pp.persona, cardType: pp.card } },
      update: { basePriority: pp.priority, weightMultiplier: pp.weight },
      create: {
        personaType: pp.persona,
        cardType: pp.card,
        basePriority: pp.priority,
        weightMultiplier: pp.weight,
      },
    });
  }
  // eslint-disable-next-line no-console
  console.log(`✅ Seeded ${personaPriorities.length} Persona Card Priority weights`);

  // 6. Seed System Settings & Data Source Statuses
  const settings = [
    { key: 'WEATHER_SYNC_INTERVAL_MINUTES', value: '15', description: 'Weather sync frequency' },
    { key: 'AQI_SYNC_INTERVAL_MINUTES', value: '30', description: 'CPCB AQI sync frequency' },
    { key: 'ALERT_EVALUATION_INTERVAL_MINUTES', value: '5', description: 'Alert rule check frequency' },
    { key: 'ENABLE_MOCK_FALLBACK', value: 'true', description: 'Graceful fallback to mock data when upstream APIs fail' },
  ];

  for (const s of settings) {
    await prisma.systemSetting.upsert({
      where: { key: s.key },
      update: { value: s.value, description: s.description },
      create: s,
    });
  }

  const dataSources = [
    { providerName: 'IMD', serviceType: 'WEATHER' },
    { providerName: 'OPEN_METEO', serviceType: 'FORECAST_POLLEN' },
    { providerName: 'CPCB', serviceType: 'AQI' },
    { providerName: 'INCOIS', serviceType: 'MARINE' },
  ];

  for (const ds of dataSources) {
    await prisma.dataSourceStatus.upsert({
      where: { providerName: ds.providerName },
      update: { serviceType: ds.serviceType },
      create: ds,
    });
  }
  // eslint-disable-next-line no-console
  console.log('✅ Seeded System Settings and Data Source Trackers');
  // eslint-disable-next-line no-console
  console.log('🎉 Database seeding completed successfully!');
}

main()
  .catch((e) => {
    // eslint-disable-next-line no-console
    console.error('❌ Seeding failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
