# Environment Configuration for HomeVZ

## Google Maps API Key
To use Google Maps functionality, you need to:

1. Get your Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Geocoding API

3. Replace the placeholder in these files:
   - `android/app/src/main/AndroidManifest.xml`: Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE`
   - `ios/Runner/AppDelegate.swift`: Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE`

## Security Best Practices

### API Keys
- Never commit real API keys to version control
- Use environment variables or secure key management
- Restrict API keys to specific platforms and APIs

### Example .env file (create this file and add to .gitignore):
```
GOOGLE_MAPS_API_KEY=your_actual_api_key_here
MPESA_CONSUMER_KEY=your_mpesa_consumer_key
MPESA_CONSUMER_SECRET=your_mpesa_consumer_secret
```

### For production:
1. Use different API keys for development and production
2. Implement proper key rotation policies
3. Monitor API usage and set up billing alerts
4. Use cloud secret management services (AWS Secrets Manager, Google Secret Manager, etc.)

## Payment Integration

### M-Pesa Integration
- Register with Safaricom for M-Pesa API access
- Use sandbox environment for testing
- Implement proper error handling and transaction verification

### Bank Integration
- Integrate with local banks' APIs
- Implement proper transaction reconciliation
- Follow PCI DSS compliance for card payments

## PDF Generation
The reports feature uses PDF generation. For production:
- Consider using a dedicated PDF service
- Implement proper templating
- Add digital signatures for official documents
