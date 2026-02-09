# Tech Stack Evaluation

**Purpose:** Research and evaluation of cross-platform mobile development frameworks for NelliCalc.

**Status:** Complete — Flutter selected
**Decision Date:** 2026-02-09

## Requirements

### Functional Requirements
- Cross-platform support: macOS, iOS, iPadOS, Android, Windows (touch-enabled)
- Touch-optimised interface with drag-and-drop support
- On-device operation (no server required)
- Result history storage and retrieval
- Responsive layouts (landscape/portrait modes)

### Non-Functional Requirements
- Simple to develop and maintain
- Easy deployment to app stores
- Modern, clean UI capabilities
- Good performance on mobile devices
- Small learning curve (if possible)
- Active community and ecosystem

## Evaluation Criteria

1. **Cross-Platform Support**: Ability to target all required platforms from a single codebase
2. **Touch Support**: Quality of touch interactions, drag-and-drop capabilities
3. **Development Experience**: Ease of development, debugging, and tooling
4. **Performance**: Runtime performance, app size, startup time
5. **UI/UX Capabilities**: Modern UI framework, customisation options
6. **Ecosystem**: Package management, third-party libraries, community support
7. **Deployment**: Ease of building and deploying to app stores
8. **Learning Curve**: Time to productivity for developers

## Options Evaluated

### 1. Flutter (Dart) — SELECTED

**Overview:** Google's UI toolkit for building natively compiled applications.

**Pros:**
- Single codebase for all platforms
- Excellent touch support and gesture recognition
- Modern, declarative UI framework
- Good performance (compiled to native code)
- Hot reload for fast development
- Strong Material Design 3 and Cupertino widgets
- Active community and extensive package ecosystem (pub.dev)
- Good documentation
- Built-in `Draggable` and `DragTarget` widgets ideal for NelliCalc's core feature

**Cons:**
- Requires learning Dart (though similar to Java/Kotlin/TypeScript)
- Larger app size compared to native apps (~10-15MB baseline)
- Some platform-specific features may require platform channels

**Deployment:**
- iOS App Store: ✅ Supported
- Google Play: ✅ Supported
- Windows Store: ✅ Supported (Windows 10+)
- macOS App Store: ✅ Supported

**Touch & Drag-and-Drop:**
- Excellent gesture support via `GestureDetector` and `Draggable` widgets
- Built-in drag-and-drop APIs (`Draggable`, `DragTarget`, `LongPressDraggable`)
- Custom gesture recognisers available
- `InteractiveViewer` for advanced touch interactions

**Local Data Persistence Options:**
- `shared_preferences` — simple key-value storage
- `hive` — lightweight NoSQL database, good for structured data
- `sqflite` — SQLite wrapper for relational data
- `drift` — type-safe SQLite with code generation

**Verdict:** ⭐⭐⭐⭐⭐ Strong candidate, excellent for touch-first mobile apps

---

### 2. React Native (TypeScript/JavaScript)

**Overview:** Meta's framework for building native apps using React.

**Pros:**
- Large developer community (web developers can contribute)
- Extensive npm ecosystem
- Good touch support via React Native Gesture Handler
- Hot reload and fast refresh
- Mature ecosystem with many libraries
- Can share code with web applications

**Cons:**
- Sometimes requires platform-specific code
- Performance may not match native apps in all cases (JavaScript bridge)
- New Architecture (Fabric/TurboModules) still being adopted across ecosystem
- More complex build setup for some platforms

**Deployment:**
- iOS App Store: ✅ Supported
- Google Play: ✅ Supported
- Windows: ✅ Supported (React Native Windows, maintained by Microsoft)
- macOS: ✅ Supported (React Native macOS, maintained by Microsoft)

**Note:** Desktop support has improved significantly since Microsoft took over maintenance of the Windows and macOS targets.

**Touch & Drag-and-Drop:**
- Good touch support via `react-native-gesture-handler`
- Drag-and-drop available via libraries like `react-native-draggable-flatlist`
- May require additional setup for complex gestures

**Verdict:** ⭐⭐⭐⭐ Good candidate, especially if team has web/React experience

---

### 3. Tauri 2.x (Rust + Web Frontend)

**Overview:** Framework for building desktop and mobile apps with Rust backend and web frontend. Tauri 2.0 added mobile support (iOS and Android).

**Pros:**
- Very small bundle size (uses system webview)
- Rust backend for performance-critical operations
- Use any web framework (React, Vue, Svelte, etc.)
- Strong security model (no Node.js runtime)
- Good for desktop applications
- Tauri 2.0 added iOS and Android support

**Cons:**
- Mobile support is functional but less mature than Flutter/React Native
- More complex setup — requires both Rust and web toolchain
- Touch gesture support depends entirely on chosen web framework
- Smaller community for mobile-specific development
- Debugging mobile issues can be more complex

**Deployment:**
- iOS App Store: ✅ Supported (Tauri 2.0+)
- Google Play: ✅ Supported (Tauri 2.0+)
- Windows: ✅ Strong support
- macOS: ✅ Strong support

**Touch & Drag-and-Drop:**
- Depends on web framework used
- Web-based drag-and-drop may feel less native on mobile
- Touch interactions limited by webview capabilities

**Verdict:** ⭐⭐⭐ Mobile support improving with Tauri 2.0, but still desktop-first

---

### 4. Kotlin Multiplatform (KMP)

**Overview:** JetBrains' approach to sharing Kotlin code across platforms, with Compose Multiplatform for shared UI.

