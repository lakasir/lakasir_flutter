# Flutter App: Image Upload Strategy Update Plan

## Background

The backend has been refactored from **URL-based** to **ID-based** file upload lookups. Previously, the Flutter app sent full URLs (e.g. `https://lakasir-app.test/tmp/abc123.jpg`) between upload and entity creation. Now, the upload endpoint returns an `UploadedFile` ID, and the app sends that ID when creating/updating products, profiles, and about pages.

**Why?** URL-based matching was fragile — it required parsing URLs back into relative paths, broke across different storage drivers (local vs S3), and involved complex fallback lookups. The ID-based approach is simple: upload → get ID → send ID.

---

## API Changes Summary

### 1. Upload Endpoint

**`POST /api/temp/upload`**

Response **before**:
```json
{
  "success": true,
  "data": {
    "name": "abc123.jpg",
    "relative_path": "abc123.jpg",
    "url": "https://lakasir-app.test/tmp/abc123.jpg",
    "original_name": "photo.jpg"
  }
}
```

Response **after** (new `id` field):
```json
{
  "success": true,
  "data": {
    "id": 11,
    "name": "abc123.jpg",
    "relative_path": "abc123.jpg",
    "url": "https://lakasir-app.test/tmp/abc123.jpg",
    "original_name": "photo.jpg"
  }
}
```

### 2. Product Creation/Update

**`POST /api/master/product`** and **`PUT /api/master/product/{id}`**

| Field                    | Before                | After                              |
|--------------------------|-----------------------|------------------------------------|
| `hero_images_url`        | `string` (full URL)  | **removed**                        |
| `hero_images_uploaded_file_id` | —              | `int` (UploadedFile ID, nullable) |

Example **before**:
```json
{
  "name": "Product Name",
  "category": 1,
  "hero_images_url": "https://lakasir-app.test/tmp/abc123.jpg",
  ...
}
```

Example **after**:
```json
{
  "name": "Product Name",
  "category": 1,
  "hero_images_uploaded_file_id": 11,
  ...
}
```

### 3. Profile Update

**`PUT /api/auth/me`** (or profile endpoint)

| Field              | Before                | After                              |
|--------------------|-----------------------|------------------------------------|
| `photo_url`        | `string` (full URL)  | **removed**                        |
| `uploaded_file_id` | —                     | `int` (UploadedFile ID, nullable)  |

Example **after**:
```json
{
  "name": "John",
  "email": "john@example.com",
  "uploaded_file_id": 11,
  ...
}
```

### 4. About Update

**`PUT /api/about`**

| Field              | Before                | After                              |
|--------------------|-----------------------|------------------------------------|
| `photo_url`        | `string` (full URL)  | **removed**                        |
| `uploaded_file_id` | —                     | `int` (UploadedFile ID, nullable)  |

Example **after**:
```json
{
  "shop_name": "My Shop",
  "shop_location": "123 Street",
  "business_type": "retail",
  "uploaded_file_id": 11,
  ...
}
```

---

## Flutter App Changes

### A. Upload Service / Repository

The core upload flow stays the same (multipart file upload), but **persist the returned `id`** instead of just the `url`.

**Before:**
```dart
Future<String> uploadImage(File image) async {
  final response = await _dio.post('/api/temp/upload', data: FormData.fromMap({...}));
  return response.data['data']['url']; // Returned full URL
}
```

**After:**
```dart
class UploadedFile {
  final int id;
  final String url;
  final String name;
  final String originalName;
  // ...
}

Future<UploadedFile> uploadImage(File image) async {
  final response = await _dio.post('/api/temp/upload', data: FormData.fromMap({...}));
  final data = response.data['data'];
  return UploadedFile(
    id: data['id'],            // ← Store this!
    url: data['url'],          // Still useful for preview
    name: data['name'],
    originalName: data['original_name'],
  );
}
```

### B. Product Creation/Update

