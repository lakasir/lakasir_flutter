# Update LoginScreen & LoginController for Dual-Mode Auth

## Context
- files: @lib/screens/login_screen.dart, @lib/controllers/auths/login_controller.dart
- Currently `LoginController` only authenticates via the API (`LoginService`). The login screen only shows email/password fields with a "Forgot Password" link. We need both to support offline authentication (against Isar `OfflineUser`) and online authentication, with automatic fallback.

## Goals
- Update `LoginController.login()` to support dual-mode auth:
  1. If `isOfflineMode()` is true → authenticate via `OfflineUserService.login()`
  2. If `isOnlineMode()` (has domain) AND network available → try online login, if it fails → try offline fallback
  3. If `isOnlineMode()` BUT network unavailable → try offline fallback
- On successful offline login, call `AppModeService.to.switchToOffline()`
- On successful online login, call `AppModeService.to.switchToOnline()`
- Update `LoginScreen` to show an "Offline Mode" indicator or "Login Offline" link when the user has offline credentials but the domain is unreachable
- Keep all existing online login behavior intact (error handling, form validation, remember me)

## Notes
- The `LoginController` currently uses `LoginService` directly. We're adding `OfflineUserService` as an alternative auth path, NOT replacing the existing service.
- Import `OfflineUserService`, `isOfflineMode`, `ConnectivityService` as needed
- On offline login success: `storeOfflineAuth(true)`, `storeOfflineUserId(user.id)`, navigate to `/auth`
- On online login success (existing flow): `storeToken()`, navigate to `/auth`
- The `LoginErrorResponse` handling for online login errors should remain unchanged
- Don't add a separate "Offline Login" button — the same login form should work for both modes, automatically choosing the right path based on connectivity
- Consider adding a subtle mode label near the sign-in button (e.g., "Sign In (Offline)" when in offline mode)

## Tools / Skills
- GetX controllers, OfflineUserService, ConnectivityService, auth helpers

## Implementation
- Updated `lib/controllers/auths/login_controller.dart`
  - Added `isOfflineLogin` RxBool observable
  - `_detectMode()` called in `onInit()`: checks `isOfflineMode()` then `hasDomain()` then `ConnectivityService.checkConnection()` to set `isOfflineLogin`
  - `login()` routes based on mode:
    1. `isOfflineMode()` → `_loginOffline()`
    2. No domain → `_loginOffline()`
    3. Has domain + connected → `_loginOnline()` with try/catch fallback to `_loginOfflineFallback()`
    4. Has domain + not connected → `_loginOfflineFallback()`
  - `_loginOnline()` — existing `LoginService.login()` flow + `AppModeService.switchToOnline()`
  - `_loginOffline()` — `OfflineUserService.login()` + `AppModeService.switchToOffline()`
  - `_loginOfflineFallback()` — same as offline but used as fallback when online fails
- Updated `lib/screens/login_screen.dart`
  - Shows "Offline Mode" badge when `isOfflineLogin` is true
  - Sign-in button text changes to `Sign In (Offline Mode)` when offline
  - Hides "Remember Me" checkbox and "Forgot Password" link when in offline mode

### Bug fix: AuthController infinite loading in offline mode
`MenuScreen` calls `AuthController.fetchPermissions()` which calls `ProfileService.get()` (API call). With domain `'offline'`, the request fails/throws, leaving `loading = true` forever (CircularProgressIndicator never resolves). Fixed in `AuthController`:
```dart
void fetchPermissions() async {
    loading(true);
    final offline = await isOfflineMode();
    if (offline) {
      loading(false);
      return;
    }
    try {
      await _profileController.getProfile();
      // ... existing permissions/features logic
    } catch (_) {
      // In offline mode or network failure, skip permissions fetching
    }
    loading(false);
}
```