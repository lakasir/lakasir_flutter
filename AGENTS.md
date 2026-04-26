# Repository Guidelines

## Project Overview

Lakasir is a Flutter-based POS (point-of-sale) application that communicates with a Laravel backend API — but is designed to work **offline-first**. It supports product management, cashier transactions, cart handling, payment processing, member management, receipt printing (thermal + Sunmi POS hardware), and push notifications via Firebase Cloud Messaging. The local Isar database is the single source of truth; the server is an optional sync target for cloud backup and multi-device access. The app is fully functional without network connectivity.

- **Package**: `com.lakasir.lakasir`
- **Version**: 0.0.21
- **SDK**: Dart >=3.1.2 <4.0.0
- **License**: MIT

## Architecture & Data Flow

```
main.dart
  → Initializes: Isar DB, Firebase, dotenv, auth check, FCM, AppModeService, ConnectivityService, TransactionQueueService
  → GetMaterialApp (named routes, i18n)

Screen (GetView/StatelessWidget)
  → Controller (GetxController, .obs reactive state)
    → Repository (mode-switching: delegates to Offline or Online service)
      → OfflineService (Isar CRUD, no network needed)
      → OnlineService (API call + Isar cache, falls back to cache on failure)

Isar DB (single source of truth): Printer, Unit, OfflineUser, OfflineCategory, OfflineProduct, OfflineStock, OfflineMember, OfflinePaymentMethod, OfflinePendingTransaction, OfflineCart, SyncMetadata
SharedPreferences: auth token, domain URL, setup state, offline auth, offline user ID
ConnectivityService: monitors network, auto-switches AppMode (offline ↔ online)
TransactionQueueService: queues offline transactions, auto-syncs when online
```

**Key architectural decisions:**
- **Offline-first**: Isar is the single source of truth. The server is an optional sync target. All features work without network.
- **Dual-mode services**: Every entity has an `XxxServiceInterface` with `OfflineXxxService` (Isar CRUD) and `OnlineXxxService` (API + Isar cache). A `Repository` picks the implementation based on `AppModeService`.
- **AppMode enum**: `AppMode.offline` (no domain or no network) vs `AppMode.online` (domain + network). `AppModeService` and `ConnectivityService` auto-switch modes.
- **Transaction queue**: Offline transactions are stored as `OfflinePendingTransaction` and synced via `TransactionQueueService` when connectivity returns.
- **Negative local IDs**: Entities created offline get negative IDs (e.g., `-(count+1)`). On sync, server assigns positive IDs and local records are remapped.
- **`isLocal` flag**: Every offline model has `isLocal` (bool) marking records that need to be synced to the server.
- Controllers call Repositories, NOT services directly (migration in progress — some controllers still use old pattern)
- No DI framework beyond GetX — `Get.put()` / `Get.find()` for controllers; services registered as permanent GetX services
- API client created per request (`ApiService(await getDomain())`) — no singleton HTTP client
- Dynamic base URL resolved at runtime from SharedPreferences + dotenv (local vs production)
- Cart state persists across restarts via `OfflineCart` Isar collection (was in-memory only)
- API response models use hand-written `fromJson`/`toJson` — no freezed or json_serializable
- Isar models use generated code (`.g.dart` via `isar_generator` + `build_runner`)

## Key Directories

