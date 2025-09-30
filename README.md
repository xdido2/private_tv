# 📱 Private TV — Flutter Mobile App

Welcome to **Private TV** — a cross-platform Flutter application for browsing public and private videos.  
The app integrates with a Django REST Framework backend and uses **Bloc** for state management.

---

## 🚀 Features

- 🔑 User authentication & registration (JWT)
- 🎥 Browse **public** and **private** videos
- 💬 View and post comments
- 👤 User profile (avatar, username, email)
- 📱 iOS & Android support
- ⚡ State management via **flutter_bloc**

---

## 🛠️ Tech Stack

- [Flutter](https://flutter.dev/) — UI framework
- [Dart](https://dart.dev/) — programming language
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) — state management
- [http](https://pub.dev/packages/http) — HTTP client
- [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) — responsive design
- [shared_preferences](https://pub.dev/packages/shared_preferences) — local storage (tokens)
- [top_snackbar_flutter](https://pub.dev/packages/top_snackbar_flutter) — notifications

---

## 📂 Project Structure

```

lib/
├── api/              # Bloc, repositories, API integration
│    └── auth/        # Authentication & registration
│    └── videos/      # Video features
├── app/              # UI & app logic
│    └── components/  # UI components (Logo, List, Widgets)
│    └── pages/       # Screens (Home, Settings, Auth)
│    └── themes/      # Colors & styles
├── main.dart         # App entry point

````

---

## ⚙️ Installation & Run

### 1. Clone repository

```bash
git clone https://github.com/xdido2/private_tv.git
cd private_tv
````

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

### 4. Build release

* Android:

```bash
flutter build apk --release
```

* iOS:

```bash
flutter build ios --release
```

---

## 🔌 Backend Integration

By default, the app connects to the Django REST API (
see [Backend README](https://github.com/xdido2/private_tv_backend)).

API config is located in `lib/api/helper.dart`:

```dart
class AuthHttp {
  static const String baseUrl = "http://127.0.0.1:8000";
}
```

---

## 📡 Key API Endpoints

* `POST /users/login/` — user login
* `POST /users/register/` — user registration
* `GET /users/me/` — fetch current user
* `GET /videos/video_list/` — fetch videos
* `GET /videos/private/` — fetch private videos (only superusers, see backend doc)
* `GET /videos/<uuid:video_id>/comments/` — fetch comments for a video
* `POST /videos/<uuid:video_id>/comments/` — post a new comment

---

## 📜 License

This project is licensed under the **MIT License**.