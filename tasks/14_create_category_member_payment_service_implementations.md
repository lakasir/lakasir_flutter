# Create Category, Member, PaymentMethod Service Interfaces & Implementations

## Context
- files: @lib/offline/services/category_service_interface.dart (new), @lib/offline/services/offline_category_service.dart (new), @lib/offline/services/online_category_service.dart (new), @lib/offline/repositories/category_repository.dart (new), same pattern for member and payment_method, @lib/services/category_service.dart, @lib/services/member_service.dart, @lib/services/payment_method_service.dart
- Following the same pattern as the product service (task 13), we need dual-mode services for Category, Member, and PaymentMethod. These are simpler entities than Product — they have basic CRUD operations and no complex relationships.

## Goals
- Create Category service interface → `OfflineCategoryService` + `OnlineCategoryService` + `CategoryRepository`
- Create Member service interface → `OfflineMemberService` + `OnlineMemberService` + `MemberRepository`
- Create PaymentMethod service interface → `OfflinePaymentMethodService` + `OnlinePaymentMethodService` + `PaymentMethodRepository`
- Each interface follows the same pattern as `ProductServiceInterface`:
  - `getAll()` / `getById()` / `create()` / `update()` / `delete()`
  - Offline implementations use Isar CRUD with `isLocal=true` for creates
  - Online implementations try API first, cache to Isar, fall back to cache
  - Repositories delegate based on `AppModeService.to.isOnline`

## Notes
- `CategoryService` currently returns `RxList<CategoryResponse>` — the offline interface should return `List<OfflineCategory>` instead
- `MemberService` supports query params via `MemberRequest` — the offline implementation should filter by `name` and `code` using Isar filters
- `PaymentMethodService` is read-only in the current codebase (only `get()`) — the offline implementation only needs `getAll()` for now, but we add `create`/`update`/`delete` stubs for completeness
- Payment methods are seeded with defaults for offline users (Cash, Debit, Credit, E-Wallet) — this is handled by `RegisterOfflineUserScreen`, not the service
- The existing API service classes (`CategoryService`, `MemberService`, `PaymentMethodService`) remain and are used by the online implementations

## Tools / Skills
- Isar CRUD, API wrapping, Repository pattern

## Implementation
<!-- Write you've done in here -->