**Before:**
```dart
Future<void> createProduct({required String name, String? heroImageUrl, ...}) async {
  await _dio.post('/api/master/product', data: {
    'name': name,
    'hero_images_url': heroImageUrl,  // Full URL
    ...
  });
}
```

**After:**
```dart
Future<void> createProduct({required String name, int? heroImageUploadedFileId, ...}) async {
  await _dio.post('/api/master/product', data: {
    'name': name,
    'hero_images_uploaded_file_id': heroImageUploadedFileId,  // ID from upload
    ...
  });
}
```

**Flow in the UI:**
1. User taps "Add Photo" → selects image
2. App calls `uploadImage(file)` → receives `UploadedFile(id: 11, url: ...))`
3. App displays `url` as a preview thumbnail
4. User fills in product details and taps "Create"
5. App sends `hero_images_uploaded_file_id: 11` in the create request

### C. Profile Update

**Before:**
```dart
Future<void> updateProfile({String? name, String? photoUrl, ...}) async {
  await _dio.put('/api/auth/me', data: {
    'name': name,
    'photo_url': photoUrl,  // Full URL
    ...
  });
}
```

**After:**
```dart
Future<void> updateProfile({String? name, int? uploadedFileId, ...}) async {
  await _dio.put('/api/auth/me', data: {
    'name': name,
    'uploaded_file_id': uploadedFileId,  // ID from upload
    ...
  });
}
```

### D. About Update

**Before:**
```dart
Future<void> updateAbout({String? shopName, String? photoUrl, ...}) async {
  await _dio.put('/api/about', data: {
    'shop_name': shopName,
    'photo_url': photoUrl,  // Full URL
    ...
  });
}
```

**After:**
```dart
Future<void> updateAbout({String? shopName, int? uploadedFileId, ...}) async {
  await _dio.put('/api/about', data: {
    'shop_name': shopName,
    'uploaded_file_id': uploadedFileId,  // ID from upload
    ...
  });
}
```

### E. Handling "No Change" (User keeps existing image)

When the user views an existing product/profile/about and doesn't change the image, **don't send the image field at all**. The backend will keep the existing image.

```dart
// If user did NOT pick a new image, simply omit the field:
final data = {
  'name': name,
  // Don't include hero_images_uploaded_file_id
};
```

To remove an image, send `null`:
```dart
final data = {
  'name': name,
  'hero_images_uploaded_file_id': null,  // Remove image
};
```

---

## Response Fields (No Changes Needed)

The **response** fields from the API remain the same — `hero_images` and `photo` still return full URLs for display. No changes needed to how the Flutter app renders images.

| Endpoint              | Image field in response            | Format                              |
|-----------------------|-------------------------------------|-------------------------------------|
| Product list/show     | `hero_images`                       | Array of full URLs                  |
| Profile show          | `photo`                             | Full URL (nullable)                |
| About show            | `photo_url`                         | Full URL (nullable)                 |

These are **computed server-side** from relative paths — they work regardless of storage driver. The app can keep using `CachedNetworkImage` or equivalent to display them.

---

## Migration Checklist for Flutter Devs

- [ ] Update `uploadImage()` to return `UploadedFile` object (with `id`, not just `url`)
- [ ] Update product create/update model: replace `hero_images_url` (String) with `hero_images_uploaded_file_id` (int?)
- [ ] Update profile update model: replace `photo_url` (String) with `uploaded_file_id` (int?)
- [ ] Update about update model: replace `photo_url` (String) with `uploaded_file_id` (int?)
- [ ] Store `UploadedFile.id` after each upload for use in subsequent create/update calls
- [ ] When user doesn't change image, omit the `*_uploaded_file_id` field entirely (send `null` to remove)
- [ ] Verify image preview still works (use `url` from upload response for local preview)
- [ ] Test: upload → create product → verify image appears
- [ ] Test: upload → update profile → verify image appears
- [ ] Test: upload → update about → verify image appears
- [ ] Test: create product without image → verify no crash
- [ ] Test: update product without changing image → verify original stays