```
lib/
  main.dart              # Entry point, route definitions, app initialization, offline service registration
  my_app.dart            # Alternate MyApp widget (likely stale duplicate)
  messages.dart           # GetX Translations (en_US, id_ID)
  config/
    app.dart              # Reads BASE_URL, APP_ENV from dotenv
  api/
    api_service.dart      # Generic HTTP client wrapper (GET/POST/PUT/DELETE)
    requests/             # Request DTOs with toJson()/toQuery()
    responses/            # Response DTOs with fromJson(), generic wrappers
      api_response.dart   # ApiResponse<T>, DataWrapper<T>
      pagination_response.dart  # PaginationResponse<T>
      error_response.dart      # ErrorResponse<T>
      auths/ products/ transactions/ members/ categories/ carts/ ...
  controllers/            # GetX controllers organized by feature
    auths/                # AuthController, LoginController
    products/             # ProductController, ProductAddController, UnitController
    transactions/         # CartController, PaymentController, HistoryController
    members/              # MemberController, MemberAddController, MemberUpdateController
    profiles/             # ProfileController, ProfileEditController
    abouts/               # AboutController, AboutEditController
    settings/             # PrintController, SecureInitialPriceController
    CategoryController, NotificationController, SettingController, PaymentMethodController
  services/               # API service layer (one file per domain) — still used by OnlineService impls
  offline/                # ★ Offline-first architecture ★
    models/               # Isar models for offline data
      offline_user_model.dart     # OfflineUser — local auth with SHA-256 hashed passwords
      offline_models.dart         # OfflineCategory, OfflineProduct, OfflineStock
      (pending: member_model.dart, payment_method_model.dart, pending_transaction_model.dart, cart_model.dart, sync_metadata_model.dart)
    services/             # (pending) Dual-mode service implementations
      app_mode_service.dart       # AppModeService — tracks offline/online mode
      connectivity_service.dart   # ConnectivityService — monitors network changes
      offline_user_service.dart   # OfflineUserService — register & auth locally
      transaction_queue_service.dart # Queue offline transactions for sync
      offline_receipt_service.dart   # Generate OFF-YYYYMMDD-XXXX receipt numbers
      sync_service.dart            # Delta + full sync logic
      initial_sync_service.dart   # Offline→online first-time data upload
      background_sync.dart         # Workmanager periodic sync
      (pending: offline_product_service.dart, online_product_service.dart, etc.)
    repositories/         # (pending) Mode-switching repository layer
      product_repository.dart     # Delegates to Offline or Online service based on AppMode
      (pending: category_repository.dart, member_repository.dart, etc.)
  screens/                # UI screens organized by feature
    domain/               # Setup, domain registration, and OFFLINE REGISTRATION
      register_offline_user_screen.dart  # ★ New — register without server
    products/             # Product CRUD + detail
    transactions/         # Cashier, cart, payment, history, reports
    members/              # Member CRUD
    profile/ about/ setting/ notifications/
  widgets/                # Reusable UI components
    offline_status_bar.dart  # ★ ModeStatusBar — shows offline/online/sync status
  models/                 # Isar local DB models
    lakasir_database.dart  # Isar initializer — registers all schemas including offline models
    printer.dart           # Printer config (@collection)
    unit.dart              # Unit data (@collection)
  utils/                  # auth.dart (extended with offline auth helpers), utils.dart, colors.dart
  Exceptions/             # UnauthorizedException, ValidationException

test/                     # Single trivial test (effectively no coverage)
tasks/                    # Implementation task files (29 tasks for offline support)
tasks/refferences/        # OFFLINE_SUPPORT_PLAN.md — full architecture reference
.github/workflows/        # CI: build.yml (APK build + release on push to main)
android/                  # Firebase, release signing, compileSdk 35
ios/                      # Standard Podfile
```

## Development Commands

```bash
# Setup
flutter pub get                    # Install dependencies
mv .env.example .env               # Create env file (edit BASE_URL etc.)

# Code generation (Isar models — MUST run after changing offline model fields)
dart run build_runner build        # Generate .g.dart files
dart run build_runner watch        # Watch mode for generation

# Run
flutter run                        # Debug run
flutter run -d <device>            # Run on specific device

# Build
flutter build apk                  # Android APK (release)
flutter build ios                  # iOS build

# Analysis
flutter analyze                    # Static analysis
flutter test                       # Run tests (currently 1 trivial test)
flutter test test/widget_test.dart # Run single test file
```

### Offline Mode Development Notes

- After modifying any file in `lib/offline/models/`, you MUST run `dart run build_runner build` to regenerate `.g.dart` schemas.
- After adding new Isar schemas, you MUST register them in `LakasirDatabase.initialize()` in `lib/models/lakasir_database.dart`.
- The `OfflineUser` model uses SHA-256 password hashing via the `crypto` package — never store plain text passwords.
- New offline model fields should include `isLocal` (bool, default false) and `cachedAt` (DateTime?) for sync tracking.
- Entities created offline receive negative IDs (e.g., `-(count+1)`); server-assigned IDs are positive.
- The app uses `connectivity_plus` for network detection and `workmanager` for background sync.

## Code Conventions & Common Patterns

### Offline-First Architecture

The app operates in two modes controlled by `AppModeService`:

- **`AppMode.offline`**: No domain configured or no network. All CRUD goes through Isar only. Transactions are queued for later sync.
- **`AppMode.online`**: Domain configured + network available. API calls succeed; Isar is used as cache. Falls back to offline mode on network failure.

**Every entity has a dual-service pattern:**

