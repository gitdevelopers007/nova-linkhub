# 🚀 Nova LinkHub

**One link. Infinite presence.**

Nova LinkHub is a powerful, self-hosted "Link in Bio" tool featuring a futuristic "Matrix" aesthetic. Built with a **Flutter** frontend and **Node.js (Express + MongoDB)** backend, it offers a premium, responsive experience for managing and sharing your digital identity.

![Nova LinkHub] nova-linkhub.netlify.app

## ✨ Features

-   **🎨 Premium "Matrix" UI**: Dark mode with neon green accents, glassmorphism, and smooth animations.
-   **🔗 Hub Management**: Create multiple "Hubs" (pages) for different purposes.
-   **🛠️ Advanced Editor**:
    -   Add/Edit/Delete links.
    -   Update Hub Title and Bio.
-   **⚡ Rule-Based Links**: Conditionally show links based on:
    -   **Time**: e.g., "Work Portfolio" (9 AM - 5 PM only).
    -   **Device**: e.g., "App Store Link" (Mobile only).
-   **📈 Click Analytics**: Track link clicks and hub views.
-   **🌍 Public Page**: A shareable, performant public profile for every user.

## 🛠️ Tech Stack

-   **Frontend**: Flutter (Web, iOS, Android)
-   **Backend**: Node.js, Express.js
-   **Database**: MongoDB
-   **Authentication**: JWT (JSON Web Tokens)

## 🚀 Getting Started

### Prerequisites
-   [Flutter SDK](https://flutter.dev/docs/get-started/install)
-   [Node.js](https://nodejs.org/)
-   [MongoDB](https://www.mongodb.com/) (Local or Atlas)

### 1. Backend Setup
Navigate to the `backend` folder and install dependencies:
```bash
cd backend
npm install
```

Create a `.env` file in the `backend` folder:
```env
MONGO_URI=mongodb://localhost:27017/nova_linkhub
JWT_SECRET=your_super_secret_key
PORT=5005
```

Start the server:
```bash
npm start
```
*(Runs on `http://localhost:5005`)*

### 2. Frontend Setup
Navigate to the root folder:
```bash
cd ..
flutter pub get
```

Run the app (Web recommended):
```bash
flutter run -d chrome
```

## 📦 Deployment

### Backend (Render/Heroku)
1.  Push the `backend` folder to a repo.
2.  Set Root Directory to `backend`.
3.  Set Environment Variables (`MONGO_URI`, `JWT_SECRET`).

### Frontend (Vercel/Netlify)
1.  Update `lib/services/api_service.dart` with your production URL.
2.  Build for web:
    ```bash
    flutter build web --release
    ```
3.  Deploy the `build/web` folder.

---

Made with 💚 by the Nova Team.
