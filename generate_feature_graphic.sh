#!/bin/bash
# generate_feature_graphic.sh
# Creates a 1024x500 feature graphic for Play Store using ImageMagick
# Requires: imagemagick (brew install imagemagick)
#
# Usage: bash generate_feature_graphic.sh

set -e

ICON="assets/icons/lakasir.png"
OUTPUT="store-assets/feature-graphic.png"
BG_COLOR="#FF6600"

mkdir -p store-assets

if ! command -v magick &> /dev/null; then
    echo "❌ ImageMagick is not installed."
    echo "   Install it with: brew install imagemagick"
    echo ""
    echo "Alternatively, create the feature graphic manually:"
    echo "   Size: 1024 x 500 px"
    echo "   Background: $BG_COLOR (orange)"
    echo "   Center: App icon (assets/icons/lakasir.png)"
    echo "   Text: 'lakasir POS' in bold white, 48px"
    echo "   Subtitle: 'Point of Sale' in white, 24px"
    exit 1
fi

if [ ! -f "$ICON" ]; then
    echo "❌ Icon not found: $ICON"
    exit 1
fi

FONT_BOLD=""
FONT_REGULAR=""

for FONT_PATH in \
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" \
    "/System/Library/Fonts/Supplemental/Arial Bold.ttf" \
    "/Library/Fonts/Arial Bold.ttf"; do
    if [ -f "$FONT_PATH" ]; then
        FONT_BOLD="$FONT_PATH"
        break
    fi
done

for FONT_PATH in \
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf" \
    "/System/Library/Fonts/Supplemental/Arial.ttf" \
    "/Library/Fonts/Arial.ttf"; do
    if [ -f "$FONT_PATH" ]; then
        FONT_REGULAR="$FONT_PATH"
        break
    fi
done

echo "🎨 Generating feature graphic..."
echo "   Icon: $ICON"
echo "   Background: $BG_COLOR"

magick -size 1024x500 xc:"$BG_COLOR" \
    \( "$ICON" -resize 200x200 \) \
    -gravity center -geometry +0-70 -composite \
    -font "$FONT_BOLD" -fill white -pointsize 48 \
    -gravity center -annotate +0+105 "lakasir POS" \
    -font "$FONT_REGULAR" -fill "rgba(255,255,255,0.85)" -pointsize 24 \
    -gravity center -annotate +0+155 "Point of Sale" \
    "$OUTPUT"

echo "✅ Feature graphic created: $OUTPUT"
echo "   Upload to Play Console → Store Listing → Feature Graphic"
