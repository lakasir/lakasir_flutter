# Add Offline Auth Helpers to utils/auth.dart

## Context
- files: @lib/utils/auth.dart
- Currently `auth.dart` handles token storage, domain setup, and `checkAuthentication()` which routes the app to onboarding, login, or menu. It only supports online auth (token-based). The offline-first design needs: offline user ID storage, offline auth state, offline mode detection, and updated `checkAuthentication()` logic.

## Goals
- Add `storeOfflineUserId(int id)` — stores offline user ID in SharedPreferences key `offline_user_id`
- Add `getOfflineUserId()` — retrieves offline user ID from SharedPreferences
- Add `storeOfflineAuth(bool value)` — stores offline authentication state in key `offline_auth`
- Add `isOfflineAuthenticated()` — checks if user is authenticated offline
- Add `isOfflineMode()` — returns `true` if app has no domain configured (i.e., `!(await isSetup())`)
- Update `checkAuthentication()` to handle offline-first routing:
  - If setup exists AND token exists → "menu"
  - If setup exists BUT no token → check offline auth: if `isOfflineAuthenticated()` → "menu", else → "login"
  - If no setup → check if offline auth exists: if `isOfflineAuthenticated()` → "menu", else → "setup"
- Add `hasDomain()` helper — returns `true` if domain string is non-empty after `isSetup()` returns true

## Notes
- The updated `checkAuthentication()` is critical — it determines the entire app entry flow
- Previously: no setup → "setup" (onboarding), setup but no token → "login", setup + token → "menu"
- New flow honors offline users: no setup but offline auth → "menu", setup but network down + offline auth → "menu"
- Preserve all existing functions (`logout`, `storeToken`, `getToken`, `getDomain`, `isSetup`, `storeSetup`, `can`, `destroySetup`) — they are still used by online flows
- `storeSetup('offline')` will mark the app as setup in offline mode — this value is checked by `isSetup()` which just checks the boolean, not the value of the domain string

## Tools / Skills
- SharedPreferences, auth flow design

## Implementation
- Added storeOfflineUserId(int id) — stores to SharedPreferences key 'offline_user_id'
- Added getOfflineUserId() — retrieves from SharedPreferences key 'offline_user_id'
- Added storeOfflineAuth(bool value) — stores to SharedPreferences key 'offline_auth'
- Added isOfflineAuthenticated() — checks SharedPreferences key 'offline_auth' (defaults to false)
- Added isOfflineMode() — returns true when domain is null, empty, or 'offline'
- Added hasDomain() — returns true if setup is done and domain string is non-empty
- Updated checkAuthentication() with offline-first routing:
  - setup + token → "menu" (online auth, unchanged)
  - setup + no token + offline auth → "menu" (offline user can still access menu)
  - setup + no token + no offline auth → "login" (needs online login)
  - no setup + offline auth → "menu" (offline user bypasses setup)
  - no setup + no offline auth → "setup" (new user needs onboarding)
- Updated logout() to also clear offline_auth and offline_user_id SharedPreferences keys
- Preserved all existing functions: logout, storeToken, getToken, getDomain, isSetup, storeSetup, can, destroySetup

### Bug fix: isOfflineMode() logic was wrong
Original implementation `!(await isSetup())` returned `false` after offline registration (setup=true, domain='offline'), making the app think it was in online mode. Fixed to check the domain value:
```dart
Future<bool> isOfflineMode() async {
  final prefs = await SharedPreferences.getInstance();
  final domain = prefs.getString('domain');
  return domain == null || domain.isEmpty || domain == 'offline';
}
```
This correctly returns `true` when the app is configured for offline use (domain='offline') or not yet set up (no domain).