```dart
// Service interface (contract)
abstract class ProductServiceInterface {
  Future<List<OfflineProduct>> getProducts({ProductRequest? request});
  Future<OfflineProduct?> getProductById(int id);
  Future<OfflineProduct> createProduct(OfflineProduct product);
  Future<OfflineProduct> updateProduct(OfflineProduct product);
  Future<void> deleteProduct(int id);
}

// Offline implementation — pure Isar CRUD
class OfflineProductService implements ProductServiceInterface { ... }

// Online implementation — API call + Isar cache fallback
class OnlineProductService implements ProductServiceInterface { ... }

// Repository — delegates based on AppModeService
class ProductRepository implements ProductServiceInterface {
  ProductServiceInterface get _service =>
      AppModeService.to.isOnline ? _onlineService : _offlineService;
}
```

**Authentication flow:**
- Offline user: registers locally → `OfflineUser` stored in Isar → logs in with hashed password
- Online user: domain setup → API login → token stored → falls back to offline credentials if network drops
- Mode switching: `ConnectivityService` auto-detects network changes and switches `AppMode`

**Sync strategy:**
- Offline→Online upgrade: `InitialSyncService` uploads all local data, remaps IDs, downloads server data
- Ongoing sync: `SyncService` uses `SyncMetadata.lastSyncAt` for delta sync
- Transaction queue: `TransactionQueueService` queues offline payments, retries up to 3 times.
- Background sync: `workmanager` periodic task every 15 minutes

See `tasks/refferences/OFFLINE_SUPPORT_PLAN.md` for the complete architecture reference.

### State Management — GetX

Controllers extend `GetxController`. Reactive state uses `.obs`:

```dart
class ProductController extends GetxController {
  var products = <ProductResponse>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    isLoading.value = true;
    // ...
  }
}
```

Screens access controllers via `Get.find<ControllerType>()` or `GetView<ControllerType>`.

### API Layer

**Controllers should call Repositories, not Services directly.** Repositories delegate to Offline or Online services based on `AppModeService`. Legacy controllers that still call services directly are being migrated.

Services create `ApiService` per call with dynamic domain:

```dart
class ProductService {
  Future<ApiResponse<List<ProductResponse>>> fetchProducts(
    PaginationRequest request,
  ) async {
    final apiService = ApiService(await getDomain());
    final response = await apiService.fetchData('products', request.toQuery());
    return ApiResponse<List<ProductResponse>>.fromJson(
      response, (data) => data.map((e) => ProductResponse.fromJson(e)).toList(),
    );
  }
}
```

Error handling in controllers follows this pattern:

```dart
try {
  await service.call(...);
} on UnauthorizedException {
  logout();
  Get.offAllNamed('/auth');
} on ValidationException catch (e) {
  // Handle field-level errors from e.errors
}
```

### Request/Response DTOs

- **Requests**: Plain classes with `toJson()` and `toQuery()` (for query params)
- **Responses**: Plain classes with `fromJson()` factory constructors
- **Generic wrappers**: `ApiResponse<T>`, `PaginationResponse<T>`, `ErrorResponse<T>`

### Routing

Named routes defined as a static map in `main.dart`. Navigation via GetX:

```dart
Get.toNamed('/menu/product');
Get.back();
Get.offAllNamed('/auth');  // Clear stack (logout)
```

### Internationalization

`lib/messages.dart` — `Messages extends Translations` with `en_US` and `id_ID` locale maps. Used via `tr('key')` in widgets.

### Naming & Formatting

- File names: `snake_case` (e.g., `product_controller.dart`)
- Classes: `PascalCase` (e.g., `ProductController`)
- Variables/methods: `camelCase`
- Strings: Prefer single quotes unless interpolation needed
- `const` constructors where possible
- `final` over `var` for immutable variables
- Import order: dart libraries → flutter → third-party packages → local imports

### Exceptions

Two custom exception types in `lib/Exceptions/`:
- `UnauthorizedException` — 401 responses, triggers logout
- `ValidationException` — 422/403 responses, carries field-level error map

## Important Files

