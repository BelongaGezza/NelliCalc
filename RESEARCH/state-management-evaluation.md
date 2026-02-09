# State Management Evaluation

**Purpose:** Evaluate state management options for NelliCalc and recommend an approach.
**Status:** Complete — Riverpod recommended
**Date:** 2026-02-09

## NelliCalc State Requirements

Before evaluating options, it's important to understand what state NelliCalc actually manages:

### Application State
- **Current expression:** The string being built (e.g., `12 + 3.14`)
- **Current result:** The evaluated result of the expression
- **History list:** An ordered list of previous results with timestamps
- **Display mode:** What the calculator display is currently showing (expression or result)

### UI State
- **Responsive layout:** Handled by `LayoutBuilder` — not managed by state management
- **Drag-and-drop:** Handled by Flutter's `Draggable`/`DragTarget` widgets — not managed by state management
- **Bottom sheet position:** Handled by `DraggableScrollableSheet` — local widget state
- **Theme mode:** Light/dark — simple setting

### Persistence State
- **History list:** Must survive app restarts (local storage)
- **User preferences:** Theme, etc. (simple key-value storage)

### Complexity Assessment

NelliCalc's state is **simple**:
- A handful of values (expression, result, history list)
- No authentication, no network calls, no complex async flows
- No deeply nested widget trees that need state injection
- History list is the only collection, and it's append-only with reads

This means the state management solution should be **lightweight and proportionate** — an over-engineered solution would add unnecessary complexity.

## Options Evaluated

### 1. Riverpod

**Overview:** A reactive caching and data-binding framework by Remi Rousselet (author of Provider). Compile-safe, testable, and doesn't depend on `BuildContext`.

**Pros:**
- Compile-time safety (no runtime `ProviderNotFoundException`)
- Excellent testability — providers can be overridden in tests without `BuildContext`
- Code generation option (`riverpod_generator`) reduces boilerplate
- Doesn't require `BuildContext` to read state
- Good separation of concerns
- Active maintenance and strong community
- Scales well from simple to complex apps

**Cons:**
- Learning curve for the provider/ref model
- Code generation adds a build step (optional but recommended)
- More boilerplate than simple `ChangeNotifier` for trivial state
- Conceptually heavier than what NelliCalc strictly needs

**NelliCalc fit:** Good. Slightly more than needed, but the testability and clean architecture patterns pay off even for simple apps.

### 2. BLoC (Business Logic Component)

**Overview:** A predictable state management pattern using Streams. Events go in, states come out.

**Pros:**
- Very clear separation of business logic from UI
- Predictable state transitions (event → state)
- Excellent testability (test blocs independently)
- Good for complex async workflows
- Well-documented pattern

**Cons:**
- Significant boilerplate (events, states, bloc classes) for each feature
- Overkill for NelliCalc's simple state
- Learning curve for the stream/event/state model
- A calculator expression + history list doesn't justify the ceremony
- Multiple files per feature (events, states, bloc)

**NelliCalc fit:** Poor. BLoC's strengths (complex async flows, many state transitions) don't align with NelliCalc's needs. The boilerplate-to-value ratio is unfavourable.

### 3. Provider + ChangeNotifier

**Overview:** The original Flutter-recommended approach. `ChangeNotifier` classes exposed via `Provider` widgets.

**Pros:**
- Simple and easy to understand
- Minimal boilerplate
- Well-documented (Flutter's original recommendation)
- Familiar to most Flutter developers
- No code generation needed

**Cons:**
- Depends on `BuildContext` for access
- `ChangeNotifier` notifies all listeners on any change (no granular rebuilds)
- Less testable than Riverpod (needs widget tree for context)
- Manual disposal required
- Flutter team now recommends Riverpod over Provider for new projects

**NelliCalc fit:** Adequate. Would work fine for NelliCalc's simple state, but Riverpod offers meaningful improvements for minimal extra cost.

### 4. ValueNotifier / setState only

**Overview:** Use Flutter's built-in `ValueNotifier`, `ValueListenableBuilder`, and widget-local `setState` with no external package.

**Pros:**
- Zero dependencies
- Zero learning curve
- No boilerplate beyond what Flutter provides
- Perfectly adequate for simple state
- No build step or code generation

**Cons:**
- Doesn't scale well if state grows
- State sharing across widget tree requires manual wiring (passing callbacks or using `InheritedWidget`)
- Testing requires building widget trees
- No built-in dependency injection pattern

**NelliCalc fit:** Adequate for the current scope. However, if the app grows even slightly (settings screen, export history, undo/redo), the lack of structure becomes a pain point.

## Comparison Matrix

| Criteria | Riverpod | BLoC | Provider | ValueNotifier |
|----------|----------|------|----------|---------------|
| Simplicity | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Testability | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| Boilerplate | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Scalability | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| Community | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| NelliCalc fit | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |

## Recommendation: Riverpod (without code generation)

**Selected approach: Riverpod (`flutter_riverpod` package), without `riverpod_generator`**

### Rationale

1. **Right-sized for NelliCalc:** Riverpod without code generation is only slightly more complex than Provider, but provides meaningful benefits in testability and architecture
2. **Testability:** Providers can be overridden in tests without needing a widget tree — this aligns with the project's "test as you go" principle
3. **No BuildContext dependency:** Calculator logic can be accessed anywhere without threading context through callbacks
4. **Future-proof:** If NelliCalc grows (undo/redo, export, settings, themes), Riverpod handles it without architectural changes
5. **No code generation:** Skipping `riverpod_generator` keeps the build simple. The manual provider syntax is perfectly adequate for NelliCalc's handful of providers.

### Proposed Provider Structure

```dart
// Calculator state
final calculatorProvider = StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier();
});

// History list
final historyProvider = StateNotifierProvider<HistoryNotifier, List<HistoryEntry>>((ref) {
  return HistoryNotifier();
});

// Persistence (reads/writes history to local storage)
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});
```

This gives us 3 providers total — simple and proportionate.

### Why not BLoC?

BLoC requires defining event classes, state classes, and bloc classes for each feature. For a calculator with a history list, this ceremony is unjustified. The event/state model adds files and indirection without corresponding benefit.

### Why not just ValueNotifier?

ValueNotifier would work today, but would require significant restructuring if any of these features are added later: undo/redo, history export, user preferences, or multiple calculator modes. Starting with Riverpod avoids that future refactor.

## Implementation Notes for Sprint 002

- Add `flutter_riverpod: ^2.x` to `pubspec.yaml`
- Wrap the app in `ProviderScope` in `main.dart`
- Create `lib/providers/` directory for provider definitions
- Create `lib/models/` for `CalculatorState` and `HistoryEntry` data classes
- Keep providers simple — avoid premature abstraction

## References

- [Riverpod Documentation](https://riverpod.dev/)
- [flutter_riverpod package](https://pub.dev/packages/flutter_riverpod)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Provider package](https://pub.dev/packages/provider)
- [Flutter State Management](https://docs.flutter.dev/data-and-backend/state-mgmt/options)

---

_Last updated: 2026-02-09_
