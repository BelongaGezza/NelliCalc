# Accessibility Design Specification

**Purpose:** Define accessibility requirements, screen reader strategy, and inclusive design specifications for NelliCalc, ensuring WCAG AA compliance across all interactive elements and orientations.

**Status:** Complete
**Author:** UI Designer
**Sprint:** sprint-002-architecture (Task 2.3)
**Date:** 2026-02-11

---

## Table of Contents

1. [Overview](#1-overview)
2. [Touch Targets](#2-touch-targets)
3. [Colour Contrast](#3-colour-contrast)
4. [Screen Reader Strategy](#4-screen-reader-strategy)
5. [Semantic Labels](#5-semantic-labels)
6. [Font Scaling](#6-font-scaling)
7. [Keyboard Navigation](#7-keyboard-navigation)
8. [Motion and Animation](#8-motion-and-animation)
9. [Testing Plan](#9-testing-plan)
10. [References](#10-references)

---

## 1. Overview

Accessibility in NelliCalc is a first-class requirement, not a retrofitted feature. The architecture document establishes "Accessibility built-in" as a core design principle (Principle 5). This specification defines the concrete requirements that all widgets must satisfy.

### Compliance Target

**WCAG 2.1 Level AA** -- this is the minimum standard. Where practical, we aim for Level AAA, but AA is the hard requirement.

### Guiding Principles

1. **Every interactive element must be operable** by touch, keyboard, and assistive technology.
2. **Every piece of information must be perceivable** regardless of the user's visual, auditory, or motor capabilities.
3. **The drag-and-drop feature must have an accessible alternative** that provides equivalent functionality without requiring fine motor control.
4. **No information is conveyed by colour alone** -- all colour-coded elements have a secondary indicator (text, shape, or icon).

---

## 2. Touch Targets

### Minimum Sizes

All interactive elements must meet or exceed the minimum touch target size.

| Requirement | Size | Source |
|-------------|------|--------|
| **Minimum touch target** | 48x48dp | WCAG 2.1 SC 2.5.5 / Material Design 3 |
| **Recommended touch target** | 48x48dp with 8dp spacing | MD3 accessibility guidelines |

### Actual Sizes from Wireframes

All interactive elements in NelliCalc meet the 48x48dp minimum.

| Element | Portrait Size | Landscape Size | Meets 48dp? |
|---------|--------------|----------------|-------------|
| Calculator buttons (digit) | ~84x80dp | ~116x48dp | Yes |
| Calculator buttons (operator) | ~84x80dp | ~116x48dp | Yes |
| Calculator buttons (utility) | ~84x80dp | ~116x48dp | Yes |
| Equals button | ~84x80dp | ~116x48dp | Yes |
| History item (drag handle) | 24dp wide + 12dp padding each side = 48dp | Same | Yes |
| History item (full card) | Full width x ~64dp | Full width x ~64dp | Yes |
| History sheet drag bar | 32dp wide, but tap area is full width x ~48dp | N/A (landscape uses panel) | Yes |

### Spacing Requirements

| Requirement | Value | Rationale |
|-------------|-------|-----------|
| Minimum gap between buttons | 6dp (landscape), 8dp (portrait) | Prevents accidental adjacent taps |
| Minimum padding around interactive areas | 4dp | Ensures touch targets do not overlap |
| History item vertical spacing | 8dp | Separates draggable items to prevent mis-taps |

### Implementation Notes

- Each calculator button uses `SizedBox.expand` within an `Expanded` widget, ensuring the touch target fills the entire grid cell, not just the visible button shape.
- The `InkWell` or `GestureDetector` within each button must have `MaterialTapTargetSize.padded` (the Flutter default) to ensure the hit-test area meets 48dp even if the visual element is smaller.
- The history sheet's drag handle bar (32x4dp visual) has a tap target area that spans the full sheet width and at least 48dp in height, achieved by wrapping in a `GestureDetector` with appropriate padding.

---

## 3. Colour Contrast

### WCAG AA Contrast Requirements

| Text Type | Minimum Contrast Ratio | Definition |
|-----------|----------------------|------------|
| Normal text (< 18pt / < 14pt bold) | **4.5:1** | Body text, labels, small captions |
| Large text (>= 18pt / >= 14pt bold) | **3:1** | Headings, display text, large button labels |
| UI components and graphical objects | **3:1** | Borders, icons, focus indicators |

### Contrast Requirements by UI Element

| Element | Text Style | Background | Minimum Ratio | Notes |
|---------|-----------|------------|---------------|-------|
| Expression line | `titleMedium` (~16sp) | `surface` | 4.5:1 | `onSurfaceVariant` on `surface` |
| Result line | `displaySmall` (~36sp) | `surface` | 3:1 | Large text; `onSurface` on `surface` |
| Error text | `titleMedium` | `surface` | 4.5:1 | `error` on `surface` |
| Digit button label | ~20sp bold (large text) | `surfaceContainerHighest` | 3:1 | `onSurface` on `surfaceContainerHighest` |
| Operator button label | ~20sp bold (large text) | `secondaryContainer` | 3:1 | `onSecondaryContainer` on `secondaryContainer` |
| Utility button label | ~20sp bold (large text) | `tertiaryContainer` | 3:1 | `onTertiaryContainer` on `tertiaryContainer` |
| Equals button label | ~20sp bold (large text) | `primary` | 3:1 | `onPrimary` on `primary` |
| History item result | `titleLarge` (~22sp) | `surfaceContainerLow` | 3:1 | Large text; `onSurface` on `surfaceContainerLow` |
| History item expression | `bodySmall` (~12sp) | `surfaceContainerLow` | 4.5:1 | Normal text; `onSurfaceVariant` on `surfaceContainerLow` |
| History item timestamp | `bodySmall` (~12sp) | `surfaceContainerLow` | 4.5:1 | Normal text; `onSurfaceVariant` on `surfaceContainerLow` |
| Drop hint text | `bodySmall` | `surface` | 4.5:1 | `primary` at 60% opacity -- **verify this meets 4.5:1** |
| Empty state text | `bodyMedium` (~14sp) | `surfaceContainerLow` | 4.5:1 | `onSurfaceVariant` on `surfaceContainerLow` |

### How MD3 `ColorScheme.fromSeed()` Helps

Material Design 3's `ColorScheme.fromSeed()` generates a complete colour scheme from a single seed colour using the HCT (Hue, Chroma, Tone) colour space. The generated scheme has important accessibility properties:

1. **`on*` colours are designed to contrast with their paired surface.** For example, `onPrimary` is guaranteed by the algorithm to contrast sufficiently against `primary`. The same applies for `onSecondary`/`secondary`, `onTertiary`/`tertiary`, etc.
2. **Surface container hierarchy** (`surface`, `surfaceContainerLowest`, `surfaceContainerLow`, `surfaceContainer`, `surfaceContainerHigh`, `surfaceContainerHighest`) provides tonal variation while maintaining contrast with `onSurface` and `onSurfaceVariant`.
3. **Light and dark themes** are both generated and both maintain contrast ratios.

**Caveat:** While `fromSeed()` generally produces accessible schemes, the drop hint text uses `primary` at 60% opacity, which reduces the effective contrast. This must be verified against the chosen seed colour and adjusted if it falls below 4.5:1.

### Verification Requirements

- After selecting the seed colour (Sprint 007 -- theming), verify all element contrast ratios using a tool such as the [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/).
- If any element fails its required ratio, override the specific colour token in the theme rather than changing the seed colour.
- Document the verified ratios in the theming specification.

### Colour Independence

No information in NelliCalc is conveyed solely through colour. Every colour-coded element has a secondary indicator:

| Colour Coding | Secondary Indicator |
|---------------|-------------------|
| Button categories (digit, operator, utility, action) | Spatial grouping (rightmost column = operators, top row = utility) |
| Error state (red text) | Error message text content; the word "Cannot" or "Invalid" conveys the error |
| Drop target hover (blue border) | Dashed/solid border change + drop hint text appearing |
| Drag handle icon | The `⠿` (drag indicator) icon shape, not just its colour |

---

## 4. Screen Reader Strategy

### 4.1 The Drag-and-Drop Accessibility Problem

NelliCalc's signature feature -- dragging a previous result into the current expression -- uses `LongPressDraggable`. This interaction is **not accessible** via screen readers (VoiceOver on iOS, TalkBack on Android):

- Screen readers intercept long-press gestures for their own functions.
- Drag-and-drop requires precise spatial targeting that is not available to screen reader users.
- The `Overlay` feedback widget used during dragging is not announced by screen readers.

**This is a known limitation of the gesture, not a defect.** The solution is to provide an equivalent alternative interaction.

### 4.2 Alternative Interaction: Tap-to-Insert

When a screen reader is active, history items offer an alternative insertion method via a modal bottom sheet or action menu.

#### Interaction Flow

```
Screen reader user focuses on a history item
    │
    │  VoiceOver/TalkBack announces:
    │  "42, from 6 times 7, 2 minutes ago. Double-tap to insert into expression.
    │   Actions available."
    │
    ▼
User double-taps the history item
    │
    ▼
Modal bottom sheet appears with actions:
    ┌──────────────────────────┐
    │  42                      │  Result value
    │  from 6 × 7             │  Source expression
    │                          │
    │  ┌────────────────────┐  │
    │  │ Insert into         │  │  Primary action
    │  │ expression           │  │
    │  └────────────────────┘  │
    │  ┌────────────────────┐  │
    │  │ Copy to clipboard   │  │  Secondary action
    │  └────────────────────┘  │
    │  ┌────────────────────┐  │
    │  │ Cancel              │  │  Dismiss
    │  └────────────────────┘  │
    └──────────────────────────┘
    │
    ▼
User selects "Insert into expression"
    │
    ▼
Value is appended to the current expression
(same as a successful drag-and-drop)
    │
    ▼
Screen reader announces: "42 inserted into expression"
```

#### Detection of Screen Reader

Use `MediaQuery.of(context).accessibleNavigation` to detect when a screen reader is active. When `true`:

- `LongPressDraggable` is replaced with a standard `GestureDetector` (tap handler) on history items.
- The tap handler opens the action sheet described above.
- The `DragTarget` on the calculator display is still present but also accepts input via the notifier's `insertValue()` method.

#### Implementation Guidance

```
HistoryItem widget:
├── if (MediaQuery.accessibleNavigation)
│   └── GestureDetector(onTap: _showInsertActionSheet)
│       └── Semantics(
│             label: "$result, from $expression, $relativeTime ago",
│             hint: "Double-tap to insert into expression",
│             child: _itemContent,
│           )
└── else
    └── LongPressDraggable<String>(
          data: displayValue,
          feedback: _dragFeedback,
          child: Semantics(
            label: "$result, from $expression, $relativeTime ago",
            hint: "Long press and drag to insert into expression",
            child: _itemContent,
          ),
        )
```

### 4.3 Live Regions for Calculator Display

The calculator display must announce changes to screen reader users without requiring focus to move to the display.

#### What is a Live Region?

A live region is a UI area that automatically announces its content changes to screen readers, even when the user's focus is elsewhere (e.g. on the button grid).

#### Live Region Configuration

| Display Element | Live Region? | Announcement Trigger | Announcement Content |
|----------------|-------------|---------------------|---------------------|
| Expression line | No | N/A | Not announced automatically (expression builds incrementally -- announcing every character would be noisy) |
| Result line | **Yes** | On evaluation (equals pressed) | "Result: 15.14" |
| Error text | **Yes** | On evaluation error | "Error: Cannot divide by zero" |
| Drop confirmation | **Yes** | On value inserted | "42 inserted into expression" |

#### Implementation

Wrap the result line in a `Semantics` widget with `liveRegion: true`:

```
Semantics(
  liveRegion: true,
  label: state.hasError
      ? "Error: ${state.error!.message}"
      : state.hasResult
          ? "Result: ${state.display}"
          : state.display,
  child: ResultText(state.display),
)
```

### 4.4 Button Announcements

Each calculator button is wrapped in a `Semantics` widget that announces the button's function when focused. The semantic label is the accessible name; the visual label (glyph) is not relied upon.

When a button is tapped:
1. Screen reader announces the button label (e.g. "Seven").
2. The button action fires (digit appended to expression).
3. No additional announcement is needed for digit/operator input -- the user knows what they tapped.

For the **Equals** button, the result is announced via the live region (Section 4.3).

For the **Clear** button, an additional announcement is provided:
- On clear: "Cleared" (announced via `SemanticsService.announce`).

For the **Backspace** button:
- On backspace: "Deleted [character]" (announced via `SemanticsService.announce`).

### 4.5 History Panel/Sheet Semantics

#### Panel Header

```
Semantics(
  header: true,
  label: "Previous Results",
  child: Text("Previous Results"),
)
```

#### History List

The history list is wrapped in a `Semantics` node that identifies it as a list:

```
Semantics(
  label: "Calculation history, ${entries.length} items",
  child: ListView.builder(...),
)
```

#### Empty State

```
Semantics(
  label: "No results yet. Tap equals to calculate.",
  child: EmptyStateWidget(),
)
```

#### History Sheet Handle (Portrait)

```
Semantics(
  label: "History panel, ${isExpanded ? 'expanded' : 'collapsed'}",
  hint: "Double-tap to ${isExpanded ? 'collapse' : 'expand'}",
  button: true,
  child: DragHandleBar(),
)
```

---

## 5. Semantic Labels

### 5.1 Calculator Buttons

Complete table of all calculator buttons and their semantic labels. These labels are what screen readers announce when the button receives focus.

| Position | Visual Label | Semantic Label | Semantic Hint | Category |
|----------|-------------|---------------|---------------|----------|
| R1C1 | `C` | "Clear" | "Double-tap to clear expression" | Utility |
| R1C2 | `( )` | "Parentheses" | "Double-tap to insert parenthesis" | Utility |
| R1C3 | `%` | "Percentage" | "Double-tap to insert percentage" | Utility |
| R1C4 | `÷` | "Divide" | "Double-tap to insert division" | Operator |
| R2C1 | `7` | "Seven" | -- | Digit |
| R2C2 | `8` | "Eight" | -- | Digit |
| R2C3 | `9` | "Nine" | -- | Digit |
| R2C4 | `×` | "Multiply" | "Double-tap to insert multiplication" | Operator |
| R3C1 | `4` | "Four" | -- | Digit |
| R3C2 | `5` | "Five" | -- | Digit |
| R3C3 | `6` | "Six" | -- | Digit |
| R3C4 | `−` | "Subtract" | "Double-tap to insert subtraction" | Operator |
| R4C1 | `1` | "One" | -- | Digit |
| R4C2 | `2` | "Two" | -- | Digit |
| R4C3 | `3` | "Three" | -- | Digit |
| R4C4 | `+` | "Add" | "Double-tap to insert addition" | Operator |
| R5C1 | `⌫` | "Backspace" | "Double-tap to delete last character" | Utility |
| R5C2 | `0` | "Zero" | -- | Digit |
| R5C3 | `.` | "Decimal point" | -- | Digit |
| R5C4 | `=` | "Equals" | "Double-tap to evaluate expression" | Action |

**Notes:**
- Digit buttons do not need a semantic hint -- the label is self-explanatory and the action (input) is obvious.
- Operator buttons include a hint to clarify what "double-tap" does, since the glyph alone may be ambiguous (e.g. `×` vs `x`).
- All buttons use `Semantics(button: true)` to indicate their role.

### 5.2 Calculator Display

| Element | Semantic Label | Semantic Properties |
|---------|---------------|-------------------|
| Expression line | "Expression: [current expression]" or "Expression: empty" | `readOnly: true` |
| Result line | "Result: [current value]" or "Error: [message]" | `liveRegion: true`, `readOnly: true` |
| Drop target area | "Drop area for previous results" | `hint: "Drag a history item here or use the insert action"` |

### 5.3 History Items

| Element | Semantic Label | Semantic Properties |
|---------|---------------|-------------------|
| History item | "[result], from [expression], [time] ago" | `hint` varies by context (see Section 4.2) |
| Drag handle | Excluded from semantics | `excludeSemantics: true` on the icon -- the entire card is the accessible target |

### 5.4 History Panel/Sheet

| Element | Semantic Label | Semantic Properties |
|---------|---------------|-------------------|
| Panel title | "Previous Results" | `header: true` |
| History list | "Calculation history, [N] items" | -- |
| Empty state | "No results yet. Tap equals to calculate." | -- |
| Sheet handle (portrait) | "History panel, [expanded/collapsed]" | `button: true`, with toggle hint |

---

## 6. Font Scaling

### 6.1 How Font Scaling Works in Flutter

Flutter respects the system-level text scale factor set by the user in their device accessibility settings. This is exposed via `MediaQuery.of(context).textScaler` (Flutter 3.16+) or `MediaQuery.of(context).textScaleFactor` (deprecated but still functional).

Common text scale factor values:

| Setting | Approximate Factor | Platform |
|---------|-------------------|----------|
| Default | 1.0 | All |
| Slightly larger | 1.15 -- 1.3 | iOS, Android |
| Large | 1.5 -- 2.0 | iOS, Android |
| Largest | 2.0 -- 3.0+ | iOS (up to 3.12), Android (up to ~2.0 typically) |

### 6.2 Behaviour at Each Scale Factor

#### Scale 1.0 (Default)

- All text renders at the designed sizes from the wireframes.
- No overflow. This is the baseline case.

#### Scale 1.0 -- 1.5 (Moderate Enlargement)

| Element | Behaviour | Overflow Risk |
|---------|-----------|---------------|
| Expression line | Text grows; right-aligned, overflows left (acceptable -- expression can be long anyway) | Low |
| Result line | Text grows; right-aligned, may overflow left | Low |
| Button labels | Text grows within button bounds | **Medium** -- landscape buttons are 48dp tall; labels may clip at 1.5x |
| History item result | Text grows; card height grows (intrinsic sizing) | Low |
| History item expression | Text grows; may wrap to second line | Low |
| History item timestamp | Text grows; may overlap expression | Medium |

**Mitigations for 1.0 -- 1.5x:**
- Button labels: Use `FittedBox` with `fit: BoxFit.scaleDown` inside buttons so text shrinks rather than overflows.
- History timestamps: Use `Flexible` or `Expanded` on the timestamp to allow truncation with an ellipsis if space is constrained.

#### Scale 1.5 -- 2.0 (Large Enlargement)

| Element | Behaviour | Mitigation |
|---------|-----------|------------|
| Button labels | `FittedBox` scales text down to fit within the button | Digits remain legible down to ~12sp effective |
| Expression line | Long expressions scroll or clip left | Add `SingleChildScrollView(scrollDirection: Axis.horizontal)` |
| Result line | May overflow left edge | Same horizontal scroll treatment |
| History cards | Height increases; fewer items visible per screen | Acceptable -- scrollable list handles this |
| Display area height | May increase beyond wireframe allocation | Display area should use intrinsic height (`MainAxisSize.min`), not a fixed height |

#### Scale > 2.0 (Very Large Enlargement)

At extreme scale factors, layout degradation is expected but must remain usable:

- **Buttons:** `FittedBox` continues to shrink labels. At 3x scale, effective label size may reach ~8sp after scaling down -- still legible for most users who have set such large text intentionally.
- **Display:** Horizontal scrolling ensures the expression and result remain accessible.
- **History:** Cards grow taller; the scrollable list accommodates this naturally.
- **No content is hidden or lost** -- all information remains accessible, even if the layout is less visually polished.

### 6.3 Capping Text Scale (Not Recommended)

Some apps use `MediaQuery` overrides to cap the text scale factor (e.g. `textScaleFactor: min(mediaQuery.textScaleFactor, 1.5)`). **NelliCalc should not do this.** Users who set large text sizes have a genuine need for it. Capping undermines their accessibility settings.

Instead, design widgets to handle large text gracefully:

| Strategy | Where |
|----------|-------|
| `FittedBox(fit: BoxFit.scaleDown)` | Button labels |
| `SingleChildScrollView(scrollDirection: Axis.horizontal)` | Expression and result lines |
| Intrinsic sizing (`MainAxisSize.min`) | Display area |
| `Flexible` with `overflow: TextOverflow.ellipsis` | History timestamps |
| `Expanded` within `Row` widgets | Prevent fixed-width overflow |

### 6.4 Minimum Readable Sizes

After `FittedBox` scaling, text should not fall below these effective sizes:

| Element | Minimum Effective Size | Rationale |
|---------|----------------------|-----------|
| Button labels | 10sp | Below this, glyphs become indistinguishable |
| Expression text | 12sp | Legibility of mathematical symbols |
| Result text | 14sp | Primary output must remain clearly readable |
| History text | 10sp | Secondary information, can be smaller |

If `FittedBox` would reduce text below these thresholds, consider alternative strategies such as abbreviation or icon-only display (for future investigation if edge cases arise in testing).

---

## 7. Keyboard Navigation

### 7.1 When Keyboard Navigation Applies

Keyboard navigation is relevant for:
- **Desktop platforms** (Linux, macOS, Windows) where users may not have a touchscreen.
- **External keyboards** connected to tablets or phones.
- **Switch access** and other assistive input devices that emulate keyboard events.

### 7.2 Tab Order

The tab order follows the visual layout, top-to-bottom, left-to-right within each section.

#### Portrait Mode Tab Order

```
1.  Expression display (read-only, focusable for selection)
2.  Result display (read-only, focusable for selection)
3.  C button
4.  ( ) button
5.  % button
6.  ÷ button
7.  7
8.  8
9.  9
10. × button
11. 4
12. 5
13. 6
14. − button
15. 1
16. 2
17. 3
18. + button
19. ⌫ button
20. 0
21. . button
22. = button
23. History sheet handle (expands/collapses)
24. History items (each individually focusable, in order)
```

#### Landscape Mode Tab Order

```
1.  Expression display
2.  Result display
3.  Calculator buttons (same order as portrait: rows 1-5, left-to-right)
4.  History panel title
5.  History items (each individually focusable)
```

### 7.3 Focus Indicators

All focusable elements must display a visible focus indicator when focused via keyboard or switch access.

| Element | Focus Indicator Style |
|---------|---------------------|
| Calculator buttons | 2dp solid `primary` border, offset 2dp from button edge |
| History items | 2dp solid `primary` border around the card |
| History sheet handle | 2dp solid `primary` border around the handle area |
| Display areas | 2dp solid `primary` border around the display section |

Flutter's default `Focus` widget provides a focus indicator via `MaterialState.focused`. Ensure custom buttons do not override this.

### 7.4 Keyboard Shortcuts (Desktop)

For desktop platforms, direct keyboard input provides a more natural interaction than tabbing through buttons:

| Key(s) | Action | Notes |
|--------|--------|-------|
| `0` -- `9` | Input digit | Direct input, no focus required on specific button |
| `+` | Add operator | |
| `-` | Subtract operator | |
| `*` | Multiply operator | |
| `/` | Divide operator | |
| `.` | Decimal point | |
| `(`, `)` | Parentheses | Direct open/close, not auto-detect |
| `Enter` or `=` | Evaluate | |
| `Backspace` or `Delete` | Backspace | |
| `Escape` or `c` | Clear | |

These shortcuts are handled by a `RawKeyboardListener` or `KeyboardListener` (Flutter 3.18+) at the `ResponsiveShell` level, dispatching to the same `CalculatorNotifier` methods used by button taps.

**Note:** Keyboard shortcut implementation is deferred to a desktop-focused sprint. The architecture accommodates it, but the initial implementation targets touch-first mobile platforms.

---

## 8. Motion and Animation

### 8.1 Animations in NelliCalc

NelliCalc uses subtle animations to provide visual feedback:

| Animation | Duration | Context |
|-----------|----------|---------|
| Button press ripple (Ink) | ~200ms | MD3 default `InkWell` ripple |
| Drop accepted scale | 100ms | Brief scale pulse on result line when a value is dropped |
| History sheet snap | ~300ms | Spring physics when sheet snaps to 12%, 40%, or 65% |
| Drag feedback follow | Frame-rate | `LongPressDraggable` overlay follows finger position |
| Layout transition | Instant | No animation on responsive layout switch (by design) |

### 8.2 Respecting Reduced Motion Preferences

Some users enable "Reduce Motion" (iOS) or "Remove animations" (Android) in their device accessibility settings. NelliCalc must respect this preference.

#### Detection

```dart
final reduceMotion = MediaQuery.of(context).disableAnimations;
```

#### Behaviour When Reduced Motion is Enabled

| Animation | Default | Reduced Motion |
|-----------|---------|---------------|
| Button press ripple | Ripple effect | Instant highlight (no spread animation) |
| Drop accepted scale | 100ms scale pulse | No animation; value appears immediately |
| History sheet snap | Spring physics (~300ms) | Instant snap (duration: Duration.zero) |
| Drag feedback follow | Overlay follows finger | Still follows finger (this is direct manipulation, not decorative animation) |

#### Implementation

Wrap animated widgets in a conditional:

```dart
final reduceMotion = MediaQuery.of(context).disableAnimations;

AnimatedContainer(
  duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 100),
  // ...
)
```

For the history sheet, pass `animationController` with zero duration when reduced motion is active.

### 8.3 No Flashing Content

NelliCalc contains no flashing, blinking, or strobing content. This satisfies WCAG SC 2.3.1 (Three Flashes or Below Threshold).

---

## 9. Testing Plan

### 9.1 Automated Testing (From Sprint 003)

| Test Type | What to Test | Tool |
|-----------|-------------|------|
| Semantic tree verification | Every interactive widget has a `Semantics` node with correct label, hint, and role | `flutter_test` `find.bySemanticsLabel()` |
| Touch target size | All buttons and interactive elements meet 48x48dp minimum | Widget test measuring `RenderBox.size` |
| Focus traversal order | Tab order matches specification (Section 7.2) | Widget test with `FocusTraversalGroup` |
| Live region announcements | Result line announces changes | `SemanticsController` in widget tests |

### 9.2 Manual Testing with Screen Readers (Sprint 008)

| Platform | Screen Reader | Test Cases |
|----------|--------------|------------|
| Android | TalkBack | Navigate all buttons by swiping; verify labels announced correctly; evaluate an expression; insert a history value via tap-to-insert action sheet |
| iOS | VoiceOver | Same as TalkBack test cases; verify rotor navigation works; test with switch control |
| Desktop (Linux) | Orca | Keyboard navigation through all elements; verify focus indicators visible |

#### Screen Reader Test Script

1. **Launch app** -- verify the initial state is announced: "NelliCalc. Expression: empty. Result: 0."
2. **Navigate to digit 7** -- swipe right through buttons; verify "Seven" is announced.
3. **Tap 7, then +, then 3** -- verify button labels are announced on tap.
4. **Tap =** -- verify "Result: 10" is announced via live region.
5. **Navigate to history** -- verify "Calculation history, 1 item" is announced.
6. **Focus on history item** -- verify "10, from 7 plus 3, just now" is announced.
7. **Double-tap history item** -- verify action sheet appears with "Insert into expression" option.
8. **Select "Insert into expression"** -- verify "10 inserted into expression" is announced.
9. **Navigate to Clear button** -- verify "Clear" is announced; double-tap.
10. **Verify** -- "Cleared" is announced.

### 9.3 Contrast Verification (Sprint 007)

After the theming sprint selects a seed colour:

1. Generate the light and dark colour schemes using `ColorScheme.fromSeed()`.
2. Extract the hex values for all colour pairs listed in Section 3.
3. Verify each pair against the required contrast ratio using the [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/).
4. Document results in the theming specification.
5. Override any failing colour tokens.

### 9.4 Font Scaling Verification (Sprint 008)

1. Set device text scale to 1.0, 1.5, 2.0, and maximum (3.12 on iOS).
2. Verify each screen at each scale:
   - No text is clipped or hidden.
   - All buttons remain tappable (48dp minimum).
   - Expression and result are readable (horizontal scroll if needed).
   - History items are readable and tappable.
3. Verify `FittedBox` does not shrink button labels below 10sp effective.

### 9.5 Accessibility Checklist (Per Widget)

Every new widget must satisfy this checklist before being marked complete:

- [ ] All interactive elements have `Semantics` labels.
- [ ] Interactive elements are marked with appropriate role (`button: true`, `header: true`, etc.).
- [ ] Touch targets are >= 48x48dp.
- [ ] Text colours meet WCAG AA contrast against their background.
- [ ] Widget handles `textScaleFactor` up to 2.0 without clipping.
- [ ] Focus indicator is visible for keyboard/switch access users.
- [ ] Animations respect `MediaQuery.disableAnimations`.
- [ ] No information is conveyed by colour alone.

---

## 10. References

### Project Documents

- [Calculator Layout Wireframes](calculator-layout.md) -- Button sizes, display layout, history panel design
- [Architecture](../../RESEARCH/architecture.md) -- Widget tree, provider graph, accessibility as design principle
- [Lessons Learnt](../../LESSONS_LEARNED.md) -- Project knowledge base

### External References

- [WCAG 2.1 Quick Reference (Level AA)](https://www.w3.org/WAI/WCAG21/quickref/?levels=aaa)
- [WCAG 2.1 SC 2.5.5: Target Size](https://www.w3.org/WAI/WCAG21/Understanding/target-size.html)
- [WCAG 2.1 SC 1.4.3: Contrast (Minimum)](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
- [Material Design 3 -- Accessibility](https://m3.material.io/foundations/accessible-design/overview)
- [Flutter Accessibility Documentation](https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility)
- [Flutter Semantics Class](https://api.flutter.dev/flutter/widgets/Semantics-class.html)
- [Flutter SemanticsService](https://api.flutter.dev/flutter/semantics/SemanticsService-class.html)
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

---

_Last updated: 2026-02-11_
