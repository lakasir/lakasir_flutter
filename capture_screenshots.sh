#!/bin/bash
# capture_screenshots.sh
# Captures Play Store screenshots from a connected Android device/emulator
#
# Prerequisites:
#   - Android emulator running or physical device connected
#   - App installed and signed in
#   - adb in PATH
#
# Usage: bash capture_screenshots.sh

set -e

DIR="store-assets/screenshots"
mkdir -p "$DIR"

echo "📱 Screenshot Capture for lakasir POS"
echo "====================================="
echo ""
echo "Instructions:"
echo "  1. Connect your Android device/emulator"
echo "  2. Build & install the app: flutter run --release"
echo "  3. Log in to your lakasir instance"
echo "  4. Navigate to each screen as prompted"
echo ""
echo "Press Enter to start..."
read -r

if ! adb devices | grep -v "^List" | grep -q "device$"; then
    echo "❌ No Android device found. Connect a device or start an emulator."
    echo "   Run: flutter emulators --launch <emulator_id>"
    exit 1
fi

SCREENS=(
    "01_dashboard:Main dashboard with menu grid"
    "02_pos:POS / Cashier screen with cart"
    "03_products:Product list with inventory"
    "04_transactions:Transaction history list"
    "05_reports:Sales reports and analytics"
    "06_profile:Profile and settings screen"
)

for SCREEN in "${SCREENS[@]}"; do
    IFS=':' read -r NAME DESC <<< "$SCREEN"
    echo ""
    echo "📸 Screen: $DESC"
    echo "   Press Enter to capture... (Ctrl+C to skip)"
    read -r

    FILENAME="$DIR/$NAME.png"
    adb shell screencap -p /sdcard/screenshot_temp.png
    adb pull /sdcard/screenshot_temp.png "$FILENAME"
    adb shell rm /sdcard/screenshot_temp.png

    echo "   ✅ Saved: $FILENAME"
done

echo ""
echo "🎉 All screenshots captured in $DIR/"
echo ""
echo "⚠️  Google Play requirements:"
echo "   - Minimum 2 screenshots (6+ recommended)"
echo "   - Size: 1080 x 1920 px or larger (16:9 portrait)"
echo "   - Format: PNG or JPEG (no transparency)"
echo ""
echo "   Upload to: Play Console → Store Listing → Phone screenshots"
