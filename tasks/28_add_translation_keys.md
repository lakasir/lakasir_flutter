# Add Translation Keys for Offline UI

## Context
- files: @lib/messages.dart
- The app uses `GetX` translations via `Messages` class. New offline UI screens and widgets need translation keys for multi-language support. The app currently supports English and Indonesian based on the `.tr` calls throughout the codebase.

## Goals
- Add all new translation keys needed for offline support:
  - `offline_mode` — "Offline Mode" / "Mode Offline"
  - `use_offline` — "Use Offline" / "Gunakan Offline"
  - `connect_to_server` — "Connect to Server" / "Hubungkan ke Server"
  - `connect_to_server_description` — "Sync your data to the cloud" / "Sinkronkan data Anda ke cloud"
  - `login_offline` — "Login Offline" / "Masuk Offline"
  - `choose_mode` — "Choose Mode" / "Pilih Mode"
  - `choose_mode_description` — "Use offline without server or connect to an existing server" / "Gunakan offline tanpa server atau hubungkan ke server yang ada"
  - `no_connection` — "No connection" / "Tidak ada koneksi"
  - `no_connection_cached` — "No connection — using cached data" / "Tidak ada koneksi — menggunakan data cache"
  - `no_connection_pending` — "No connection — {count} transactions queued" / "Tidak ada koneksi — {count} transaksi antrean"
  - `syncing_pending` — "Syncing {count} pending transactions..." / "Menyinkronkan {count} transaksi tertunda..."
  - `sync_now` — "SYNC NOW" / "SINKRONKAN"
  - `field_shop_name` — may already exist, verify
  - `field_full_name` — may already exist, verify
  - `field_password_confirmation` — may already exist, verify

## Notes
- The `messages.dart` file likely uses a map structure for translations. Add keys in the appropriate language map.
- Don't break existing translations — only add new keys
- Use the same `.tr` pattern used throughout the app for accessing translations
- Some keys like `field_email`, `field_password`, `sign_in`, `sign_up`, `create_your_shop` likely already exist

## Tools / Skills
- GetX translations, i18n

## Implementation
<!-- Write you've done in here -->