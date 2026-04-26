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
<!-- Write you've done in here -->