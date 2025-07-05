# Intraone Mobile App 📱

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter\&logoColor=white) ![Express.js](https://img.shields.io/badge/Express.js-4.x-brightgreen?logo=express\&logoColor=white) ![Firebase](https://img.shields.io/badge/Firebase-RealtimeDB-orange?logo=firebase\&logoColor=white)

Welcome to the **Intraone Mobile App**, the Flutter-powered mobile companion for the Intraone ISP platform! This app enables users to manage internet subscriptions, make payments, and check their account status directly from their mobile devices, providing the same experience as the web platform but optimized for mobile use.

✨ **It integrates seamlessly with the [Intraone Website](https://github.com/YourUsername/Intraone-main), sharing the same backend API and real-time database.** ✨

---

## 🚀 Features

✅ Secure user authentication and session management
✅ Browse and subscribe to internet packages
✅ Read ISP announcements
✅ Manage personal profiles and account data
✅ Handle payments via multiple payment methods
✅ View transaction histories and details
✅ Easter eggs for added user delight 🎉

---

## 🛠 Tech Stack

* **Frontend:** Flutter 3.x — A modern cross-platform UI toolkit that allows building native apps for Android and iOS from a single codebase. It uses the Dart language and provides a fast, expressive UI with beautiful animations.
* **Backend:** Express.js API — A minimal and flexible Node.js web application framework used to build RESTful APIs. It powers all backend services shared with the website, including authentication, fetching announcements, and managing transactions.
* **Database:** Firebase Realtime Database — A cloud-hosted NoSQL database that stores and synchronizes data in real-time across clients. This ensures the app instantly reflects updates made from the web or other clients, providing a seamless experience.

---

## 📂 Project Structure

```
lib/
├── main.dart                # Entry point of the app
├── controllers/             # Controllers for business logic
├── models/                  # Data models mapping API responses
├── services/                # API services and networking logic
├── utils/                   # Helpers, constants, and session management
├── views/                   # All UI screens and widgets
```

---

## 🔗 API Integration

All backend interactions are handled in:

```
lib/services/api_service.dart
```

Base API URL is configured in:

```dart
const String baseUrl = "https://your-gae-url.appspot.com/api/";
```

Main API endpoints:

* `/api/pelanggan` – User profiles and authentication
* `/api/announcements` – ISP announcements
* `/api/transaksi` – User transactions and payments

This ensures that mobile and web platforms remain fully synchronized.

---

## 📲 Getting Started

Clone the repository:

```bash
git clone https://github.com/YourUsername/Intraone-Flutter-main.git
cd Intraone-Flutter-main
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Make sure the backend API is deployed and accessible for full functionality.

---

## Project Example

### 1. Login Page, Dashboard Inactive, Dashboard Active
[!Login Page](./assets/flutter_login.png)                       [!dashboard page inactive](./assets/flutter_dashboard_pending.png)              [!Dashboard Page Active](./assets/flutter_dashboard_active.png)
