# Quick Start — NelliCalc

This guide will help you get started with NelliCalc development.

## Prerequisites

- **Flutter SDK** (3.38.x stable or later) — [Installation guide](https://docs.flutter.dev/get-started/install)
- **Dart SDK** — included with Flutter
- **Platform toolchains** (install as needed for your target):
  - **Linux desktop**: clang, cmake, ninja, pkg-config, GTK 3 dev headers
  - **Android**: Android Studio + Android SDK
  - **iOS/macOS**: Xcode (macOS only)
  - **Windows**: Visual Studio with C++ desktop workload

Run `flutter doctor` to verify your setup.

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/BelongaGezza/NelliCalc.git
   cd NelliCalc
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run            # runs on the default connected device
   flutter run -d linux   # runs on Linux desktop
   flutter run -d chrome  # runs in Chrome (web)
   ```

4. **Run tests:**
   ```bash
   flutter test
   ```

5. **Check code quality:**
   ```bash
   dart format --set-exit-if-changed .
   dart analyze
   ```

## Project Structure

```
NelliCalc/
├── .agents/           # AI agent persona files
├── android/           # Android platform project
├── ios/               # iOS platform project
├── lib/               # Dart source code (main application)
├── linux/             # Linux desktop platform project
├── macos/             # macOS platform project
├── windows/           # Windows platform project
├── test/              # Dart/Flutter tests
├── RESEARCH/          # Architecture decisions, tech stack research
├── SPRINTS/           # Sprint tasking files
│   └── archive/       # Completed sprints
├── docs/              # User documentation
├── pubspec.yaml       # Dart/Flutter dependencies
└── analysis_options.yaml  # Linting and analysis rules
```

## Development Workflow

1. Check [PROJECT_STATUS.md](PROJECT_STATUS.md) for the current sprint
2. Review the active sprint file in [SPRINTS/](SPRINTS/)
3. Follow [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
4. Before submitting a PR, ensure:
   - `dart format .` produces no changes
   - `dart analyze` reports no issues
   - `flutter test` passes

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Project Status](PROJECT_STATUS.md)
- [Research Documentation](RESEARCH/)

---

_Last updated: 2026-02-09_