| File | Purpose |
|---|---|
| `lib/main.dart` | Entry point, route table, app initialization, offline service registration |
| `lib/api/api_service.dart` | Generic HTTP client with auth and error handling |
| `lib/config/app.dart` | Environment config (BASE_URL, APP_ENV via dotenv) |
| `lib/utils/auth.dart` | Token storage, domain resolution, auth checks, **offline auth helpers** |
| `lib/utils/utils.dart` | formatPrice, locale helpers, receipt printing |
| `lib/utils/colors.dart` | App color constants (primary: #ff6600) |
| `lib/models/lakasir_database.dart` | Isar DB initializer (registers all schemas including offline models) |
| `lib/models/printer.dart` | Isar @collection for printer config |
| `lib/models/unit.dart` | Isar @collection for units |
| `lib/offline/models/offline_user_model.dart` | ★ OfflineUser — local auth with SHA-256 hashed passwords |
| `lib/offline/models/offline_models.dart` | ★ OfflineCategory, OfflineProduct, OfflineStock collections |
| `lib/controllers/transactions/cart_controller.dart` | Cart state, CartSession, CartItem classes |
| `lib/screens/auth_screen.dart` | Auth gate (onboarding/login/menu routing) |
| `lib/screens/menu_screen.dart` | Main menu hub with permission-gated items |
| `tasks/refferences/OFFLINE_SUPPORT_PLAN.md` | ★ Full offline-first architecture document |
| `.env.example` | Environment variable template |
| `pubspec.yaml` | Dependencies, assets, fonts |
| `analysis_options.yaml` | Lint config (flutter_lints) |
| `.github/workflows/build.yml` | CI: build APK + release on push to main |

## Runtime/Tooling Preferences

- **Flutter SDK**: 3.x (pinned via CI, `>=3.1.2` in pubspec)
- **Dart SDK**: >=3.1.2 <4.0.0
- **Package manager**: `flutter pub get` (no Bun/pnpm)
- **Code generation**: `dart run build_runner build` — for Isar `.g.dart` files (MUST run after offline model changes)
- **Linting**: `package:flutter_lints/flutter.yaml` (no custom rule overrides)
- **Env**: `flutter_dotenv` — `.env` file must exist (copy from `.env.example`)
- **Font**: SourceSans 3 + Poppins (bundled in `fonts/`)
- **Offline deps**: `connectivity_plus: ^6.0.0` (network detection), `crypto: ^3.0.3` (SHA-256 password hashing), `workmanager: ^0.9.0` (background sync)

## Testing & QA

- **Framework**: `flutter_test` (SDK-bundled)
- **Mocking**: None — no mockito, mocktail, or any mock library
- **Current coverage**: Effectively zero — single trivial test in `test/widget_test.dart`
- **Integration tests**: None
- **CI test step**: Absent — CI builds and releases but never runs `flutter test`
- **Static analysis**: `flutter analyze` (default flutter_lints rules)

When adding tests, consider:
- Adding `mocktail` or `mockito` to dev_dependencies
- Testing controllers by mocking `ApiService` or service layer
- Testing `fromJson`/`toJson` serialization on response models
- Adding a `flutter test` step to `.github/workflows/build.yml`

## Offline Mode — Implementation Status

The offline-first architecture is being implemented across 29 tasks (see `tasks/` directory). Current status:

| Task | Description | Status |
|------|-------------|--------|
| 01 | Add offline dependencies (connectivity_plus, crypto, workmanager) | ✅ Done |
| 02 | Create OfflineUser Isar model | ✅ Done |
| 03 | Create OfflineCategory, OfflineProduct, OfflineStock models | ✅ Done |
| 04 | Create OfflineMember, OfflinePaymentMethod models | ❌ Not started |
| 05 | Create PendingTransaction, Cart, SyncMetadata models | ❌ Not started |
| 06 | Update LakasirDatabase schemas | ⚠️ Partial (missing member, payment, transaction, cart, sync schemas) |
| 07–29 | Auth helpers, services, repositories, screens, sync, UI | ❌ Not started |

**What works now:**
- `OfflineUser` model with SHA-256 password hashing, `verifyPassword()`, `generateSalt()`
- `OfflineCategory`, `OfflineProduct`, `OfflineStock` Isar models with `isLocal` flag and `cachedAt`
- `OfflineProduct`↔`OfflineStock` IsarLinks relationship
- `LakasirDatabase` registers `OfflineUserSchema`, `OfflineCategorySchema`, `OfflineProductSchema`, `OfflineStockSchema`

**What's needed next (priority order):**
1. Complete Isar models (Member, PaymentMethod, PendingTransaction, Cart, SyncMetadata)
2. Create service interfaces + offline/online implementations + repositories
3. Add offline auth helpers to `utils/auth.dart`
4. Create AppModeService, ConnectivityService, OfflineUserService
5. Create RegisterOfflineUserScreen, update onboarding flow
6. Refactor controllers to use repositories instead of direct API calls
7. Implement TransactionQueueService, SyncService, BackgroundSyncService
8. Add ModeStatusBar UI, Connect to Server settings, translation keys

## Platform Notes

- **Android**: compileSdk 35, Java 17, AGP 8.3.0, Firebase integrated, release signing via `key.properties`
- **Thermal printing**: `blue_thermal_printer` (Bluetooth) and `sunmi_printer_plus` (Sunmi POS hardware) — Android-only
- **iOS**: Standard Podfile with `use_frameworks!`
- **Web/macOS/Windows/Linux**: Standard Flutter scaffolding, no custom platform code beyond Android