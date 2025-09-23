# Movie Browsing App

A Flutter-based movie browsing application skeleton. This project provides the basic structure for contributors to practice building real-world features like API integration, dynamic UI, navigation, and state management.

Contributors will implement additional features using the provided setup.

---

## ✨ Features

- Home Screen with placeholder sections:
  - Top Indian Movies
  - Popular Shows
  - Globally Popular Movies
- `ApiService` set up with environment variable support for API keys
- Movie model & reusable card widget
- Navigation to movie detail screen (placeholder)
- Ready for contributors to implement:
  - Real API integration
  - Search functionality
  - Movie details page
  - Wishlist, themes, and other enhancements

---

## 🛠️ Tech Stack

- **Flutter** – Cross-platform mobile framework  
- **Dart** – Type-safe programming language  
- **http** – For API calls  
- **flutter_dotenv** – Manage API keys securely  

---

## 🚀 Getting Started

### Prerequisites

- Flutter installed ([Flutter docs](https://flutter.dev/docs/get-started/install))  
- Dart SDK (included with Flutter)  
- Android/iOS emulator or physical device  

### Installation

1. Clone the repository:

git clone https://github.com/ossdaiict/SLoP5.0-Movie-Browsing-App.git
cd SLoP5.0-Movie-Browsing-App


2. Install dependencies:

flutter pub get

3. Create a `.env` file in the root directory with your API keys (do NOT commit this file):
API Keys (local - DO NOT COMMIT)

RAPIDAPI_KEY=your_rapidapi_key_here
RAPIDAPI_HOST=omdb-api4.p.rapidapi.com
OMDB_API_KEY=your_omdb_api_key_here


**Note:**  
- `RAPIDAPI_KEY` can be obtained from [RapidAPI](https://rapidapi.com) for OMDb API free plan  
- `OMDB_API_KEY` is optional, from [OMDb API](https://www.omdbapi.com/apikey.aspx)  

4. Run the app:
flutter run


Launches a basic home screen; you can implement additional features in your branch.

---

## 📌 Contributing

- Fork the repository  
- Create a feature branch:  

git checkout -b feature/your-feature-name
- Implement your features, commit, and push:  

git add .
git commit -m "Add feature: ..."
git push origin feature/your-feature-name

- Open a Pull Request against `main`  
- Focus on one feature at a time and follow the GitHub issues workflow.

---

## 📄 License

MIT License – open source

---

Built with ❤️ using Flutter & Dart
