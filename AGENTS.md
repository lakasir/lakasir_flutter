# Repository Guidelines

## Project Overview

Lakasir is a Flutter-based POS (point-of-sale) application that communicates with a Laravel backend API. It supports product management, cashier transactions, cart handling, payment processing, member management, receipt printing (thermal + Sunmi POS hardware), and push notifications via Firebase Cloud Messaging. Local persistence uses Isar for printer configuration and unit data.

- **Package**: `com.lakasir.lakasir`
- **Version**: 0.0.21
- **SDK**: Dart >=3.1.2 <4.0.0
- **License**: MIT

## Architecture & Data Flow

```
main.dart
  → Initializes: Isar DB, Firebase, dotenv, auth check, FCM
  → GetMaterialApp (named routes, i18n)

Screen (GetView/StatelessWidget)
  → Controller (GetxController, .obs reactive state)
    → Service (instantiates ApiService per call)
      → ApiService<T> (http package, Bearer auth, error mapping)
        → Laravel Backend API

Isar DB (local only): Printer config, Unit data
SharedPreferences: auth token, domain URL, setup state
```

**Key architectural decisions:**
- No repository layer — controllers call services directly
- No DI framework beyond GetX — `Get.put()` / `Get.find()` for controllers; services instantiated inline
- API client created per request (`ApiService(await getDomain())`) — no singleton HTTP client
- Dynamic base URL resolved at runtime from SharedPreferences + dotenv (local vs production)
- Cart state lives inside `CartController` (`CartSession` / `CartItem` classes defined there, not in `models/`)
- API models use hand-written `fromJson`/`toJson` — no freezed or json_serializable
- Isar models are the only generated code (`.g.dart` via `isar_generator` + `build_runner`)

## Key Directories

```
lib/
  main.dart              # Entry point, route definitions, app initialization
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
  services/               # API service layer (one file per domain)
  screens/                # UI screens organized by feature
    domain/               # Setup and domain registration
    products/             # Product CRUD + detail
    transactions/         # Cashier, cart, payment, history, reports
    members/              # Member CRUD
    profile/ about/ setting/ notifications/
  widgets/                # Reusable UI components
  models/                 # Isar local DB models (Printer, Unit)
  utils/                  # auth.dart, utils.dart, colors.dart
  Exceptions/             # UnauthorizedException, ValidationException

test/                     # Single trivial test (effectively no coverage)
.github/workflows/        # CI: build.yml (APK build + release on push to main)
android/                  # Firebase, release signing, compileSdk 35
ios/                      # Standard Podfile
```

## Development Commands

```bash
# Setup
flutter pub get                    # Install dependencies
cp .env.example .env               # Create env file (edit BASE_URL etc.)

# Code generation (Isar models only)
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

## Code Conventions & Common Patterns

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
| `lib/main.dart` | Entry point, route table, app initialization |
| `lib/api/api_service.dart` | Generic HTTP client with auth and error handling |
| `lib/config/app.dart` | Environment config (BASE_URL, APP_ENV via dotenv) |
| `lib/utils/auth.dart` | Token storage, domain resolution, auth checks |
| `lib/utils/utils.dart` | formatPrice, locale helpers, receipt printing |
| `lib/utils/colors.dart` | App color constants (primary: #ff6600) |
| `lib/models/lakasir_database.dart` | Isar DB initializer |
| `lib/models/printer.dart` | Isar @collection for printer config |
| `lib/models/unit.dart` | Isar @collection for units |
| `lib/controllers/transactions/cart_controller.dart` | Cart state, CartSession, CartItem classes |
| `lib/screens/auth_screen.dart` | Auth gate (onboarding/login/menu routing) |
| `lib/screens/menu_screen.dart` | Main menu hub with permission-gated items |
| `.env.example` | Environment variable template |
| `pubspec.yaml` | Dependencies, assets, fonts |
| `analysis_options.yaml` | Lint config (flutter_lints) |
| `.github/workflows/build.yml` | CI: build APK + release on push to main |

## Runtime/Tooling Preferences

- **Flutter SDK**: 3.x (pinned via CI, `>=3.1.2` in pubspec)
- **Dart SDK**: >=3.1.2 <4.0.0
- **Package manager**: `flutter pub get` (no Bun/pnpm)
- **Code generation**: `dart run build_runner build` — only for Isar `.g.dart` files
- **Linting**: `package:flutter_lints/flutter.yaml` (no custom rule overrides)
- **Env**: `flutter_dotenv` — `.env` file must exist (copy from `.env.example`)
- **Font**: SourceSans 3 + Poppins (bundled in `fonts/`)

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

## Platform Notes

- **Android**: compileSdk 35, Java 17, AGP 8.3.0, Firebase integrated, release signing via `key.properties`
- **Thermal printing**: `blue_thermal_printer` (Bluetooth) and `sunmi_printer_plus` (Sunmi POS hardware) — Android-only
- **iOS**: Standard Podfile with `use_frameworks!`
- **Web/macOS/Windows/Linux**: Standard Flutter scaffolding, no custom platform code beyond Android