**Pros:**
- Share business logic across all platforms
- Compose Multiplatform provides shared declarative UI
- Native performance (compiles to native code)
- Strong typing and modern language features
- Good Android integration (Kotlin is the primary Android language)
- Growing ecosystem and JetBrains backing

**Cons:**
- Compose Multiplatform for iOS is still maturing (stable but newer)
- Windows and macOS desktop support via Compose is less proven for production
- Smaller ecosystem compared to Flutter
- Requires Kotlin expertise
- iOS-specific code may still be needed for some features

**Deployment:**
- iOS App Store: ✅ Supported (Compose Multiplatform)
- Google Play: ✅ Excellent support
- Windows: ⚠️ Supported but less mature
- macOS: ⚠️ Supported but less mature

**Touch & Drag-and-Drop:**
- Compose provides gesture APIs and drag-and-drop support
- Good on Android; iOS gesture support is improving
- Desktop gesture support varies

**Verdict:** ⭐⭐⭐⭐ Strong contender, especially for Android-focused projects. Desktop support still catching up.

---

### 5. .NET MAUI (C#)

**Overview:** Microsoft's cross-platform framework for building native apps.

**Pros:**
- Native performance
- Strong Windows and Microsoft ecosystem integration
- Single codebase for multiple platforms
- Good tooling with Visual Studio
- XAML-based UI (familiar to WPF/UWP developers)

**Cons:**
- Primarily Windows/Microsoft focus
- Learning curve for C# and XAML
- Smaller community compared to Flutter/React Native
- Less mature on some platforms (particularly macOS)
- Larger app size

**Deployment:**
- iOS App Store: ✅ Supported
- Google Play: ✅ Supported
- Windows Store: ✅ Excellent support
- macOS App Store: ✅ Supported

**Touch & Drag-and-Drop:**
- Good touch support
- Drag-and-drop available via platform APIs

**Verdict:** ⭐⭐⭐ Good if team has .NET experience, Windows-focused

---

### 6. Capacitor (Web + Native)

**Overview:** Cross-platform app runtime that allows web apps to run natively.

**Pros:**
- Use web technologies (HTML, CSS, JavaScript/TypeScript)
- Easy for web developers
- Can use any web framework
- Access to native device features via plugins
- Progressive Web App (PWA) capabilities

**Cons:**
- Performance may be less optimal than native (webview-based)
- Native feel varies by platform
- May require platform-specific optimisations
- Some limitations on complex native features
- Touch interactions limited by webview

**Deployment:**
- iOS App Store: ✅ Supported
- Google Play: ✅ Supported
- Windows: ⚠️ Limited support
- macOS: ⚠️ Limited support

**Touch & Drag-and-Drop:**
- Depends on web framework and libraries used
- HTML5 drag-and-drop available
- May need additional libraries for mobile-optimised gestures

**Verdict:** ⭐⭐⭐ Good for web-first approach, performance considerations

---

## Comparison Matrix

| Framework | Cross-Platform | Touch Support | Performance | Learning Curve | Ecosystem | Mobile Maturity |
|-----------|---------------|---------------|-------------|----------------|-----------|----------------|
| Flutter   | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| React Native | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Tauri 2.x | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| KMP/Compose | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| .NET MAUI | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Capacitor | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

## Decision: Flutter

**Selected Framework: Flutter (Dart)**

Flutter is selected for NelliCalc for the following reasons:

1. **Best-in-class touch and drag-and-drop support** — Built-in `Draggable`, `DragTarget`, and `LongPressDraggable` widgets are purpose-built for NelliCalc's core feature of dragging previous results into calculations
2. **Mobile-first architecture** — Designed specifically for mobile platforms with excellent performance on both iOS and Android
3. **True single codebase** — Consistent rendering across all platforms (no platform-dependent widget behaviour)
4. **Responsive layout support** — `LayoutBuilder`, `MediaQuery`, and adaptive widgets make responsive design straightforward
5. **Mature ecosystem** — Large community, extensive pub.dev package repository, and comprehensive documentation
6. **Proven at scale** — Used by Google, BMW, Alibaba, and many other production apps
7. **Strong local persistence options** — Multiple well-maintained packages for on-device data storage

**Why not React Native?**
- Flutter's built-in drag-and-drop widgets are more native and performant than React Native's library-based approach
- Flutter's rendering engine provides more consistent cross-platform behaviour
- No JavaScript bridge overhead

**Why not Kotlin Multiplatform?**
- Desktop support (Windows/macOS) is less mature
- Smaller ecosystem for the full cross-platform story
- Flutter's widget library is more comprehensive for UI-heavy apps

**Why not Tauri 2.0?**
- Webview-based touch interactions feel less native on mobile
- Mobile support is newer and less battle-tested
- Dual toolchain (Rust + web) adds complexity

## Next Steps

1. ~~Decision Point~~ — **DONE**: Flutter selected
2. **Sprint 001**: Scaffold Flutter project, validate drag-and-drop PoC, set up CI/CD
3. **Sprint 002**: Architecture document, data model, UX wireframes
4. **Sprint 003+**: Core implementation

## References

- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Drag and Drop](https://api.flutter.dev/flutter/widgets/Draggable-class.html)
- [React Native Documentation](https://reactnative.dev/docs/getting-started)
- [Tauri 2.0 Documentation](https://v2.tauri.app/)
- [Kotlin Multiplatform](https://kotlinlang.org/docs/multiplatform.html)
- [.NET MAUI Documentation](https://learn.microsoft.com/en-us/dotnet/maui/)
- [Capacitor Documentation](https://capacitorjs.com/docs)

---

_Last updated: 2026-02-09_
