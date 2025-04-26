#!/bin/bash
#
# prepare_build_and_compile.sh
#
# Full automation: clean bad NFC references, sync, setup environment, and build ROM
#
# Usage:
#   ./prepare_build_and_compile.sh
#

echo "==== Starting Full Build Automation ===="

# Part 1: Clean bad multi.android.hardware.nfc@1.2-service.rc references
echo "Step 1: Cleaning multi.android.hardware.nfc@1.2-service.rc references..."

TARGET_DIR="device/samsung/"

if [ -d "$TARGET_DIR" ]; then
    grep -rl "multi.android.hardware.nfc@1.2-service.rc" "$TARGET_DIR" | while read -r file; do
        echo "Cleaning: $file"
        sed -i.bak '/multi\.android\.hardware\.nfc@1\.2-service\.rc/d' "$file"
    done
    echo "Reference cleaning complete!"
else
    echo "WARNING: Target directory $TARGET_DIR not found, skipping cleaning step."
fi

# Part 2: Repo sync
echo "Step 2: Syncing repos with repo sync -c..."
repo sync -c --force-sync --optimized-fetch --prune -j$(nproc --all)

echo "Repo sync complete!"

# Part 3: Clean out/ (optional)
read -p "Do you want to clean out/ folder before building? (y/N): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Cleaning out/ folder..."
    rm -rf out/
    echo "out/ cleaned!"
else
    echo "Skipping out/ cleaning."
fi

# Part 4: Build setup
echo "Step 4: Setting up environment..."

source build/envsetup.sh

# Part 5: Choose lunch target
echo "Step 5: Choosing lunch target..."

read -p "Enter your lunch target (example: lineage_r8q-userdebug): " LUNCH_TARGET

lunch "$LUNCH_TARGET"

# Part 6: Start building
echo "Step 6: Starting build..."

read -p "Do you want to build full ROM (bacon) or only boot image (bootimage)? (bacon/bootimage): " BUILD_TYPE

if [[ "$BUILD_TYPE" == "bootimage" ]]; then
    mka bootimage
else
    mka bacon
fi

echo "==== Full automation done! Check your out/target/product directory! ===="