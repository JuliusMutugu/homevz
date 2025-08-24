# Temporary Icon Instructions

Since I cannot directly download images, here's what you need to do:

## Quick Setup (5 minutes):

### Option A: Use Canva (Recommended)
1. Go to https://www.canva.com
2. Click "Create a design" → "App Icon" 
3. Search for "house" or "real estate" templates
4. Choose a design and customize with:
   - Background color: #2E7D32 (HomeVZ green)
   - Add text "HVZ" or keep just the house icon
   - Make sure it looks good at small sizes
5. Download as PNG (1024x1024)
6. Save as `app_icon.png` in the `assets/icons/` folder

### Option B: Download Free Icon
1. Go to https://www.flaticon.com/search?word=house&type=icon
2. Choose a house icon (look for green or customizable ones)
3. Download in PNG format (512px or larger)
4. Use an online resizer to make it 1024x1024: https://resizeimage.net
5. Save as `app_icon.png` in the `assets/icons/` folder

### Option C: Use AI Generator
1. Go to https://www.bing.com/images/create (free AI image generator)
2. Use prompt: "minimalist app icon of a house, green background, modern design, flat style, 1024x1024"
3. Download the generated image
4. Save as `app_icon.png` in the `assets/icons/` folder

## After getting the icon:

1. Make sure the file is named exactly `app_icon.png`
2. Run these commands in your terminal:

```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
```

3. The tool will automatically generate all the required icon sizes for:
   - Android (various densities)
   - iOS (if you plan to publish there)
   - Web favicon

## Colors to use in your icon design:
- Primary Green: #2E7D32
- Secondary Green: #4CAF50  
- Accent Orange: #FF7043
- White: #FFFFFF

The icon should represent housing/real estate and work well with the Kenyan market context.

## Test the icon:
After generating, run `flutter run` and you should see your new icon on the app!
