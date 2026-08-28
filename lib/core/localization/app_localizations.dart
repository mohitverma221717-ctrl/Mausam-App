import 'package:flutter/material.dart';

/// AppLocalizations supporting English (en) and Hindi (hi)
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('hi', ''),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'MAUSAM',
      'appTagline': 'Personalized Weather',
      'appSubtitle': 'Real-time Weather data & smart alerts',
      'getStarted': 'Get Started',
      'login': 'Login',
      'signUp': 'Sign Up',
      'welcomeBack': 'Welcome Back!',
      'loginToContinue':
          'Login to continue to your personalized weather experience.',
      'createAccount': 'Create Account',
      'emailOrMobile': 'Email / Mobile',
      'password': 'Password',
      'name': 'Full Name',
      'forgotPassword': 'Forgot Password?',
      'resetPassword': 'Reset Password',
      'verifyNumber': 'Verify Your Number',
      'enterOtp': 'Enter the 6-digit code sent to your mobile',
      'resendOtp': 'Resend Code',
      'locationPermission': 'Allow Location Access',
      'locationSubtitle':
          'To provide accurate weather updates and alerts based on your location.',
      'allow': 'Allow',
      'notNow': 'Not Now',
      'selectLocation': 'Select Your Location',
      'searchLocation': 'Search city or place...',
      'currentLocation': 'Current Location',
      'useCurrentLocation': 'Use Current Location',
      'recentLocations': 'Recent Locations',
      'popularCities': 'Popular Cities',
      'confirmLocation': 'Confirm Location',
      'chooseInterests': 'What matters to you?',
      'chooseInterestsSub': 'Select one or more to personalize your homepage.',
      'prioritySetup': 'Priority Setup',
      'prioritySetupSub': 'Drag to set what matters most to you.',
      'saveAndContinue': 'Save & Continue',
      'continueText': 'Continue',
      'home': 'Home',
      'explore': 'Explore',
      'radar': 'Radar',
      'alerts': 'Alerts',
      'profile': 'Profile',
      'feelsLike': 'Feels like',
      'hourlyForecast': 'Hourly Forecast',
      'dailyForecast': '7-Day Forecast',
      'airQualityIndex': 'Air Quality Index',
      'uvIndex': 'UV Index',
      'humidity': 'Humidity',
      'windSpeed': 'Wind Speed',
      'pressure': 'Pressure',
      'visibility': 'Visibility',
      'sunrise': 'Sunrise',
      'sunset': 'Sunset',
      'healthAdvisory': 'Health Advisory',
      'recommendedForYou': 'Recommended for you',
      'activeAlerts': 'Active Alerts',
      'rainRadar': 'Rain Radar',
      'cloudMap': 'Cloud Map',
      'windMap': 'Wind Map',
      'temperatureMap': 'Temperature Map',
      'savedLocations': 'Saved Locations',
      'myInterests': 'My Interests',
      'notificationSettings': 'Notification Settings',
      'units': 'Units',
      'language': 'Language',
      'theme': 'Theme',
      'helpFeedback': 'Help & Feedback',
      'aboutMausam': 'About Mausam',
      'health': 'Health',
      'fitness': 'Fitness',
      'marine': 'Marine',
      'travel': 'Travel',
      'family': 'Family',
      'agriculture': 'Agriculture',
      'commute': 'Commute',
      'eventPlanner': 'Event Planner',
      'bestRunningHours': 'Best Running Hours',
      'activityCondition': 'Activity Condition',
      'seaConditions': 'Sea Conditions',
      'tideTimings': 'Tide Timings',
      'waveHeight': 'Wave Height',
      'waterTemp': 'Water Temp',
      'packingSuggestions': 'Packing Suggestions',
      'schoolCommute': 'School Commute',
      'soilMoisture': 'Soil Moisture',
      'frostRisk': 'Frost Risk',
      'trafficConditions': 'Traffic Conditions',
      'comfortIndex': 'Comfort Index',
      'outdoorSuitability': 'Outdoor Suitability',
      'offlineNotice': 'You are offline. Showing last cached data.',
      'retry': 'Retry',
      'demoDataNotice': 'Demo / Sample Data',
    },
    'hi': {
      'appName': 'मौसम',
      'appTagline': 'व्यक्तिगत मौसम',
      'appSubtitle': 'सटीक और वास्तविक समय मौसम पूर्वानुमान और अलर्ट',
      'getStarted': 'शुरू करें',
      'login': 'लॉग इन करें',
      'signUp': 'खाता बनाएं',
      'welcomeBack': 'वापसी पर स्वागत है!',
      'loginToContinue': 'अपने व्यक्तिगत मौसम अनुभव के लिए लॉग इन करें।',
      'createAccount': 'नया खाता बनाएं',
      'emailOrMobile': 'ईमेल / मोबाइल',
      'password': 'पासवर्ड',
      'name': 'पूरा नाम',
      'forgotPassword': 'पासवर्ड भूल गए?',
      'resetPassword': 'पासवर्ड रीसेट करें',
      'verifyNumber': 'अपना नंबर सत्यापित करें',
      'enterOtp': 'आपके मोबाइल पर भेजा गया 6-अंकीय कोड दर्ज करें',
      'resendOtp': 'पुनः कोड भेजें',
      'locationPermission': 'स्थान की अनुमति दें',
      'locationSubtitle':
          'आपके स्थान के आधार पर सटीक मौसम पूर्वानुमान और अलर्ट प्रदान करने के लिए।',
      'allow': 'अनुमति दें',
      'notNow': 'अभी नहीं',
      'selectLocation': 'अपना स्थान चुनें',
      'searchLocation': 'शहर या स्थान खोजें...',
      'currentLocation': 'वर्तमान स्थान',
      'useCurrentLocation': 'वर्तमान स्थान का उपयोग करें',
      'recentLocations': 'हाल के स्थान',
      'popularCities': 'लोकप्रिय शहर',
      'confirmLocation': 'स्थान की पुष्टि करें',
      'chooseInterests': 'आपके लिए क्या महत्वपूर्ण है?',
      'chooseInterestsSub':
          'अपने होमपेज को निजीकृत करने के लिए एक या अधिक चुनें।',
      'prioritySetup': 'प्राथमिकता सेटअप',
      'prioritySetupSub': 'जो आपके लिए सबसे महत्वपूर्ण है उसे व्यवस्थित करें।',
      'saveAndContinue': 'सहेजें और आगे बढ़ें',
      'continueText': 'आगे बढ़ें',
      'home': 'होम',
      'explore': 'एक्सप्लोर',
      'radar': 'रडार',
      'alerts': 'अलर्ट',
      'profile': 'प्रोफ़ाइल',
      'feelsLike': 'महसूस होता है',
      'hourlyForecast': 'प्रति घंटे का पूर्वानुमान',
      'dailyForecast': '7-दिवसीय पूर्वानुमान',
      'airQualityIndex': 'वायु गुणवत्ता सूचकांक (AQI)',
      'uvIndex': 'यूवी इंडेक्स',
      'humidity': 'आर्द्रता',
      'windSpeed': 'हवा की गति',
      'pressure': 'दबाव',
      'visibility': 'दृश्यता',
      'sunrise': 'सूर्योदय',
      'sunset': 'सूर्यास्त',
      'healthAdvisory': 'स्वास्थ्य परामर्श',
      'recommendedForYou': 'आपके लिए अनुशंसित',
      'activeAlerts': 'सक्रिय अलर्ट',
      'rainRadar': 'बारिश रडार',
      'cloudMap': 'बादल मानचित्र',
      'windMap': 'पवन मानचित्र',
      'temperatureMap': 'तापमान मानचित्र',
      'savedLocations': 'सहेजे गए स्थान',
      'myInterests': 'मेरी रुचियां',
      'notificationSettings': 'अधिसूचना सेटिंग्स',
      'units': 'इकाइयाँ',
      'language': 'भाषा',
      'theme': 'थीम',
      'helpFeedback': 'सहायता एवं फ़ीडबैक',
      'aboutMausam': 'मौसम के बारे में',
      'health': 'स्वास्थ्य',
      'fitness': 'फिटनेस',
      'marine': 'समुद्री',
      'travel': 'यात्रा',
      'family': 'परिवार',
      'agriculture': 'कृषि',
      'commute': 'दैनिक यात्रा',
      'eventPlanner': 'इवेंट प्लानर',
      'bestRunningHours': 'दौड़ने के लिए सबसे अच्छा समय',
      'activityCondition': 'गतिविधि की स्थिति',
      'seaConditions': 'समुद्र की स्थिति',
      'tideTimings': 'ज्वार का समय',
      'waveHeight': 'लहर की ऊंचाई',
      'waterTemp': 'पानी का तापमान',
      'packingSuggestions': 'पैकिंग सुझाव',
      'schoolCommute': 'स्कूल यात्रा',
      'soilMoisture': 'मिट्टी की नमी',
      'frostRisk': 'पाले का जोखिम',
      'trafficConditions': 'यातायात की स्थिति',
      'comfortIndex': 'आराम सूचकांक',
      'outdoorSuitability': 'बाहरी उपयुक्तता',
      'offlineNotice': 'आप ऑफलाइन हैं। अंतिम कैश डेटा प्रदर्शित हो रहा है।',
      'retry': 'पुनः प्रयास करें',
      'demoDataNotice': 'डेमो / नमूना डेटा',
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  String tr(String key) => AppLocalizations.of(this).translate(key);
}
