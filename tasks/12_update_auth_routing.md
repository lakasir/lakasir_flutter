# Update AuthScreen Routing for Offline-First

## Context
- files: @lib/screens/auth_screen.dart, @lib/utils/auth.dart
- Currently `AuthScreen` calls `checkAuthentication()` which returns "setup" → onboarding, "login" → login screen, "menu" → menu screen. This doesn't account for offline users who have no domain but are authenticated locally. The routing needs to include the new offline register route.

## Goals
- Ensure `checkAuthentication()` (updated in task 07) correctly routes:
  - Offline authenticated user → "menu"
  - Offline not authenticated → "setup" (which now offers offline or online choice)
  - Online authenticated user → "menu"
  - Online not authenticated → "login"
- Add route `/auth/offline-register` mapping to `RegisterOfflineUserScreen` in `main.dart`
- Verify the full auth flow works end-to-end: 
  1. Fresh install → onboarding → choose offline → register → login → menu
  2. Fresh install → onboarding → choose online → setup domain → login → menu
  3. Existing online user → login → menu (no changes)

## Notes
- This task is mostly verification since `checkAuthentication()` changes are in task 07 and the route addition is in task 10
- The key thing is to make sure the routing chain works: `AuthScreen` → `checkAuthentication()` → correct screen
- `storeSetup('offline')` must be handled by `isSetup()` correctly — it stores `true` for the boolean and `'offline'` for the domain. The `isSetup()` function only checks the boolean, which is correct.
- When in offline mode, `getDomain()` will return `'offline'` or empty — API calls should NOT be made in this case. The `AppModeService` will prevent API calls via the repository pattern (task 13+).

## Tools / Skills
- Flutter routing, auth flow

## Implementation
<!-- Write you've done in here -->