# Quizzical — Trivia Mobile Application

A clean, responsive, and accessible Flutter mobile trivia application built for the **Mobile App Development Lab Final Examination (CSE-3212)** at the **University of Barishal, Department of Computer Science & Engineering**.

---

## 📱 Features

- **Welcome & Personalization**:
  - Welcoming hero vector illustration.
  - Student name personalization (stored and retrieved via `SharedPreferences`).
  - "GET STARTED" primary call to action.

- **Category Selection**:
  - Live data from Open Trivia Database (`https://opentdb.com/api_category.php`).
  - 2-column responsive `GridView` with soft pastel colored cards and category-specific icons.
  - **Session Caching**: Categories are fetched once per app session to minimize redundant network requests.
  - Skeleton loading states and error retry banners.

- **Quiz Configuration**:
  - Number of questions slider: 1–50 (default: 10).
  - Difficulty level dropdown: `Any Difficulty`, `Easy`, `Medium`, `Hard` (omits query parameter for `Any Difficulty` as required by OpenTDB).
  - Question type dropdown: `Multiple Choice` (`multiple`), `True / False` (`boolean`).
  - Configuration persistence via `SharedPreferences` to restore user preferences across sessions.

- **Interactive Quiz Experience**:
  - Decoded HTML entities in questions and answers using `html_unescape`.
  - 4 shuffled options for multiple choice; exactly 2 for boolean.
  - Active 30-second countdown timer per question.
  - Immediate visual feedback on answer selection:
    - Selected correct answer highlighted in pastel green with checkmark.
    - Selected incorrect answer highlighted in pastel red with cross icon, revealing the correct answer in green.
  - Safe timer cancellation on exit, question transition, or quiz completion.
  - "Exit Quiz" confirmation dialog.
  - Live question counter (`7/10`) and animated linear progress bar.

- **Results & Replay**:
  - Dynamic score state:
    - **$\ge 70\%$ (Congratulations)**: Celebratory party popper illustration and encouraging copy.
    - **$< 70\%$ (Keep Trying!)**: Practice and retry illustration with improvement tips.
  - Accuracy percentage badge, total score (`X/Y`), and total quiz time elapsed.
  - "PLAY AGAIN" resets quiz session while preserving the last configuration in `SharedPreferences`.

---

## 🛠️ Tech Stack & Packages

- **Framework**: Flutter 3.47+ (Dart 3.13+)
- **State Management**: `provider: ^6.1.5+1`
- **Networking**: `http: ^1.6.0`
- **Persistence**: `shared_preferences: ^2.5.5`
- **HTML Decoding**: `html_unescape: ^2.0.0`

---

## 🏗️ Project Architecture

```
lib/
├── main.dart                          # App entry point, MultiProvider setup, & AppTheme
├── models/
│   ├── category_model.dart            # Category model with fromJson & HTML decoding
│   └── question_model.dart            # Question model with fromJson & stable shuffled options
├── services/
│   ├── api_service.dart               # OpenTDB REST client with error/timeout handling
│   └── storage_service.dart           # SharedPreferences wrapper for persistence
├── providers/
│   ├── category_provider.dart         # Category state & session caching
│   └── quiz_provider.dart             # Quiz lifecycle, scoring, timer, & config state
├── screens/
│   ├── welcome_screen.dart            # Screen 1: Welcome & name customization
│   ├── category_screen.dart           # Screen 2: Category grid & skeleton loading
│   ├── quiz_config_screen.dart        # Screen 3: Slider, difficulty & type configuration
│   ├── quiz_screen.dart               # Screen 4: Question card, timer, options & next
│   └── result_screen.dart             # Screen 5: Dual results states & play again
├── widgets/
│   ├── category_card.dart             # Pastel category item with icon badge
│   ├── answer_button.dart             # Answer button with neutral/correct/incorrect states
│   ├── progress_header.dart           # Progress counter, countdown timer & exit action
│   ├── illustrations.dart             # Vector illustrations (Welcome, Config, Popper, Retry)
│   ├── loading_widget.dart            # Skeletons and indicators
│   └── error_retry_widget.dart        # Error view with retry action
└── utils/
    ├── app_colors.dart                # Deep teal (#006F6A), pastels, correct/incorrect colors
    ├── app_theme.dart                 # Material 3 theme definition
    └── category_helper.dart           # Category icon, color, and name formatting helpers
```

---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/Utsojet/Quiz-app.git
cd Quiz-app
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run static analysis & tests
```bash
flutter analyze
flutter test
```

### 4. Run the application
- On Android emulator / device:
  ```bash
  flutter run
  ```
- On Chrome (Web):
  ```bash
  flutter run -d chrome
  ```
- On macOS:
  ```bash
  flutter run -d macos
  ```
