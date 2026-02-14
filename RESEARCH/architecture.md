# Application Architecture

**Purpose:** Define the overall application structure, layer boundaries, component relationships, and conventions for NelliCalc.

**Status:** Complete
**Author:** System Architect
**Sprint:** sprint-002-architecture (Task 1.1)
**Date:** 2026-02-11

---

## Table of Contents

1. [Overview and Design Principles](#1-overview-and-design-principles)
2. [Layered Architecture](#2-layered-architecture)
3. [Directory Structure](#3-directory-structure)
4. [Widget Tree](#4-widget-tree)
5. [Riverpod Provider Graph](#5-riverpod-provider-graph)
6. [Data Model](#6-data-model)
7. [Calculator Engine Interface Specification](#7-calculator-engine-interface-specification)
8. [Navigation Strategy](#8-navigation-strategy)
9. [Cross-cutting Concerns](#9-cross-cutting-concerns)
10. [References](#10-references)

---

## 1. Overview and Design Principles

NelliCalc is a cross-platform calculator application whose distinguishing feature is the ability to drag and drop previous results into the current calculation. The app runs on a single screen with a responsive layout that adapts between portrait and landscape orientations.

### Design Principles

1. **Simplicity first** -- Choose the simplest solution that meets requirements. NelliCalc is a calculator with a history panel; the architecture should reflect that scope, not anticipate a future it may never have.

2. **Testability by design** -- The calculator engine is pure Dart with zero Flutter imports, making it fully unit-testable without a widget harness. State management (Riverpod) supports provider overrides for isolated testing.

3. **Separation of concerns** -- Business logic lives in the domain layer and has no knowledge of Flutter, widgets, or platform APIs. The presentation layer consumes domain state; it does not compute it.

4. **Touch-first, responsive from day one** -- The primary target is handheld touchscreen phones. Layouts are designed for portrait and landscape simultaneously, not retrofitted.

5. **Accessibility built-in** -- WCAG AA compliance is a requirement, not an afterthought. Minimum 48x48dp touch targets, adequate contrast, and screen reader support are planned from the start.

6. **Composition over inheritance** -- Widgets are small, focused, and composed together. No deep inheritance hierarchies.

---

## 2. Layered Architecture

NelliCalc uses a three-layer architecture with strict dependency direction rules.

### Layers

```
┌─────────────────────────────────────────────────────┐
│                  PRESENTATION                        │
│  Widgets, layout, drag-and-drop, user interaction    │
│  (Flutter, Riverpod ConsumerWidget)                  │
├─────────────────────────────────────────────────────┤
│                     DOMAIN                           │
│  Calculator engine, state notifiers, models          │
│  (Pure Dart — no Flutter imports)                    │
├─────────────────────────────────────────────────────┤
│                      DATA                            │
│  Persistence (local storage), repository pattern     │
│  (Dart + platform packages)                          │
└─────────────────────────────────────────────────────┘
```

### Dependency Direction

```
Presentation ──depends on──► Domain ◄──depends on── Data
```

- **Presentation depends on Domain:** Widgets read state from providers and call methods on notifiers. The presentation layer imports domain models and providers.
- **Data depends on Domain:** The data layer implements repository interfaces defined in the domain layer. It knows about domain models (to serialise/deserialise them) but the domain layer does not know about the data layer's implementation details.
- **Domain depends on neither:** The domain layer has zero imports from `package:flutter` and zero imports from data layer implementations. It defines interfaces (abstract classes) that the data layer implements.

### Dependency Direction Rules

| Rule | Description |
|------|-------------|
| **D1** | Domain layer classes must not import `package:flutter/*` or `dart:ui` |
| **D2** | Domain layer classes must not import from `lib/features/` or `lib/layout/` |
| **D3** | Domain layer defines abstract repository interfaces; data layer implements them |
| **D4** | Presentation layer may import from domain (`lib/models/`, `lib/providers/`, `lib/engine/`) |
| **D5** | Data layer may import domain models (`lib/models/`) but not presentation (`lib/features/`, `lib/layout/`) |
| **D6** | The `lib/engine/` directory must contain only pure Dart files (no Flutter dependency) |

### Layer Responsibilities

**Presentation Layer** (`lib/features/`, `lib/layout/`, `lib/app.dart`)
- Renders widgets and handles user interaction
- Reads state from Riverpod providers via `ConsumerWidget` or `ConsumerStatefulWidget`
- Dispatches actions by calling methods on state notifiers
- Manages drag-and-drop via Flutter's `LongPressDraggable` and `DragTarget`
- Handles responsive layout switching via `LayoutBuilder`

**Domain Layer** (`lib/models/`, `lib/providers/`, `lib/engine/`)
- Contains the calculator engine (expression parsing, evaluation)
- Defines data models (`CalculatorState`, `HistoryEntry`)
- Contains Riverpod state notifiers (`CalculatorNotifier`, `HistoryNotifier`)
- Defines repository interfaces for persistence
- All classes are pure Dart -- fully testable without Flutter

**Data Layer** (`lib/data/`)
- Implements repository interfaces from the domain layer
- Handles serialisation and deserialisation of domain models
- Manages local storage (reading/writing history to device)
- Wraps platform-specific storage packages

---

## 3. Directory Structure

```
lib/
├── main.dart                       # Entry point: ProviderScope + runApp
├── app.dart                        # NelliCalcApp MaterialApp widget
│
├── models/                         # Domain: data classes
│   ├── calculator_state.dart       #   CalculatorState (expression, result, error)
│   └── history_entry.dart          #   HistoryEntry (id, value, expression, timestamp)
│
├── engine/                         # Domain: calculator engine (pure Dart)
│   ├── calculator_engine.dart      #   Expression evaluation, operator handling
│   └── calculator_error.dart       #   Error types (division by zero, overflow, etc.)
│
├── providers/                      # Domain: Riverpod providers and notifiers
│   ├── calculator_provider.dart    #   CalculatorNotifier + calculatorProvider
│   ├── history_provider.dart       #   HistoryNotifier + historyProvider
│   └── history_repository_provider.dart  # historyRepositoryProvider (bridges data layer)
│
├── data/                           # Data: persistence and storage
│   ├── history_repository.dart     #   Abstract HistoryRepository interface
│   └── local_history_repository.dart  # Concrete implementation (local storage)
│
├── features/                       # Presentation: feature-specific widgets
│   ├── calculator/                 #   Calculator feature
│   │   ├── calculator_display.dart #     Expression + result display (DragTarget)
│   │   └── button_grid.dart        #     Calculator button grid
│   └── history/                    #   History feature
│       ├── history_panel.dart      #     History list (landscape side panel)
│       ├── history_sheet.dart      #     History sheet (portrait bottom sheet)
│       └── history_item.dart       #     Single draggable history item
│
├── layout/                         # Presentation: responsive layout shell
│   └── responsive_shell.dart       #   LayoutBuilder switch (wide/narrow)
│
└── poc/                            # PoC code (retained for reference, not loaded)
    ├── drag_drop_poc.dart
    └── responsive_poc.dart
```

### Directory Rationale

| Directory | Layer | Purpose |
|-----------|-------|---------|
| `models/` | Domain | Immutable data classes shared across all layers |
| `engine/` | Domain | Pure Dart calculator logic, zero Flutter dependency |
| `providers/` | Domain | Riverpod providers and StateNotifiers |
| `data/` | Data | Repository interface + implementations for persistence |
| `features/` | Presentation | Feature-scoped widgets, grouped by capability |
| `layout/` | Presentation | Responsive layout orchestration |
| `poc/` | N/A | Sprint 001 proof-of-concept (reference only) |

### Conventions

- One public class per file, named to match the class (e.g., `calculator_state.dart` contains `CalculatorState`)
- Feature directories contain only widgets for that feature
- Barrel exports are not used -- import specific files directly (avoids circular imports and improves tree-shaking)
- Test files mirror the `lib/` structure under `test/` (e.g., `test/models/calculator_state_test.dart`)

---

## 4. Widget Tree

### High-Level Tree

```
ProviderScope                           # Riverpod scope (main.dart)
└── NelliCalcApp                        # MaterialApp with theme (app.dart)
    └── ResponsiveShell                 # LayoutBuilder: wide vs narrow (layout/)
        ├── [Wide Layout]               # constraints.maxWidth >= 600dp
        │   └── Row
        │       ├── Expanded(flex: 3)
        │       │   └── Column
        │       │       ├── CalculatorDisplay   # DragTarget + expression/result
        │       │       └── ButtonGrid          # Calculator buttons
        │       ├── VerticalDivider
        │       └── Expanded(flex: 2)
        │           └── HistoryPanel            # Scrollable history list
        │
        └── [Narrow Layout]            # constraints.maxWidth < 600dp
            └── Stack
                ├── Column
                │   ├── CalculatorDisplay       # DragTarget + expression/result
                │   └── ButtonGrid              # Calculator buttons
                └── DraggableScrollableSheet    # History as bottom sheet
                    └── HistorySheet            # History list in sheet
```

### Widget Responsibilities

| Widget | File | Role |
|--------|------|------|
| `ProviderScope` | `main.dart` | Riverpod dependency injection root |
| `NelliCalcApp` | `app.dart` | `MaterialApp` configuration, theme, home screen |
| `ResponsiveShell` | `layout/responsive_shell.dart` | `LayoutBuilder` that switches between wide and narrow layouts |
| `CalculatorDisplay` | `features/calculator/calculator_display.dart` | Shows the current expression and result; acts as a `DragTarget` for history items |
| `ButtonGrid` | `features/calculator/button_grid.dart` | Grid of calculator buttons (digits, operators, clear, equals) |
| `HistoryPanel` | `features/history/history_panel.dart` | Scrollable list of history items for wide (landscape) layout |
| `HistorySheet` | `features/history/history_sheet.dart` | `DraggableScrollableSheet` wrapper for narrow (portrait) layout |
| `HistoryItem` | `features/history/history_item.dart` | Single `LongPressDraggable<String>` history entry |

### Key Design Decisions

- **ResponsiveShell is layout-only:** It does not contain business logic. It reads the available width via `LayoutBuilder` and composes the appropriate arrangement of child widgets.
- **CalculatorDisplay and HistoryPanel are independent:** They do not reference each other directly. They communicate through Riverpod providers. This makes them testable and reusable in both layout modes.
- **HistoryItem is shared:** The same `HistoryItem` widget is used inside both `HistoryPanel` (wide) and `HistorySheet` (narrow). Only the container differs.
- **No Scaffold inside ResponsiveShell:** The `Scaffold` (with AppBar) lives in `NelliCalcApp` or at the `ResponsiveShell` level, not duplicated per layout mode.

### Breakpoint Constant

```dart
/// Width threshold for switching between narrow and wide layouts.
///
/// At or above this value, the app displays calculator and history
/// side by side. Below it, history is accessible via a bottom sheet.
///
/// 600dp aligns with Material Design's compact/medium breakpoint.
const double kWideLayoutBreakpoint = 600;
```

---

## 5. Riverpod Provider Graph

### Provider Definitions

NelliCalc uses three providers, matching the state management evaluation recommendation.

```dart
/// Manages the current calculator state (expression, result, error).
///
/// The notifier delegates evaluation to [CalculatorEngine] and
/// updates [CalculatorState] immutably on each action.
final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier();
});

/// Manages the ordered list of calculation history entries.
///
/// Entries are appended when the user presses equals and the
/// expression evaluates successfully. The notifier interacts with
/// [HistoryRepository] for persistence.
final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<HistoryEntry>>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repository: repository);
});

/// Provides the persistence layer for history entries.
///
/// Returns a concrete [LocalHistoryRepository] that reads and writes
/// to local device storage. Can be overridden in tests with an
/// in-memory implementation.
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return LocalHistoryRepository();
});
```

### Provider Dependency Graph

```
historyRepositoryProvider (Provider<HistoryRepository>)
        │
        │ ref.watch
        ▼
historyProvider (StateNotifierProvider<HistoryNotifier, List<HistoryEntry>>)

calculatorProvider (StateNotifierProvider<CalculatorNotifier, CalculatorState>)
        │
        │ (no provider dependency -- standalone)
        │
        └── internally uses CalculatorEngine (constructor injection, not a provider)
```

### Provider Details

| Provider | Type | Exposes | Dependencies | Consumed By |
|----------|------|---------|--------------|-------------|
| `calculatorProvider` | `StateNotifierProvider` | `CalculatorState` | None (engine injected via constructor) | `CalculatorDisplay`, `ButtonGrid` |
| `historyProvider` | `StateNotifierProvider` | `List<HistoryEntry>` | `historyRepositoryProvider` | `HistoryPanel`, `HistorySheet`, `HistoryItem` |
| `historyRepositoryProvider` | `Provider` | `HistoryRepository` | None (creates `LocalHistoryRepository`) | `historyProvider` |

### Notifier Responsibilities

**CalculatorNotifier**
- Holds a `CalculatorEngine` instance (injected, not a provider)
- Methods: `inputDigit(String)`, `inputOperator(String)`, `inputDecimal()`, `evaluate()`, `clear()`, `backspace()`, `insertValue(String)` (for drag-and-drop)
- On `evaluate()`: delegates to `CalculatorEngine`, updates state with result or error
- On `insertValue()`: appends the dropped value to the current expression

**HistoryNotifier**
- Holds a `HistoryRepository` reference (injected via constructor)
- Methods: `addEntry(HistoryEntry)`, `removeEntry(String id)`, `loadHistory()`, `clearHistory()`
- On `addEntry()`: prepends to the list and persists
- On `loadHistory()`: reads from repository, populates the list (called on app start)

### Interaction Flow: User Presses Equals

```
ButtonGrid                                        CalculatorDisplay
    │                                                    │
    │  ref.read(calculatorProvider.notifier).evaluate()   │
    │ ──────────────────────────────────────────────────► │
    │                                                    │
    │  CalculatorNotifier.evaluate()                     │
    │    └── CalculatorEngine.evaluate(expression)       │
    │    └── state = state.copyWith(result: value)       │
    │                                                    │
    │  ref.read(historyProvider.notifier)                │
    │      .addEntry(HistoryEntry(...))                  │
    │    └── HistoryNotifier.addEntry()                  │
    │    └── repository.save(entry)                      │
    │                                                    │
    ▼                                                    ▼
  UI rebuilds: display shows result     History rebuilds: new entry appears
```

### Interaction Flow: User Drags History Item to Display

```
HistoryItem (LongPressDraggable<String>)
    │
    │  User long-presses, drags to CalculatorDisplay
    │
    ▼
CalculatorDisplay (DragTarget<String>)
    │
    │  onAcceptWithDetails: (details) {
    │    ref.read(calculatorProvider.notifier)
    │        .insertValue(details.data);
    │  }
    │
    ▼
CalculatorNotifier.insertValue(value)
    │
    │  state = state.copyWith(
    │    expression: '${state.expression}$value',
    │  );
    │
    ▼
  UI rebuilds: expression updated with dropped value
```

### Testing Strategy for Providers

- **Override `historyRepositoryProvider`** in tests with an in-memory implementation to avoid real storage
- **Test `CalculatorNotifier`** by constructing it directly with a mock/fake `CalculatorEngine`
- **Test `HistoryNotifier`** by constructing it with a fake `HistoryRepository`
- Provider integration tests use Riverpod's `ProviderContainer` with overrides

---

## 6. Data Model

This section provides the complete data model specification for NelliCalc, covering all domain model classes, their equality semantics, serialisation, and persistence strategy.

### 6.1 Design Principles

- **Immutable data classes** -- All model fields are `final`. State changes produce new instances via `copyWith`.
- **Value equality** -- Classes mix in `Equatable` for structural equality. This enables Riverpod to detect state changes without custom `==` / `hashCode` overrides.
- **No code generation** -- With only two small model classes, manual `copyWith` and `Equatable` props are simpler and faster than introducing `freezed`, `json_serializable`, or `build_runner`.
- **Pure Dart** -- Model classes import only `package:equatable/equatable.dart` and `package:uuid/uuid.dart`. Zero Flutter imports. This keeps the domain layer fully unit-testable with `package:test`.

### 6.2 CalculatorError

Defined in `lib/engine/calculator_error.dart`. This is referenced by `CalculatorState` and is part of the domain layer.

```dart
/// Categories of calculator evaluation failures.
enum CalculatorErrorType {
  /// Division by zero (e.g., `10 / 0`).
  divisionByZero,

  /// The expression could not be parsed (e.g., `3 + + 4`).
  malformedExpression,

  /// The result exceeds the representable range.
  overflow,

  /// An unexpected error occurred during evaluation.
  unknownError,
}

/// Represents an error produced by the calculator engine.
///
/// Errors are stored as data in [CalculatorState], not thrown to the UI.
class CalculatorError extends Equatable {
  const CalculatorError({
    required this.type,
    required this.message,
  });

  /// The category of the error.
  final CalculatorErrorType type;

  /// A human-readable description of what went wrong.
  final String message;

  @override
  List<Object?> get props => [type, message];
}
```

### 6.3 CalculatorState

Defined in `lib/models/calculator_state.dart`. Represents the current state of the calculator at any moment.

```dart
import 'package:equatable/equatable.dart';

import '../engine/calculator_error.dart';

/// The complete state of the calculator at a point in time.
///
/// This class is immutable. Use [copyWith] to produce a new state
/// with one or more fields changed.
class CalculatorState extends Equatable {
  const CalculatorState({
    this.expression = '',
    this.display = '0',
    this.result,
    this.error,
  });

  /// The mathematical expression being built (e.g., `'12 + 3.14'`).
  ///
  /// Empty string when the calculator is freshly cleared.
  final String expression;

  /// The text currently shown on the calculator display.
  ///
  /// Defaults to `'0'`. Updated as the user types digits/operators,
  /// and replaced with the formatted result after evaluation.
  final String display;

  /// The evaluated result, or `null` if the expression has not been
  /// evaluated or the last evaluation produced an error.
  final double? result;

  /// The error from the last evaluation attempt, or `null` if the
  /// last evaluation succeeded (or no evaluation has occurred).
  final CalculatorError? error;

  /// Returns `true` when the calculator is in an error state.
  bool get hasError => error != null;

  /// Returns `true` when a successful result is available.
  bool get hasResult => result != null && !hasError;

  /// Creates a copy of this state with the given fields replaced.
  CalculatorState copyWith({
    String? expression,
    String? display,
    double? Function()? result,
    CalculatorError? Function()? error,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      display: display ?? this.display,
      result: result != null ? result() : this.result,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [expression, display, result, error];
}
```

**Notes on `copyWith` signature:**

- The `result` and `error` parameters use `T? Function()?` (a nullable factory) rather than `T?`. This allows callers to explicitly set the field to `null` (e.g., `copyWith(error: () => null)` to clear an error), which would be impossible with a plain `T?` parameter since `null` would mean "keep the existing value".
- The `expression` and `display` parameters use plain `String?` because setting them to `null` is never needed (they always have meaningful string values).

### 6.4 HistoryEntry

Defined in `lib/models/history_entry.dart`. Represents one completed calculation in the history list.

```dart
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// A single completed calculation stored in the history list.
///
/// Each entry has a stable [id] (UUID v4) that persists across
/// drag operations, serialisation, and app restarts.
class HistoryEntry extends Equatable {
  HistoryEntry({
    String? id,
    required this.expression,
    required this.result,
    DateTime? timestamp,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  /// Unique identifier (UUID v4).
  ///
  /// Used by Flutter to track draggable items across the widget tree
  /// and by the persistence layer to identify entries.
  final String id;

  /// The expression that produced this result (e.g., `'12 + 3.14'`).
  final String expression;

  /// The evaluated result value.
  final double result;

  /// When the calculation was performed (UTC).
  final DateTime timestamp;

  /// The result formatted for display and drag-and-drop.
  ///
  /// Returns an integer string if the result has no fractional part
  /// (e.g., `'42'` instead of `'42.0'`), otherwise the full double
  /// string (e.g., `'3.14'`).
  String get displayValue {
    return result == result.truncateToDouble()
        ? result.toInt().toString()
        : result.toString();
  }

  /// Creates a copy of this entry with the given fields replaced.
  HistoryEntry copyWith({
    String? id,
    String? expression,
    double? result,
    DateTime? timestamp,
  }) {
    return HistoryEntry(
      id: id ?? this.id,
      expression: expression ?? this.expression,
      result: result ?? this.result,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Serialises this entry to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Deserialises a [HistoryEntry] from a JSON-compatible map.
  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] as String,
      expression: json['expression'] as String,
      result: (json['result'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  List<Object?> get props => [id, expression, result, timestamp];
}
```

**Notes:**

- The constructor generates a UUID v4 and captures `DateTime.now()` by default, but accepts explicit values for deserialisation and testing.
- `displayValue` is a computed property, not a stored field. It ensures drag-and-drop inserts clean numbers (e.g., `'42'` rather than `'42.0'`).
- `toJson` / `fromJson` are defined directly on the model class. With only one model needing serialisation, a separate mapper class would be unnecessary indirection.
- `Equatable` props include all four fields, meaning two entries are equal only if they share the same ID, expression, result, and timestamp.

### 6.5 UUID Generation

**Package:** [`uuid`](https://pub.dev/packages/uuid) (version `^4.0.0`)

- UUID v4 (random) is used for `HistoryEntry.id`.
- The `Uuid` instance is created with `const Uuid()` (the class is stateless and const-constructible).
- UUIDs provide stable identity for history entries across drag-and-drop operations, list reordering, serialisation round-trips, and widget key tracking.
- The `uuid` package is pure Dart with no Flutter dependency, keeping the model layer clean.

### 6.6 Persistence Strategy

#### Package Evaluation

| Package | Type | Pros | Cons |
|---------|------|------|------|
| `shared_preferences` | Key-value store | Simple API, widely used, minimal setup | No structured queries; stores entire JSON blob as a single string; 1 MB practical limit on some platforms |
| `hive` | NoSQL document store | Fast reads, pure Dart, no native dependencies, box-per-collection model | Heavier dependency for simple needs; custom type adapters required; less widely maintained since 2024 |
| `sqflite` | SQLite wrapper | Structured queries, mature, handles large datasets | Requires native binaries; overkill for a flat list of ~100 entries; platform limitations (no Linux desktop without `sqflite_common_ffi`) |

#### Recommendation: `shared_preferences`

**Justification:**

1. **Scope fit** -- NelliCalc stores a single list of history entries, capped at a reasonable limit (e.g., 100 entries). This is comfortably within `shared_preferences` capacity.
2. **Simplicity** -- No schema definitions, no migration strategy, no type adapters. Read a JSON string, parse it, done.
3. **Cross-platform** -- Works on Android, iOS, macOS, Windows, Linux, and web with zero additional setup.
4. **Minimal dependency surface** -- Fewer transitive dependencies than `hive` or `sqflite`.
5. **Migration path** -- If NelliCalc later outgrows `shared_preferences`, the abstract `HistoryRepository` interface means the data layer implementation can be swapped without touching domain or presentation code.

#### Serialisation Format

History entries are serialised as a **JSON array of objects**, stored under a single key in `shared_preferences`.

**Storage key:** `'history_entries'`

**Example stored value:**

```json
[
  {
    "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "expression": "12 + 3.14",
    "result": 15.14,
    "timestamp": "2026-02-11T14:30:00.000Z"
  },
  {
    "id": "f9e8d7c6-b5a4-3210-fedc-ba0987654321",
    "expression": "42 * 2",
    "result": 84.0,
    "timestamp": "2026-02-11T14:29:00.000Z"
  }
]
```

Serialisation uses `dart:convert` (`jsonEncode` / `jsonDecode`) with the `toJson` / `fromJson` methods on `HistoryEntry`.

#### Read/Write Patterns

| Operation | When | Method |
|-----------|------|--------|
| **Load** | App startup (`HistoryNotifier` construction) | Read the JSON string from `shared_preferences`, decode it, map each object to `HistoryEntry.fromJson()`, populate the state list |
| **Save** | After each new entry is added or an entry is removed | Encode the full `List<HistoryEntry>` to JSON via `toJson()`, write the JSON string to `shared_preferences` |
| **Clear** | User clears history | Remove the `'history_entries'` key from `shared_preferences` |

**Design notes:**

- The entire list is written on each save (full replacement, not incremental). With a capped list of ~100 small entries, the serialised JSON is well under 50 KB -- negligible for `shared_preferences`.
- Reads and writes are asynchronous (`Future`-based). The `HistoryNotifier` awaits persistence but does not block the UI on failure (see Section 9.1, Persistence Errors).
- A maximum history size (e.g., 100 entries) is enforced in the `HistoryNotifier`, not in the repository. When the limit is reached, the oldest entry is dropped before persisting.

#### HistoryRepository Interface

Defined in `lib/data/history_repository.dart`. The domain layer depends on this abstract interface; the data layer provides the concrete implementation.

```dart
/// Abstract interface for persisting and retrieving history entries.
///
/// The domain layer depends on this interface. The data layer provides
/// a concrete implementation (e.g., [LocalHistoryRepository]).
/// Tests can substitute an in-memory implementation.
abstract class HistoryRepository {
  /// Loads all persisted history entries, ordered by timestamp
  /// (most recent first).
  ///
  /// Returns an empty list if no entries have been persisted or
  /// if the storage is inaccessible.
  Future<List<HistoryEntry>> loadAll();

  /// Persists the given list of [entries], replacing any previously
  /// stored data.
  ///
  /// The list should be in display order (most recent first).
  Future<void> saveAll(List<HistoryEntry> entries);

  /// Removes all persisted history entries.
  Future<void> clear();
}
```

**Concrete implementation:** `LocalHistoryRepository` in `lib/data/local_history_repository.dart` implements `HistoryRepository` using `shared_preferences`.

```dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_entry.dart';
import 'history_repository.dart';

/// Persists history entries to local device storage using
/// [SharedPreferences].
class LocalHistoryRepository implements HistoryRepository {
  static const String _storageKey = 'history_entries';

  @override
  Future<List<HistoryEntry>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAll(List<HistoryEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
```

#### Testing the Persistence Layer

An in-memory implementation is used in tests to avoid real storage:

```dart
class InMemoryHistoryRepository implements HistoryRepository {
  List<HistoryEntry> _entries = [];

  @override
  Future<List<HistoryEntry>> loadAll() async => List.of(_entries);

  @override
  Future<void> saveAll(List<HistoryEntry> entries) async {
    _entries = List.of(entries);
  }

  @override
  Future<void> clear() async {
    _entries = [];
  }
}
```

This is injected via Riverpod's `historyRepositoryProvider` override in test setup.

### 6.7 Package Dependencies (Data Model)

| Package | Version | Purpose | Layer |
|---------|---------|---------|-------|
| `equatable` | `^2.0.7` | Value equality for model classes | Domain |
| `uuid` | `^4.0.0` | UUID v4 generation for `HistoryEntry.id` | Domain |
| `shared_preferences` | `^2.3.0` | Local key-value persistence | Data |

All three packages are well-maintained, widely used in the Flutter ecosystem, and have no conflicting licence restrictions.

---

## 7. Calculator Engine Interface Specification

### 7.1 Design Goals

- **Pure Dart class** with zero Flutter imports -- fully unit-testable with `package:test`
- **Stateless evaluation** -- the engine receives an expression string and returns a result; it holds no mutable state between calls
- **Standard operator precedence** -- BODMAS/PEMDAS rules as defined in Section 7.4
- **Deterministic error handling** -- all failure modes produce a typed `CalculatorError`, never unhandled exceptions

### 7.2 Engine Class Interface

The calculator engine exposes a single public method. It is constructed once by `CalculatorNotifier` and reused for every evaluation.

```dart
/// Evaluates mathematical expressions.
///
/// The engine is a pure Dart class with no Flutter dependency.
/// It receives an expression string built by [CalculatorNotifier]
/// as the user taps buttons, and returns a numeric result.
///
/// All failure modes throw [CalculatorError] with a typed reason.
///
/// Example:
/// ```dart
/// final engine = CalculatorEngine();
/// final result = engine.evaluate('(2 + 3) * 4'); // 20.0
/// ```
class CalculatorEngine {
  /// Evaluates the given mathematical [expression] and returns the
  /// numeric result as a [double].
  ///
  /// Supported tokens: digits (`0`-`9`), decimal point (`.`),
  /// operators (`+`, `-`, `*`, `/`), parentheses (`(`, `)`),
  /// and whitespace (ignored).
  ///
  /// Throws [CalculatorError] if:
  /// - The expression is empty or blank
  /// - The expression is syntactically malformed
  /// - Division by zero is encountered
  /// - The result overflows (infinity or NaN)
  ///
  /// The method is stateless: calling it multiple times with the same
  /// input always produces the same output.
  double evaluate(String expression);
}
```

#### Interaction with CalculatorNotifier

The `CalculatorNotifier` owns a `CalculatorEngine` instance and delegates evaluation when the user presses equals:

```dart
class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier({CalculatorEngine? engine})
      : _engine = engine ?? CalculatorEngine(),
        super(const CalculatorState());

  final CalculatorEngine _engine;

  // --- Input methods (build the expression string) ---

  /// Appends a digit character ('0'-'9') to the current expression.
  void inputDigit(String digit);

  /// Appends an operator ('+', '-', '*', '/') to the current expression.
  void inputOperator(String operator);

  /// Appends a decimal point to the current expression.
  void inputDecimal();

  /// Appends an opening or closing parenthesis to the expression.
  void inputParenthesis(String paren);

  /// Inserts a value from a dragged history item into the expression.
  void insertValue(String value);

  // --- Action methods ---

  /// Delegates the current expression to [CalculatorEngine.evaluate],
  /// updates state with the result or error.
  void evaluate();

  /// Resets the expression, display, result, and error to defaults.
  void clear();

  /// Removes the last character from the current expression.
  void backspace();
}
```

The engine is injected via the constructor, enabling tests to supply a mock or fake implementation without Riverpod overrides.

### 7.3 Expression Representation Decision

The expression string is built incrementally by `CalculatorNotifier` as the user taps calculator buttons. The engine receives the completed string for evaluation.

#### Options Evaluated

| Approach | Description | Pros | Cons |
|----------|-------------|------|------|
| **String-based** | Expression stored as a plain `String`; engine parses it on `evaluate()` | Simple mental model; trivial to display; easy to append/backspace | Must parse each time; harder to validate incrementally |
| **Token list** | Expression stored as `List<Token>` (number, operator, paren) | Type-safe; incremental validation possible | More complex data model; display requires reassembly; overkill for this scope |
| **AST** | Expression stored as a tree of nodes | Full structural representation; optimisable | Significant complexity for a basic calculator; no benefit without advanced features |

#### Decision: String-based representation

**Rationale:** NelliCalc is a basic four-function calculator with parentheses. The expression is built character-by-character via button taps and displayed directly to the user. A plain string is the simplest representation that meets all requirements:

1. **Display is trivial** -- the expression string *is* the display text.
2. **Backspace is trivial** -- remove the last character (or last logical token with minimal string inspection).
3. **Drag-and-drop insertion is trivial** -- concatenate the dropped value string.
4. **Parsing is a one-time cost** -- the engine parses the string only when the user presses equals, not on every keystroke.

The token list and AST approaches add complexity that would only pay off for features not in scope (syntax highlighting, incremental validation, expression rewriting). If future sprints require these capabilities, the engine's internal implementation can adopt tokenisation without changing the public API.

### 7.4 Operator Precedence Rules (BODMAS/PEMDAS)

The engine follows standard mathematical operator precedence, evaluated using a recursive descent parser internally.

| Precedence | Category | Operators | Associativity |
|:----------:|----------|-----------|---------------|
| 1 (highest) | Parentheses | `(`, `)` | N/A (grouping) |
| 2 | Unary minus | `-` (prefix) | Right-to-left |
| 3 | Multiplication, Division | `*`, `/` | Left-to-right |
| 4 (lowest) | Addition, Subtraction | `+`, `-` | Left-to-right |

#### Precedence Examples

| Expression | Evaluation Order | Result |
|------------|-----------------|--------|
| `2 + 3 * 4` | `2 + (3 * 4)` | `14` |
| `(2 + 3) * 4` | `(2 + 3) * 4` | `20` |
| `10 / 2 * 3` | `(10 / 2) * 3` | `15` |
| `10 - 2 + 3` | `(10 - 2) + 3` | `11` |
| `-5 + 3` | `(-5) + 3` | `-2` |
| `-(2 + 3)` | `-(2 + 3)` | `-5` |
| `2 * -3` | `2 * (-3)` | `-6` |

#### Unary Minus Rules

The `-` character is interpreted as unary minus (negation) when it appears:

1. At the start of the expression: `-5 + 3`
2. Immediately after an opening parenthesis: `(-5 + 3)`
3. Immediately after an operator: `2 * -3`

In all other positions, `-` is interpreted as the binary subtraction operator.

### 7.5 Parsing Strategy

#### Options Evaluated

| Approach | Package | Pros | Cons |
|----------|---------|------|------|
| **`math_expressions`** | `pub.dev/packages/math_expressions` | Mature; handles variables, functions, differentiation | Heavyweight for basic arithmetic; pulls in features NelliCalc does not need; less control over error messages |
| **`petitparser`** | `pub.dev/packages/petitparser` | Powerful PEG parser combinator framework; flexible | General-purpose parsing framework; learning curve; adds a dependency for a grammar that fits in ~100 lines |
| **Custom recursive descent** | N/A (hand-written) | Full control; precise error messages; zero dependencies; small codebase | Must be implemented and tested manually |

#### Decision: Custom recursive descent parser

**Rationale:** NelliCalc's expression grammar is deliberately small -- four binary operators, unary minus, parentheses, and decimal numbers. This grammar is a textbook case for a recursive descent parser, which can be implemented in approximately 100-150 lines of Dart:

1. **Zero external dependencies** -- the engine remains a self-contained pure Dart unit with no third-party packages.
2. **Precise error reporting** -- a hand-written parser can produce clear, user-friendly error messages (e.g., "Unexpected character at position 5") rather than generic parse failures.
3. **Full control over edge cases** -- unary minus handling, implicit multiplication rules (if added later), and specific overflow checks are straightforward to implement.
4. **Minimal code surface** -- the grammar has only four precedence levels and seven token types. A parser combinator framework or expression library would be overkill.

#### Grammar (informal BNF)

```
expression  ::= term (('+' | '-') term)*
term        ::= unary (('*' | '/') unary)*
unary       ::= '-' unary | primary
primary     ::= NUMBER | '(' expression ')'
NUMBER      ::= DIGIT+ ('.' DIGIT+)?
DIGIT       ::= '0' | '1' | ... | '9'
```

#### Implementation Sketch

The parser operates on the expression string using a cursor (character index). Each grammar rule is a method that advances the cursor and returns a `double`:

```dart
class CalculatorEngine {
  late String _source;
  late int _pos;

  double evaluate(String expression) {
    _source = expression.trim();
    _pos = 0;

    if (_source.isEmpty) {
      throw const CalculatorError(
        type: CalculatorErrorType.malformedExpression,
        message: 'Expression is empty.',
      );
    }

    final result = _parseExpression();
    _skipWhitespace();

    if (_pos < _source.length) {
      throw CalculatorError(
        type: CalculatorErrorType.malformedExpression,
        message: 'Unexpected character: "${_source[_pos]}".',
      );
    }

    return _validateResult(result);
  }

  double _parseExpression() { /* addition/subtraction */ }
  double _parseTerm() { /* multiplication/division */ }
  double _parseUnary() { /* unary minus */ }
  double _parsePrimary() { /* numbers and parenthesised groups */ }

  double _validateResult(double value) {
    if (value.isInfinite) {
      throw const CalculatorError(
        type: CalculatorErrorType.overflow,
        message: 'Result is too large.',
      );
    }
    if (value.isNaN) {
      throw const CalculatorError(
        type: CalculatorErrorType.malformedExpression,
        message: 'Result is undefined.',
      );
    }
    return value;
  }
}
```

### 7.6 Error Handling Strategy

The engine communicates all errors by throwing `CalculatorError`. The `CalculatorNotifier` catches these and stores them in `CalculatorState.error` for the UI to display. Errors never propagate as unhandled exceptions to the widget layer.

#### Error Types

| Error Type | Trigger | User-Facing Message (example) |
|------------|---------|-------------------------------|
| `divisionByZero` | Divisor evaluates to zero (`10 / 0`) | "Cannot divide by zero" |
| `malformedExpression` | Unparseable input (`3 + + 4`, `3 +`, unmatched parentheses) | "Invalid expression" |
| `overflow` | Result is `double.infinity` or `double.negativeInfinity` | "Result is too large" |
| `unknownError` | Catch-all for unexpected failures | "Calculation error" |

#### CalculatorError Definition

This type is defined in `lib/engine/calculator_error.dart` (also outlined in Section 9.1):

```dart
/// Types of calculator evaluation errors.
enum CalculatorErrorType {
  /// Division by zero encountered during evaluation.
  divisionByZero,

  /// The expression could not be parsed.
  malformedExpression,

  /// The result exceeds representable range (infinity or NaN).
  overflow,

  /// An unexpected error occurred.
  unknownError,
}

/// An error produced by [CalculatorEngine] during evaluation.
///
/// Errors carry a [type] for programmatic handling and a [message]
/// for display to the user.
class CalculatorError implements Exception {
  const CalculatorError({
    required this.type,
    required this.message,
  });

  /// The category of error.
  final CalculatorErrorType type;

  /// A human-readable description of the error.
  final String message;

  @override
  String toString() => 'CalculatorError($type): $message';
}
```

#### Error Flow

```
User presses '='
    │
    ▼
CalculatorNotifier.evaluate()
    │
    ├── try: result = _engine.evaluate(expression)
    │   └── state = state.copyWith(result: result, display: formatResult(result), error: null)
    │
    └── on CalculatorError catch (e):
        └── state = state.copyWith(result: null, error: e)
            │
            ▼
        CalculatorDisplay reads state.error
            └── Shows error message to user
```

#### Edge Case: Empty Expression

When the user presses equals with an empty expression, the engine throws `CalculatorError` with type `malformedExpression` and message "Expression is empty." The `CalculatorNotifier` may optionally intercept this case before calling the engine (returning early with no state change) to avoid displaying an error for a benign action. This is a UX decision to be finalised during widget implementation.

### 7.7 Decimal Precision Strategy

#### Internal Representation: `double`

Results are stored as Dart `double` (IEEE 754 64-bit floating point).

**Rationale:** NelliCalc is a general-purpose handheld calculator, not a financial or scientific application. The `double` type provides approximately 15-17 significant decimal digits of precision, which is more than sufficient for everyday calculations. Using a `Decimal` package (e.g., `package:decimal`) would add a dependency and complexity for a precision level that users of a basic calculator neither expect nor require.

**Trade-off acknowledged:** Floating-point arithmetic produces well-known representation artefacts (e.g., `0.1 + 0.2 = 0.30000000000000004`). These are handled at the display formatting layer, not the engine layer.

#### Display Formatting Rules

The `CalculatorNotifier` (not the engine) is responsible for formatting the `double` result into a display string. The engine returns raw `double` values.

| Rule | Behaviour | Example |
|------|-----------|---------|
| **Strip trailing zeros** | Remove unnecessary zeros after the decimal point | `4.0` displays as `"4"`, `3.10` displays as `"3.1"` |
| **Maximum decimal places** | Display up to 10 significant decimal digits | `1 / 3` displays as `"0.3333333333"` |
| **Floating-point correction** | Round to 10 significant digits before formatting to eliminate artefacts | `0.1 + 0.2` displays as `"0.3"` (not `"0.30000000000000004"`) |
| **Large numbers** | Use standard notation up to 10^15; use scientific notation beyond | `999999999999999` stays as-is; `1e16` displays as `"1e+16"` |
| **Small numbers** | Use standard notation down to 10^-10; use scientific notation beyond | `0.0000000001` stays as-is; `1e-11` displays as `"1e-11"` |

#### Formatting Implementation Sketch

```dart
/// Formats a [double] result for display on the calculator screen.
///
/// Strips trailing zeros, caps decimal places at 10 significant
/// digits, and corrects common floating-point artefacts.
String formatResult(double value) {
  // Round to 10 significant digits to eliminate artefacts.
  final rounded = double.parse(value.toStringAsPrecision(10));

  // Let Dart choose fixed or scientific notation.
  var text = rounded.toString();

  // Strip trailing zeros after decimal point.
  if (text.contains('.')) {
    text = text.replaceAll(RegExp(r'0+$'), '');
    text = text.replaceAll(RegExp(r'\.$'), '');
  }

  return text;
}
```

> **Note:** The exact formatting logic will be refined during implementation (Sprint 003). The rules above establish the design intent.

### 7.8 Supported Operations (Initial Scope)

| Operation | Symbol | Example | Result |
|-----------|--------|---------|--------|
| Addition | `+` | `3 + 4` | `7` |
| Subtraction | `-` | `10 - 3` | `7` |
| Multiplication | `*` | `6 * 7` | `42` |
| Division | `/` | `15 / 3` | `5` |
| Parentheses | `(`, `)` | `(2 + 3) * 4` | `20` |
| Decimal numbers | `.` | `3.14 + 1` | `4.14` |
| Unary minus | `-` (prefix) | `-5 + 3` | `-2` |

### 7.9 Future Extensions

The following operations are **not in scope** for the initial engine implementation but are noted here for architectural awareness. The recursive descent parser design accommodates these as additional grammar rules without restructuring:

| Feature | Notes |
|---------|-------|
| **Percentage** (`%`) | New unary postfix operator; requires grammar extension at the `unary` level |
| **Square root** | New unary prefix function; add a `function` rule to the grammar |
| **Memory operations** (M+, M-, MR, MC) | State held in `CalculatorNotifier`, not the engine; engine remains stateless |
| **Scientific operations** (sin, cos, log, etc.) | Add function-call syntax to the grammar; consider `math_expressions` package at that point |
| **Implicit multiplication** | e.g., `2(3+4)` interpreted as `2*(3+4)`; handle in the parser's `primary` rule |

The public API (`double evaluate(String expression)`) is designed to remain stable as these features are added. Extensions modify the parser internals and the set of recognised tokens, not the engine's contract with its callers.

---

## 8. Navigation Strategy

NelliCalc is a **single-screen application**. There is no multi-page navigation, no route stack, and no `Navigator` usage in the initial release.

### Current Approach

- The `MaterialApp` defines a single `home` widget (`ResponsiveShell`)
- No named routes, no `GoRouter`, no route generation
- The history panel is part of the same screen (side panel or bottom sheet), not a separate page

### When Navigation May Be Needed

Navigation would be introduced only if the app gains additional screens, such as:

- Settings screen (theme, precision, history limits)
- About/help screen
- History detail view (tap to see full expression breakdown)

If navigation is needed in a future sprint, the recommendation is:

1. Use `GoRouter` (declarative, type-safe routing)
2. Define routes in a central `lib/routing/` directory
3. Keep the current single-screen architecture as the primary route

This is explicitly deferred -- do not add routing infrastructure until a second screen is needed.

---

## 9. Cross-cutting Concerns

### 9.1 Error Handling

**Calculator Errors**

The calculator engine defines a `CalculatorError` type that covers evaluation failures:

```dart
enum CalculatorErrorType {
  divisionByZero,
  malformedExpression,
  overflow,
  unknownError,
}

class CalculatorError {
  const CalculatorError({
    required this.type,
    required this.message,
  });

  final CalculatorErrorType type;
  final String message;
}
```

- Errors are part of `CalculatorState` (the `error` field), not thrown as exceptions to the UI
- The `CalculatorNotifier` catches engine exceptions and maps them to `CalculatorError` values
- The `CalculatorDisplay` widget checks `state.error` and renders an appropriate message

**Persistence Errors**

- The `HistoryRepository` methods return `Future` values; failures are handled within the notifier
- Failed persistence should not block the UI -- the history list continues to work in memory
- Persistence failures are logged but do not surface error dialogs to the user (the data is non-critical and will be retried on next save)

**General Principle:** Errors are represented as data in state objects, not as unhandled exceptions. Widgets react to error state; they do not catch exceptions.

### 9.2 Logging

- Use Dart's built-in `dart:developer` `log()` function for development logging
- No third-party logging package needed at this scale
- Log categories:
  - `engine` -- calculator evaluation events and errors
  - `persistence` -- storage read/write operations
  - `state` -- state transitions in notifiers (debug builds only)
- Production builds should minimise log output (use `kDebugMode` or `kReleaseMode` guards)

### 9.3 Theming

- Use Material Design 3 via `ThemeData` with `ColorScheme.fromSeed()`
- Support light and dark themes (implementation in Sprint 007)
- Theme is configured in `app.dart`, not scattered across widgets
- Widgets use `Theme.of(context)` for colours and text styles -- no hardcoded values

### 9.4 Platform Considerations

- **Primary target:** Handheld touchscreen phones (iOS, Android)
- **Secondary targets:** macOS, Windows, Linux (desktop)
- **Touch targets:** Minimum 48x48dp for all interactive elements
- **Keyboard input:** Not required initially, but the architecture does not preclude it (the engine accepts string expressions regardless of input method)
- Platform-specific code should be isolated behind abstract interfaces if needed (e.g., haptic feedback)

### 9.5 Testing Strategy

| Layer | Test Type | Framework | Notes |
|-------|-----------|-----------|-------|
| Engine | Unit tests | `package:test` | Pure Dart, no Flutter dependency |
| Models | Unit tests | `package:test` | Pure Dart, test construction, equality, copyWith |
| Notifiers | Unit tests | `package:test` + Riverpod `ProviderContainer` | Override providers for isolation |
| Repositories | Unit tests | `package:test` | Test with in-memory storage |
| Widgets | Widget tests | `package:flutter_test` | Test rendering, interaction, provider consumption |
| Integration | Integration tests | `package:integration_test` | Full app flows (Sprint 008+) |

Unit tests are required from Sprint 003 onwards. The architecture ensures that the most critical logic (the calculator engine) can be tested with plain Dart unit tests, requiring no Flutter test harness.

---

## 10. References

### Project Documents

- [Tech Stack Evaluation](tech-stack-evaluation.md) -- Flutter selection rationale
- [State Management Evaluation](state-management-evaluation.md) -- Riverpod selection rationale
- [Project Status](../PROJECT_STATUS.md) -- Release roadmap and sprint summary
- [Sprint 002 Tasking](../SPRINTS/sprint-002-architecture.md) -- Current sprint definition
- [Lessons Learnt](../LESSONS_LEARNED.md) -- Project knowledge base

### Sprint 001 PoC Findings

- `LongPressDraggable<String>` + `DragTarget<String>` validated for drag-and-drop (avoids scroll conflicts)
- `LayoutBuilder` with 600dp breakpoint validated for responsive layout switching
- `DraggableScrollableSheet` with snap sizes (12%, 40%, 65%) validated for portrait history pane
- PoC source retained in `lib/poc/` for reference

### External References

- [Flutter Documentation](https://flutter.dev/docs)
- [Effective Dart](https://dart.dev/effective-dart)
- [Riverpod Documentation](https://riverpod.dev/)
- [flutter_riverpod package](https://pub.dev/packages/flutter_riverpod)
- [Material Design 3](https://m3.material.io/)
- [WCAG 2.1 AA Guidelines](https://www.w3.org/WAI/WCAG21/quickref/?levels=aaa)

---

_Last updated: 2026-02-11_
