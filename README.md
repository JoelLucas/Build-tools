# Build Preparation Scripts

Scripts to automate cleaning device tree issues, syncing sources, and building custom ROMs efficiently.

## Scripts Included

### 1. `clean_multi_nfc.sh`

- Cleans any bad references to `multi.android.hardware.nfc@1.2-service.rc` inside your `device/samsung/` directory.
- Automatically removes outdated NFC entries that may cause build conflicts.
- Creates backup files (`.bak`) for safety.

**Usage:**
```bash
chmod +x clean_multi_nfc.sh
./clean_multi_nfc.sh