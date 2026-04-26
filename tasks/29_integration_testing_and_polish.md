# End-to-End Integration Testing & Polish

## Context
- files: all modified/new files
- After all previous tasks are implemented, we need to verify the full offline-first flow works end-to-end and polish edge cases. This is the validation task that ensures all pieces fit together.

## Goals
- Test the complete offline registration flow: onboarding → choose offline → register → login → menu
- Test the complete online registration flow: onboarding → connect to server → setup domain → login → menu (unchanged)
- Test offline-to-online upgrade: settings → connect to server → initial sync → online mode
- Test network drop during online session: automatic switch to offline, cart preserved
- Test network recovery: automatic switch back to online, pending transactions sync
- Test cart persistence: add items to cart → kill app → reopen → cart preserved
- Test transaction queue: process payment offline → view pending count in status bar → go online → transactions sync
- Verify mode indicator shows correctly in all states
- Verify no crashes when accessing features in offline mode
- Verify Isar database opens correctly with all schemas
- Run `dart run build_runner build` to ensure all generated code is up to date

## Notes
- This task is about verification and bug-fixing, not new feature code
- Common issues to watch for:
  - `GetX` service not found errors — ensure all permanent services are registered
  - Isar schema conflicts — ensure all models generated correctly
  - Type mismatches between `ProductResponse` and `OfflineProduct` in UI code
  - Null safety issues — `OfflineProduct` fields may be non-nullable where `ProductResponse` had nullable fields
  - Controllers not finding repositories — ensure `Get.put()` or `Get.lazyPut()` is called before the controller is used
  - Route not found — ensure all new routes are registered in `main.dart`
  - Auth flow infinite loop — ensure `checkAuthentication()` doesn't loop between screens
- For testing offline behavior on a real device or emulator: use airplane mode or disable WiFi/data
- For testing sync: toggle airplane mode on/off and watch the status bar

## Tools / Skills
- Flutter debugging, integration testing, Isar inspector

## Implementation
<!-- Write you've done in here -->