# Create RegisterOfflineUserScreen & Update Onboarding Flow

## Context
- files: @lib/screens/domain/register_offline_user_screen.dart (new), @lib/screens/onboard_screen.dart, @lib/screens/auth_screen.dart
- Currently the onboarding flow ends at `SetupScreen` (domain setup) or `RegisterDomainScreen` (new domain). There's no way to use the app without a server. We need a new `RegisterOfflineUserScreen` and an updated onboarding flow that offers a choice: "Use Offline" or "Connect to Server".

## Goals
- Create `RegisterOfflineUserScreen` — a form with fields: shop name, full name, email, password. On submit, calls `OfflineUserService.register()`, stores offline auth, seeds default data, then navigates to `/auth`
- Update `OnboardingScreen` — on the last page, instead of going directly to `SetupScreen`, show a mode chooser with two options:
  - "Use Offline" → navigates to `RegisterOfflineUserScreen`
  - "Connect to Server" → navigates to `SetupScreen` (existing flow)
- Add route `/auth/offline-register` to the app's route map in `main.dart`
- The offline registration form should show an "Offline Mode" badge to indicate no server is needed

## Notes
- `RegisterOfflineUserScreen` should follow the same UI patterns as `RegisterDomainScreen` (same layout, same widgets: `MyTextField`, `MyFilledButton`, `Layout`)
- During registration, call `OfflineUserService.register()` then `storeOfflineAuth(true)` then `storeSetup('offline')` to mark the app as set up
- After registration, seed default payment methods (Cash, Debit, Credit, E-Wallet) into Isar — this is needed so the POS can function immediately
- The `OnboardingScreen` currently navigates to `SetupScreen` via `Get.to(const SetupScreen())` on the last page. This needs to be replaced with the mode chooser UI.
- The mode chooser can be a simple dialog or a new last page in the onboarding flow — recommend a new last page for better UX.
- Add translation keys: `offline_mode`, `use_offline`, `connect_to_server`, `create_your_shop`, `field_shop_name`, `field_full_name`, `field_email`, `field_password` (some may already exist)

## Tools / Skills
- Flutter UI, GetX navigation, Isar writes, OfflineUserService

## Implementation
- Created `lib/screens/domain/register_offline_user_screen.dart`
  - Form with: shop name, full name, email, password, password confirmation
  - "Offline Mode" badge shown at top using orange container with primary border
  - On submit: calls `OfflineUserService.register()`, seeds default payment methods, then stores setup flags directly via SharedPreferences (NOT `storeSetup()` — see bug fix below)
  - Seeds 4 default `OfflinePaymentMethod` entries (Cash, Debit, Credit, E-Wallet) with `isLocal=true`
  - Navigates to `/auth` via `Get.offAllNamed('/auth')`
- Created `ModeChooserScreen` inside `lib/screens/onboard_screen.dart`
  - Two buttons: "Use Offline" (filled, routes to `/auth/offline-register`) and "Connect to Server" (outlined, routes to `SetupScreen`)
  - OnboardingScreen last page and OnboardingPage "Get Started" button now navigate to `/auth/mode-chooser` route
- Added routes in `main.dart`: `/auth/offline-register`, `/auth/mode-chooser`
- Added translation keys in `messages.dart` (en_US + id_ID): `offline_mode`, `use_offline`, `use_offline_description`, `connect_to_server`, `connect_to_server_description`, `setup_choose_mode`, `field_full_name`

### Bug fix: storeSetup('offline') cleared offline auth
`storeSetup()` calls `logout()` which clears `offline_auth` and `offline_user_id`. After registration, `checkAuthentication()` saw `isOfflineAuthenticated() == false` and routed to login screen instead of menu. Fixed by storing setup flags directly:
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('setup', true);
await prefs.setString('domain', 'offline');
```
This preserves the offline auth state set by `OfflineUserService.register()`.