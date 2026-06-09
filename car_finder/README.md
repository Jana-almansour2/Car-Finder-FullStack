# Car Finder: Full-Stack Mobile Solution 🚗📍

**Car Finder** is a comprehensive full-stack application designed to help users save, manage, and retrieve their parked vehicle locations with high precision and security. The project features a robust **Flutter** mobile application and a custom **Node.js/Express** backend for cloud data persistence.

---

## 🌟 Key Features

### 📱 Mobile Frontend (Flutter)
- **Precise GPS Tracking:** Capture exact coordinates using advanced location services.
- **Real-time Weather Integration:** Fetches current weather conditions via **OpenWeatherMap API**.
- **Golden Note System:** Add custom descriptions and notes to each saved location.
- **Smart Date Logic:** Intelligent UI that displays "Today", "Yesterday", or the actual date.
- **Multi-language Support:** Fully localized in **Arabic** and **English**.
- **Responsive UI:** Optimized for various screen sizes and orientations.

### ⚙️ Backend (Node.js & Express)
- **Cloud Backup:** Automatically backs up every saved location to a centralized server.
- **Data Persistence:** Stores data in a structured `locations.json` file for reliability.
- **RESTful API:** Clean endpoints for saving and retrieving location history.
- **Data Validation:** Server-side checks to ensure data integrity and security.

---

## 🛡️ Security & Architecture

This project prioritizes data privacy and follows modern software engineering principles:

- **AES-256 Encryption:** All sensitive location data is encrypted locally using the AES-256 algorithm.
- **Secure Key Management:** Encryption keys are stored using **Flutter Secure Storage** (Keychain/Keystore).
- **Environment Variables (.env):** API keys and secrets are protected and never hardcoded.
- **Clean Architecture:** Follows a **Feature-first** structure with **Riverpod** for scalable state management.
- **Centralized API Client:** Uses **Dio** with a custom wrapper for consistent network communication and error handling.

---

## 🛠️ Tech Stack

- **Frontend:** Flutter, Dart, Riverpod, Hive (NoSQL), Dio, Geolocator.
- **Backend:** Node.js, Express.js, File System (fs).
- **APIs:** OpenWeatherMap API.
- **Tools:** Git, GitHub, VS Code.

---

## 📂 Project Structure
```text
.
├── car_finder/          # Flutter Mobile Application
└── car_finder_backend/  # Node.js Express Backend
```


