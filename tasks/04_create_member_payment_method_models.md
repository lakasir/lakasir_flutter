# Create Member & PaymentMethod Models

## Context
- files: @lib/offline/models/member_model.dart (new), @lib/offline/models/payment_method_model.dart (new)
- Members and payment methods are currently fetched via API (`MemberService`, `PaymentMethodService`) with no local persistence. These need to be cached in Isar for offline access. Payment methods are mostly read-only and can be seeded with defaults for offline users.

## Goals
- Create `OfflineMember` Isar collection with fields: `id` (int), `name`, `code` (nullable), `address` (nullable), `email` (nullable), `createdAt`, `updatedAt`, `cachedAt`, `isLocal` (bool)
- Create `OfflinePaymentMethod` Isar collection with fields: `id` (int), `name`, `icon` (nullable), `isCash` (bool), `isDebit` (bool), `isCredit` (bool), `isWallet` (bool), `cachedAt`, `isLocal` (bool)
- Include `part '*.g.dart'` and run `build_runner`

## Notes
- Members are search-heavy — the `code` field is used for member lookup during transactions
- Payment methods are mostly read-only; offline users get 4 seeded defaults: Cash, Debit, Credit, E-Wallet
- The existing `PaymentMethodRespone` (note the typo in the current codebase) maps to `OfflinePaymentMethod`

## Tools / Skills
- Dart Isar model creation

## Implementation
<!-- Write you've done in here -->