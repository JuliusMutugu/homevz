/// App-wide constants for the HomeVZ application
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'HomeVZ';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your trusted housing solution in Kenya';

  // API Configuration
  static const String baseUrl = 'https://api.homevz.co.ke/v1';
  static const String apiKey = 'your_api_key_here';
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String onboardingKey = 'onboarding_completed';

  // M-Pesa Configuration
  static const String mpesaBusinessShortCode = '174379';
  static const String mpesaPasskey = 'your_mpesa_passkey';
  static const String mpesaCallbackUrl = 'https://api.homevz.co.ke/mpesa/callback';

  // Property Types
  static const List<String> propertyTypes = [
    'Apartment',
    'House',
    'Bedsitter',
    'Single Room',
    'Studio',
    'Villa',
    'Townhouse',
    'Commercial',
    'Land',
  ];

  // Kenyan Counties for Location Selection
  static const List<String> kenyanCounties = [
    'Nairobi',
    'Mombasa',
    'Kiambu',
    'Nakuru',
    'Machakos',
    'Kajiado',
    'Murang\'a',
    'Nyeri',
    'Kirinyaga',
    'Nyandarua',
    'Laikipia',
    'Meru',
    'Tharaka Nithi',
    'Embu',
    'Kitui',
    'Makueni',
    'Nzaui',
    'Kwale',
    'Kilifi',
    'Tana River',
    'Lamu',
    'Taita Taveta',
    'Garissa',
    'Wajir',
    'Mandera',
    'Marsabit',
    'Isiolo',
    'Samburu',
    'Turkana',
    'West Pokot',
    'Baringo',
    'Uasin Gishu',
    'Elgeyo Marakwet',
    'Nandi',
    'Trans Nzoia',
    'Bungoma',
    'Kakamega',
    'Vihiga',
    'Busia',
    'Siaya',
    'Kisumu',
    'Homa Bay',
    'Migori',
    'Kisii',
    'Nyamira',
    'Narok',
    'Bomet',
    'Kericho',
  ];

  // Popular Areas in Major Cities
  static const Map<String, List<String>> popularAreas = {
    'Nairobi': [
      'Westlands',
      'Karen',
      'Kilimani',
      'Lavington',
      'Kileleshwa',
      'Parklands',
      'South B',
      'South C',
      'Donholm',
      'Umoja',
      'Buruburu',
      'Kasarani',
      'Kahawa',
      'Ruaka',
      'Runda',
      'Muthaiga',
    ],
    'Mombasa': [
      'Nyali',
      'Bamburi',
      'Shanzu',
      'Diani',
      'Tudor',
      'Kizingo',
      'Old Town',
      'Likoni',
    ],
    'Nakuru': [
      'Milimani',
      'Section 58',
      'Pipeline',
      'London',
      'Shabab',
      'Free Area',
    ],
  };

  // Property Amenities
  static const List<String> propertyAmenities = [
    'Parking',
    'Security',
    'Water',
    'Electricity',
    'Internet/WiFi',
    'Generator',
    'Gym',
    'Swimming Pool',
    'Garden',
    'Balcony',
    'Elevator',
    'CCTV',
    'Gate',
    'Borehole',
    'Solar Water Heating',
    'Backup Generator',
    'Playground',
    'Shopping Center Nearby',
    'Hospital Nearby',
    'School Nearby',
    'Public Transport',
  ];

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPropertyImages = 10;
  static const int maxPropertyDescriptionLength = 1000;
  static const double maxPropertyPrice = 10000000; // 10M KES
  static const double minPropertyPrice = 1000; // 1K KES

  // Map Configuration
  static const double defaultLatitude = -1.2921; // Nairobi coordinates
  static const double defaultLongitude = 36.8219;
  static const double defaultZoom = 12.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // Pagination
  static const int itemsPerPage = 20;
  static const int maxSearchResults = 100;

  // File Upload
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
}
