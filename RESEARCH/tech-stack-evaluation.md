# Tech Stack Evaluation

**Purpose:** Research and evaluation of cross-platform mobile development frameworks for NelliCalc.

**Status:** In Progress  
**Date:** 2026-02-09

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

### 1. Flutter (Dart)

**Overview:** Google's UI toolkit for building natively compiled applications.

**Pros:**
- Single codebase for all platforms
- Excellent touch support and gesture recognition
- Modern, declarative UI framework
- Good performance (compiled to native code)
- Hot reload for fast development
- Strong Material Design and Cupertino widgets
- Active community and extensive package ecosystem
- Good documentation

**Cons:**
- Requires learning Dart (though similar to other languages)
- Larger app size compared to native apps
- Some platform-specific features may require platform channels
- Less mature than React Native in some areas

**Deployment:**
- iOS App Store: ✅ Supported
- Google Play: ✅ Supported
- Windows Store: ✅ Supported (Windows 10+)
- macOS App Store: ✅ Supported

**Touch & Drag-and-Drop:**
- Excellent gesture support via `GestureDetector` and `Draggable` widgets
- Built-in drag-and-drop APIs
- Custom gesture recognisers available

**Verdict:** ⭐⭐⭐⭐⭐ Strong candidate, excellent for touch-first mobile apps

---

### 2. React Native (TypeScript/JavaScript)

**Overview:** Facebook's framework for building native apps using React.

**Pros:**
- Large developer community (web developers can contribute)
- Extensive npm ecosystem
- Good touch support via React Native Gesture Handler
- Hot reload and fast refresh
- Mature ecosystem with many libraries
- Can share code with web applications

**Cons:**
- Sometimes requires platform-specific code
- Performance may not match native apps in all cases
- Bridge overhead for some operations
- Larger app size
- More complex build setup for some platforms

**Deployment:**
- iOS App Store: ✅ Supported
- Google Play: ✅ Supported
- Windows: ⚠️ Limited support (React Native Windows)
- macOS: ⚠️ Limited support

**Touch & Drag-and-Drop:**
- Good touch support via `react-native-gesture-handler`
- Drag-and-drop available via libraries like `react-native-draggable`
- May require additional setup for complex gestures

**Verdict:** ⭐⭐⭐⭐ Good candidate, especially if team has web/React experience

---

### 3. Tauri (Rust + Web Frontend)

**Overview:** Framework for building desktop and mobile apps with Rust backend and web frontend.

**Pros:**
- Very small bundle size
- Rust backend for performance-critical operations
- Use any web framework (React, Vue, Svelte, etc.)
- Strong security model
- Good for desktop applications

**Cons:**
- Mobile support still evolving (iOS/Android support is newer)
- More complex setup than Flutter/React Native
- Requires knowledge of both Rust and web technologies
- Less mature mobile tooling
- Smaller community for mobile development

**Deployment:**
- iOS App Store: ⚠️ Supported but less mature
- Google Play: ⚠️ Supported but less mature
- Windows: ✅ Strong support
- macOS: ✅ Strong support

**Touch & Drag-and-Drop:**
- Depends on web framework used
- May require additional libraries for mobile touch interactions

**Verdict:** ⭐⭐⭐ Better for desktop-first applications, mobile support improving

---

### 4. .NET MAUI (C#)

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
- Less mature on some platforms
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

### 5. Capacitor (Web + Native)

**Overview:** Cross-platform app runtime that allows web apps to run natively.

**Pros:**
- Use web technologies (HTML, CSS, JavaScript/TypeScript)
- Easy for web developers
- Can use any web framework
- Access to native device features via plugins
- Progressive Web App (PWA) capabilities

**Cons:**
- Performance may be less optimal than native
- Native feel varies by platform
- May require platform-specific optimisations
- Larger app size
- Some limitations on complex native features

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
| Tauri     | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| .NET MAUI | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Capacitor | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

## Recommendation

**Primary Recommendation: Flutter**

Flutter is the strongest candidate for NelliCalc because:

1. **Excellent Touch Support**: Built-in gesture recognition and drag-and-drop widgets are perfect for the calculator's core feature
2. **Mobile-First**: Designed specifically for mobile platforms with excellent performance
3. **Single Codebase**: True cross-platform support with minimal platform-specific code
4. **Modern UI**: Material Design and Cupertino widgets provide a clean, modern interface
5. **Active Ecosystem**: Large community and extensive package ecosystem
6. **Good Documentation**: Comprehensive documentation and learning resources

**Secondary Recommendation: React Native**

React Native is a strong alternative if:
- The team has existing React/web development experience
- There's a desire to share code with a web version
- The larger JavaScript ecosystem is preferred

## Next Steps

1. **Decision Point**: Review this evaluation and make final tech stack decision
2. **Proof of Concept**: Create a small prototype with the selected framework to validate:
   - Touch interactions and drag-and-drop
   - Responsive layouts (landscape/portrait)
   - Result history storage
3. **Architecture Planning**: Once tech stack is selected, create architecture document
4. **Project Scaffolding**: Set up initial project structure with selected framework

## References

- [Flutter Documentation](https://flutter.dev/docs)
- [React Native Documentation](https://reactnative.dev/docs/getting-started)
- [Tauri Documentation](https://tauri.app/v1/guides/)
- [.NET MAUI Documentation](https://learn.microsoft.com/en-us/dotnet/maui/)
- [Capacitor Documentation](https://capacitorjs.com/docs)

---

_Last updated: 2026-02-09_
