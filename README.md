# GetX Starter — Flutter Clean Architecture

A production-ready Flutter starter project using **GetX** for state management and navigation, **Firebase Authentication** for auth, and **Clean Architecture** for a scalable, testable codebase.

---

## Table of Contents

1. [Tech Stack](#tech-stack)
2. [Project Folder Structure](#project-folder-structure)
3. [Layer Responsibilities](#layer-responsibilities)
4. [Auth Flow — Step by Step](#auth-flow--step-by-step)
5. [Environment Setup (Credentials)](#environment-setup-credentials)
6. [How to Run](#how-to-run)
7. [Adding a New Screen — Step-by-Step Guide](#adding-a-new-screen--step-by-step-guide)

---

## Tech Stack

| Package | Purpose |
|---|---|
| `get` | State management, navigation, dependency injection |
| `firebase_core` | Firebase initialization |
| `firebase_auth` | Email/password authentication |
| `dartz` | Functional programming — `Either<Failure, T>` for error handling |
| `equatable` | Value equality for entities and failures |
| `dio` | HTTP client (ready for REST API calls) |

---

## Project Folder Structure

```
lib/
│
├── main.dart                          # App entry point
│
├── core/                              # Shared app-wide utilities
│   ├── constants/                     # App-wide constants (colors, strings, etc.)
│   ├── errors/
│   │   └── failures.dart              # Typed failure classes (AuthFailure, etc.)
│   ├── network/                       # Network configuration (Dio, interceptors)
│   ├── theme/                         # App theme, colors, text styles
│   └── utils/                         # Helper functions and extensions
│
├── domain/                            # ★ Pure Dart — NO Flutter, NO Firebase
│   ├── entities/
│   │   └── user_entity.dart           # Core User object (uid, email, displayName)
│   ├── repositories/
│   │   └── auth_repository.dart       # Abstract contract the data layer must fulfil
│   └── usecases/
│       ├── login_usecase.dart         # Calls repository.login()
│       └── register_usecase.dart      # Calls repository.register()
│
├── data/                              # Implements domain contracts with real services
│   ├── models/
│   │   └── user_model.dart            # Extends UserEntity; maps Firebase User → entity
│   ├── datasources/
│   │   ├── local/                     # Local storage (SharedPrefs, Hive, etc.)
│   │   └── remote/
│   │       └── auth_remote_datasource.dart  # Direct FirebaseAuth calls
│   └── repositories/
│       └── auth_repository_impl.dart  # Implements AuthRepository; handles errors
│
├── di/
│   └── injection_container.dart       # Registers all dependencies with GetX
│
├── routes/
│   ├── app_routes.dart                # Named route constants ('/login', '/home', …)
│   └── app_pages.dart                 # Maps route names → pages + bindings
│
└── presentation/                      # Everything the user sees
    ├── bindings/
    │   ├── login_binding.dart         # Injects LoginController when /login opens
    │   └── register_binding.dart      # Injects RegisterController when /register opens
    ├── controllers/
    │   ├── login_controller.dart      # Form state, validation, login logic
    │   └── register_controller.dart   # Form state, validation, register logic
    ├── pages/
    │   ├── login/
    │   │   └── login_page.dart        # Email + password sign-in screen
    │   ├── register/
    │   │   └── register_page.dart     # Name + email + password + confirm sign-up
    │   └── home/
    │       └── home_page.dart         # Post-login success screen
    └── widgets/
        ├── app_input_field.dart       # Reusable styled text field
        └── primary_button.dart        # Gradient button with loading state
```

---

## Layer Responsibilities

```
┌─────────────────────────────────────────────┐
│            PRESENTATION LAYER               │  ← Pages, Controllers, Bindings, Widgets
│  What the user sees and interacts with.     │
│  Controllers hold observable state (Rx).    │
└────────────────────┬────────────────────────┘
                     │ calls
┌────────────────────▼────────────────────────┐
│              DOMAIN LAYER                   │  ← Entities, Repositories (abstract), UseCases
│  Pure Dart. Business rules live here.       │
│  No Flutter, no Firebase imports.           │
└────────────────────┬────────────────────────┘
                     │ implements
┌────────────────────▼────────────────────────┐
│               DATA LAYER                    │  ← Models, DataSources, Repository Impls
│  Connects to Firebase / REST APIs.          │
│  Maps raw data → domain entities.           │
└─────────────────────────────────────────────┘
```

**Rules that keep the architecture clean:**
- `domain/` never imports from `data/` or `presentation/`
- `presentation/` never imports from `data/` directly — only talks to domain use cases
- Every error is wrapped in `Either<Failure, T>` — no raw exceptions reach the UI

---

## Auth Flow — Step by Step

### Login Flow

```
User taps "Sign In"
        │
        ▼
LoginPage (presentation/pages/login/login_page.dart)
  └── calls controller.login()
        │
        ▼
LoginController (presentation/controllers/login_controller.dart)
  1. Validates the form (email format, password length)
  2. Sets isLoading = true (button shows spinner)
  3. Calls LoginUseCase(email, password)
        │
        ▼
LoginUseCase (domain/usecases/login_usecase.dart)
  └── calls AuthRepository.login(email, password)
        │
        ▼
AuthRepositoryImpl (data/repositories/auth_repository_impl.dart)
  └── calls AuthRemoteDataSource.login(email, password)
        │
        ▼
AuthRemoteDataSource (data/datasources/remote/auth_remote_datasource.dart)
  └── calls FirebaseAuth.signInWithEmailAndPassword()
        │
        ▼
  Firebase returns UserCredential
        │
        ▼
AuthRepositoryImpl maps it:
  ✅ Success → right(UserModel.fromFirebaseUser(user))  → UserEntity
  ❌ Failure → left(AuthFailure("friendly message"))
        │
        ▼
LoginController receives Either<Failure, UserEntity>
  ❌ left(failure) → sets errorMessage.value (shown inline on form)
  ✅ right(user)   → shows green snackbar → Get.offAllNamed('/home')
        │
        ▼
HomePage is shown
```

### Register Flow

Identical pattern to Login, substituting:
- `RegisterPage` → `RegisterController` → `RegisterUseCase` → `AuthRepository.register()`
- FirebaseAuth method: `createUserWithEmailAndPassword()`

---

## Dependency Injection — How It's Wired

`InjectionContainer.init()` is called once in `main()` before `runApp()`.  
It registers everything as **lazy singletons** (created only on first use, kept alive on navigation):

```
AuthRemoteDataSource   ← no dependencies
        ▲
AuthRepositoryImpl     ← depends on AuthRemoteDataSource
        ▲
LoginUseCase           ← depends on AuthRepository
RegisterUseCase        ← depends on AuthRepository
        ▲
LoginController        ← injected by LoginBinding when /login opens
RegisterController     ← injected by RegisterBinding when /register opens
```

A **Binding** is a GetX concept that creates the controller exactly when its page opens and destroys it when the page closes — preventing memory leaks.

---

## Environment Setup (Credentials)

Firebase credentials are **never hardcoded**. They live in `.env` (git-ignored).

```bash
# 1. Copy the template
cp .env.example .env

# 2. Fill in your values from Firebase Console
#    https://console.firebase.google.com
```

The app reads credentials via `--dart-define` flags at build/run time (see `.env.example` for all keys).

---

## How to Run

```bash
# Install dependencies
flutter pub get

# Run with Firebase credentials injected
flutter run \
  --dart-define=FIREBASE_PROJECT_ID=your-project-id \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id \
  --dart-define=FIREBASE_STORAGE_BUCKET=your-bucket \
  --dart-define=FIREBASE_WEB_API_KEY=your-web-key \
  --dart-define=FIREBASE_WEB_APP_ID=your-web-app-id \
  --dart-define=FIREBASE_WEB_AUTH_DOMAIN=your-auth-domain \
  --dart-define=FIREBASE_ANDROID_API_KEY=your-android-key \
  --dart-define=FIREBASE_ANDROID_APP_ID=your-android-app-id \
  --dart-define=FIREBASE_IOS_API_KEY=your-ios-key \
  --dart-define=FIREBASE_IOS_APP_ID=your-ios-app-id \
  --dart-define=FIREBASE_IOS_CLIENT_ID=your-ios-client-id \
  --dart-define=FIREBASE_IOS_ANDROID_CLIENT_ID=your-ios-android-client-id \
  --dart-define=FIREBASE_IOS_BUNDLE_ID=your-bundle-id \
  --dart-define=FIREBASE_IOS_REVERSED_CLIENT_ID=your-reversed-client-id
```

---

## Adding a New Screen — Step-by-Step Guide

This guide uses a **Profile Screen** as a real example. Every screen follows the exact same 6-step checklist, regardless of complexity.

---

### The 6-Step Checklist

```
Step 1: Create the UseCase    (domain/usecases/)
Step 2: Register it in DI     (di/injection_container.dart)
Step 3: Create the Controller (presentation/controllers/)
Step 4: Create the Binding    (presentation/bindings/)
Step 5: Create the Page       (presentation/pages/)
Step 6: Register the Route    (routes/app_routes.dart + app_pages.dart)
```

---

### Example: Adding a Profile Screen

#### Step 1 — Create the UseCase

> Only needed if the screen calls business logic. For display-only screens you can skip this and call the repository directly from the controller.

**`lib/domain/usecases/get_profile_usecase.dart`**
```dart
import 'package:getx_starter/domain/entities/user_entity.dart';
import 'package:getx_starter/domain/repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository repository;
  const GetProfileUseCase(this.repository);

  UserEntity? call() => repository.getCurrentUser();
}
```

---

#### Step 2 — Register in DI

Open `lib/di/injection_container.dart` and add your use case inside `init()`:

```dart
// Add the import at the top
import 'package:getx_starter/domain/usecases/get_profile_usecase.dart';

// Add inside init()
Get.lazyPut<GetProfileUseCase>(
  () => GetProfileUseCase(Get.find<AuthRepository>()),
  fenix: true,
);
```

---

#### Step 3 — Create the Controller

**`lib/presentation/controllers/profile_controller.dart`**
```dart
import 'package:get/get.dart';
import 'package:getx_starter/domain/entities/user_entity.dart';
import 'package:getx_starter/domain/usecases/get_profile_usecase.dart';

class ProfileController extends GetxController {
  final GetProfileUseCase getProfileUseCase;
  ProfileController(this.getProfileUseCase);

  // Observable state — Obx() in the page reacts to changes here
  final Rx<UserEntity?> user = Rx(null);

  @override
  void onInit() {
    super.onInit();
    user.value = getProfileUseCase(); // load on page open
  }
}
```

---

#### Step 4 — Create the Binding

**`lib/presentation/bindings/profile_binding.dart`**
```dart
import 'package:get/get.dart';
import 'package:getx_starter/domain/usecases/get_profile_usecase.dart';
import 'package:getx_starter/presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<GetProfileUseCase>()),
    );
  }
}
```

---

#### Step 5 — Create the Page

**`lib/presentation/pages/profile/profile_page.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_starter/presentation/controllers/profile_controller.dart';

// GetView<T> gives you `controller` for free — no Get.find() needed
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) return const Center(child: Text('Not logged in'));
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('UID: ${user.uid}'),
              Text('Email: ${user.email ?? '-'}'),
            ],
          ),
        );
      }),
    );
  }
}
```

---

#### Step 6 — Register the Route

**`lib/routes/app_routes.dart`** — add the constant:
```dart
abstract class AppRoutes {
  static const login    = '/login';
  static const register = '/register';
  static const home     = '/home';
  static const profile  = '/profile';  // ← add this
}
```

**`lib/routes/app_pages.dart`** — add the GetPage entry:
```dart
// Add imports at the top
import 'package:getx_starter/presentation/bindings/profile_binding.dart';
import 'package:getx_starter/presentation/pages/profile/profile_page.dart';

// Add inside the routes list
GetPage(
  name: AppRoutes.profile,
  page: () => const ProfilePage(),
  binding: ProfileBinding(),
),
```

---

#### Navigating to Your New Screen

```dart
// Go to profile (keeps previous route in stack)
Get.toNamed(AppRoutes.profile);

// Go to profile and remove current page from stack
Get.offNamed(AppRoutes.profile);

// Go to profile and clear the entire navigation stack
Get.offAllNamed(AppRoutes.profile);
```

---

### Quick Reference — Files to create/edit per screen

| What | File | Action |
|---|---|---|
| Use case | `domain/usecases/your_usecase.dart` | **Create** |
| DI registration | `di/injection_container.dart` | **Edit** — add `Get.lazyPut` |
| Controller | `presentation/controllers/your_controller.dart` | **Create** |
| Binding | `presentation/bindings/your_binding.dart` | **Create** |
| Page | `presentation/pages/your_feature/your_page.dart` | **Create** |
| Route name | `routes/app_routes.dart` | **Edit** — add constant |
| Route entry | `routes/app_pages.dart` | **Edit** — add `GetPage` |

> 💡 **Tip:** For simple screens that don't call any API or business logic (e.g. a static "About" page), you can skip Steps 1 & 2 entirely and create just the page + binding + route entry (Steps 4–6), with the controller holding only UI state.
