# 🚀 FutureMe - Your Path to Financial Freedom

**FutureMe** is a modern, user-friendly Flutter mobile app designed to empower freelancers in achieving financial independence. With AI-driven features, sleek Material 3 design, and smooth animations, FutureMe helps you track finances, set goals, chat with an AI assistant, and boost your mood—all in one place! 🌟

---

## 🎯 Features

- **AI-Powered Chatbot**: Get personalized advice with a conversational AI, seamlessly integrated with a modern chat UI.
- **Financial Tracker**: Log income and expenses with photo proof, styled with intuitive inputs and animated transitions.
- **Goal Setter**: Define and track financial goals with dynamic progress bars and a clean, motivating interface.
- **Mood Booster**: Record your daily mood with a sleek dropdown and receive AI-driven suggestions to stay positive.
- **Profile Customization**: Personalize your journey with a streamlined profile setup, designed for ease and clarity.
- **Modern UI/UX**: Built with Material 3, featuring rounded corners, subtle shadows, and fluid animations for a premium experience.

---

## 🖼️ UI/UX Design Highlights

FutureMe’s design is crafted to be both functional and visually stunning, ensuring a delightful user experience:

- **Minimalist Aesthetic**: Clean layouts with a soft gray background (#F5F5F5) and vibrant accents (blue #1976D2, green #388E3C, yellow #FFA000).
- **Smooth Animations**: Fade transitions, scale effects on buttons, and staggered list animations for a polished feel.
- **Custom Widgets**: Reusable `CustomButton` and `CustomTextField` with gradient backgrounds, rounded edges, and focus animations.
- **Material 3 Compliance**: Consistent typography (Roboto), card-style containers, and shadow effects for depth.
- **Responsive Navigation**: A 4-tab bottom navigation bar (Home, Financial, Goal, Profile) with built-in Flutter icons for simplicity.

---

## 📂 Project Structure

```plaintext
lib/
├── core/
│   ├── constants/
│   │   ├── app_assets.dart        # Built-in Flutter icons for UI
│   │   ├── app_colors.dart        # Material 3 color palette
│   │   ├── app_strings.dart       # Localized strings
│   │   ├── app_text_styles.dart   # Modern typography
│   ├── utils/
│   │   ├── helpers.dart           # Utility functions
│   │   ├── logger.dart            # Logging utilities
│   │   ├── validators.dart        # Input validation
├── data/
│   ├── models/                    # Data models (e.g., FinancialEntry, Goal)
│   ├── services/                  # API, database, and storage services
├── providers/                      # State management (e.g., UserProvider, ChatProvider)
├── ui/
│   ├── screens/                   # Main screens (Home, Financial, Goal, Profile)
│   ├── widgets/                   # Custom UI components (CustomButton, CustomTextField)
├── main.dart                      # App entry point
```

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (v3.0.0 or later)
- Dart (v2.17 or later)
- IDE (VS Code, Android Studio, or IntelliJ)
- Emulator or physical device for testing

### Installation
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/futureme.git
   cd futureme
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   ```bash
   flutter run
   ```

4. **Optional**: Add Google Fonts (`Roboto` or `Poppins`) to `pubspec.yaml` for enhanced typography:
   ```yaml
   dependencies:
     google_fonts: ^6.2.1
   ```

---

## 🎨 UI/UX Design Philosophy

FutureMe’s design is built to inspire and simplify:
- **Intuitive Navigation**: A streamlined 4-tab bottom navigation bar with animated icon transitions.
- **Interactive Widgets**: `CustomButton` with scale animations and `CustomTextField` with dynamic border focus.
- **Consistent Styling**: Rounded corners (12px radius), subtle shadows, and a cohesive color scheme for a premium look.
- **User-Centric**: Clear feedback (e.g., success SnackBars), localized Indonesian strings, and AI-driven insights tailored for freelancers.

---

## 📸 Screenshots

*Coming soon! Stay tuned for visual previews of the app’s sleek interface.*

---

## 🤝 Contributing

We welcome contributions to make FutureMe even better! Here’s how to get involved:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add YourFeature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a Pull Request.

Please follow our [code style guidelines](CONTRIBUTING.md) and ensure all tests pass.

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🌟 Acknowledgments

- Built with [Flutter](https://flutter.dev/) for cross-platform excellence.
- Inspired by Material Design 3 for a modern, accessible UI.
- Thanks to the open-source community for tools like `provider` and `google_fonts`.

**Let’s build your financial future together with FutureMe!** 💸