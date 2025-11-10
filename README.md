# Paymeter JsonPlaceholder

Clean-architecture Flutter app that integrates with the JsonPlaceholder API, showcasing modular data/domain/application/presentation layers with Riverpod, Dio, and GoRouter.

## Environment Requirements

- **Flutter**: 3.24.0 or newer  
- **Dart SDK**: 3.9.2 or newer (see `environment.sdk` in `pubspec.yaml`)
- **Melos/Flutter tools**: optional but recommended for multi-package workflows

## Installation

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd paymeter-jsonplaceholder
   ```
2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```
3. **Generate Freezed/Riverpod code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Run the app**
   ```bash
   flutter run
   ```

## Dependencies Overview

| Category            | Package(s)                                | Purpose                                      |
|---------------------|-------------------------------------------|----------------------------------------------|
| HTTP client         | [`dio`](https://pub.dev/packages/dio)     | REST calls with interceptors/retries         |
| State management    | [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod), [`riverpod_annotation`](https://pub.dev/packages/riverpod_annotation) | Reactive controllers, dependency injection   |
| Code generation     | [`freezed`](https://pub.dev/packages/freezed), [`build_runner`](https://pub.dev/packages/build_runner) | Immutable states/models, sealed unions       |
| Navigation          | [`go_router`](https://pub.dev/packages/go_router) | Declarative routing with deep-link support   |
| UI/UX helpers       | `toastification`, `intl`, `cupertino_icons` | Notifications, localization, iconography     |

For the full list (including dev dependencies), check `pubspec.yaml`.

## Project Highlights

- Modular clean architecture (data → domain → application → presentation).
- Shared HTTP/Dio service with retry/interceptor strategy.
- Riverpod controllers with `AsyncValue` states and Freezed models.
- GoRouter setup including list/detail/edit routes for posts.

> Need more context? See `ARCHITECTURE.md` and the step-by-step roadmap under `/roadmap`.
