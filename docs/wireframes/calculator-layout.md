# Calculator Layout Wireframes

**Purpose:** Define the spatial layout of the calculator screen in both portrait and landscape orientations, including button grid arrangement, display area design, and history panel positioning.

**Status:** Complete
**Author:** UI Designer
**Sprint:** sprint-002-architecture (Task 2.1)
**Date:** 2026-02-11

---

## Table of Contents

1. [Design Constraints](#1-design-constraints)
2. [Portrait Mode Wireframe](#2-portrait-mode-wireframe)
3. [Landscape Mode Wireframe](#3-landscape-mode-wireframe)
4. [Display Area Design](#4-display-area-design)
5. [Button Grid Layout](#5-button-grid-layout)
6. [History Panel (Landscape)](#6-history-panel-landscape)
7. [History Sheet (Portrait)](#7-history-sheet-portrait)
8. [Responsive Breakpoint Behaviour](#8-responsive-breakpoint-behaviour)
9. [Spacing and Dimensions Summary](#9-spacing-and-dimensions-summary)
10. [References](#10-references)

---

## 1. Design Constraints

These constraints are derived from the architecture document, Sprint 001 PoC findings, and Material Design 3 guidelines.

| Constraint | Value | Source |
|------------|-------|--------|
| Minimum touch target | 48x48dp | WCAG AA / MD3 |
| Responsive breakpoint | 600dp width | Architecture doc |
| Wide layout ratio | Calculator flex:3, History flex:2 | Architecture doc |
| History sheet snap sizes | 12%, 40%, 65% | Sprint 001 PoC |
| Drag widget | `LongPressDraggable` | Sprint 001 PoC |
| Primary platform | Handheld touchscreen phones | Project brief |
| Text alignment (display) | Right-aligned | Calculator convention |
| Button grid columns | 4 | Standard calculator layout |

### Target Screen Sizes

| Device Class | Width (dp) | Height (dp) | Orientation |
|-------------|------------|-------------|-------------|
| Small phone | 360 | 640 | Portrait |
| Medium phone | 390 | 844 | Portrait |
| Large phone | 428 | 926 | Portrait |
| Phone landscape | 640-926 | 360-428 | Landscape |
| Tablet | 600-840 | 900-1200 | Either |

---

## 2. Portrait Mode Wireframe

Portrait mode uses a `Stack` layout. The calculator fills the screen with the `DraggableScrollableSheet` overlaying from the bottom.

### Full Screen (History Sheet Collapsed -- 12% Snap)

Reference device: 390dp wide x 844dp tall (medium phone).

```
┌──────────────────────────────────────┐
│              STATUS BAR              │  ~24dp
├──────────────────────────────────────┤
│                                      │
│  CALCULATOR DISPLAY                  │
│  ┌──────────────────────────────────┐│
│  │                                  ││
│  │              12 + 3.14  ←expr    ││  Expression line
│  │                                  ││
│  │                  15.14  ←result  ││  Result line (large)
│  │                                  ││
│  │  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  ││
│  │  │  Drop results here  ↓    │  ││  Drop target hint
│  │  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  ││  (shown during drag)
│  └──────────────────────────────────┘│
│                                      │
│  BUTTON GRID                         │
│  ┌──────────────────────────────────┐│
│  │  ┌────┐ ┌────┐ ┌────┐ ┌────┐   ││
│  │  │ C  │ │ ( )│ │  % │ │  ÷ │   ││  Row 1: Utility + ÷
│  │  └────┘ └────┘ └────┘ └────┘   ││
│  │  ┌────┐ ┌────┐ ┌────┐ ┌────┐   ││
│  │  │ 7  │ │ 8  │ │ 9  │ │  × │   ││  Row 2: 7 8 9 ×
│  │  └────┘ └────┘ └────┘ └────┘   ││
│  │  ┌────┐ ┌────┐ ┌────┐ ┌────┐   ││
│  │  │ 4  │ │ 5  │ │ 6  │ │  − │   ││  Row 3: 4 5 6 −
│  │  └────┘ └────┘ └────┘ └────┘   ││
│  │  ┌────┐ ┌────┐ ┌────┐ ┌────┐   ││
│  │  │ 1  │ │ 2  │ │ 3  │ │  + │   ││  Row 4: 1 2 3 +
│  │  └────┘ └────┘ └────┘ └────┘   ││
│  │  ┌────┐ ┌────┐ ┌────┐ ┌────┐   ││
│  │  │ ⌫ │ │ 0  │ │  . │ │  = │   ││  Row 5: ⌫ 0 . =
│  │  └────┘ └────┘ └────┘ └────┘   ││
│  └──────────────────────────────────┘│
│                                      │
├──────────────────────────────────────┤  ← History sheet
│  ════════════════════════════════════│    collapsed (12%)
│           ━━━━━━━━━━━━              │    Drag handle bar
│       Previous Results              │    Label
└──────────────────────────────────────┘
```

### Vertical Space Distribution (Portrait, 844dp)

| Region | Allocation | Notes |
|--------|-----------|-------|
| Status bar | ~24dp | System |
| Display area | ~160dp | Expression + result + padding |
| Button grid | ~460dp | 5 rows of buttons + spacing |
| Bottom spacing | ~100dp | Consumed by history sheet (12% snap) |
| History sheet (collapsed) | ~100dp | 12% of screen height |

### Layout Algorithm

The calculator content (display + button grid) lives inside a `Column` that occupies the full screen. The `DraggableScrollableSheet` overlays from the bottom as part of a `Stack`. The button grid uses `Expanded` to fill available vertical space, ensuring buttons scale proportionally.

```
Stack
├── Column
│   ├── CalculatorDisplay (fixed height or intrinsic)
│   └── Expanded
│       └── ButtonGrid (fills remaining space)
└── DraggableScrollableSheet
    └── HistorySheet
```

---

## 3. Landscape Mode Wireframe

Landscape mode (width >= 600dp) uses a `Row` layout with the calculator on the left (flex: 3) and history panel on the right (flex: 2).

Reference: phone rotated to ~844dp wide x 390dp tall.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              STATUS BAR                                     │
├────────────────────────────────────────────┬──┬─────────────────────────────┤
│                                            │  │                             │
│  CALCULATOR DISPLAY                        │  │  HISTORY PANEL              │
│  ┌────────────────────────────────────┐    │  │  ┌─────────────────────┐    │
│  │                                    │    │  │  │ Previous Results    │    │
│  │                    12 + 3.14       │    │V │  ├─────────────────────┤    │
│  │                                    │    │e │  │ ⠿ 42               │    │
│  │                        15.14       │    │r │  │   6 × 7             │    │
│  │                                    │    │t │  ├─────────────────────┤    │
│  └────────────────────────────────────┘    │i │  │ ⠿ 15.14            │    │
│                                            │c │  │   12 + 3.14         │    │
│  BUTTON GRID                               │a │  ├─────────────────────┤    │
│  ┌────────────────────────────────────┐    │l │  │ ⠿ 7                │    │
│  │ ┌────┐ ┌────┐ ┌────┐ ┌────┐      │    │D │  │   3 + 4             │    │
│  │ │ C  │ │ ( )│ │  % │ │  ÷ │      │    │i │  ├─────────────────────┤    │
│  │ └────┘ └────┘ └────┘ └────┘      │    │v │  │ ⠿ 100              │    │
│  │ ┌────┐ ┌────┐ ┌────┐ ┌────┐      │    │i │  │   10 × 10           │    │
│  │ │ 7  │ │ 8  │ │ 9  │ │  × │      │    │d │  ├─────────────────────┤    │
│  │ └────┘ └────┘ └────┘ └────┘      │    │e │  │                     │    │
│  │ ┌────┐ ┌────┐ ┌────┐ ┌────┐      │    │r │  │     (scrollable)    │    │
│  │ │ 4  │ │ 5  │ │ 6  │ │  − │      │    │  │  │                     │    │
│  │ └────┘ └────┘ └────┘ └────┘      │    │  │  └─────────────────────┘    │
│  │ ┌────┐ ┌────┐ ┌────┐ ┌────┐      │    │  │                             │
│  │ │ 1  │ │ 2  │ │ 3  │ │  + │      │    │  │                             │
│  │ └────┘ └────┘ └────┘ └────┘      │    │  │                             │
│  │ ┌────┐ ┌────┐ ┌────┐ ┌────┐      │    │  │                             │
│  │ │ ⌫ │ │ 0  │ │  . │ │  = │      │    │  │                             │
│  │ └────┘ └────┘ └────┘ └────┘      │    │  │                             │
│  └────────────────────────────────────┘    │  │                             │
│                flex: 3                     │  │         flex: 2             │
└────────────────────────────────────────────┴──┴─────────────────────────────┘
```

### Landscape Layout Structure

```
Row
├── Expanded(flex: 3)
│   └── Column
│       ├── CalculatorDisplay
│       └── Expanded
│           └── ButtonGrid
├── VerticalDivider
└── Expanded(flex: 2)
    └── HistoryPanel
```

### Landscape Space Considerations

In landscape mode, vertical space is limited (~390dp after status bar). The display area should be compact (~80-100dp) to leave adequate room for the button grid. Button height will be smaller than portrait, but must remain >= 48dp.

| Region | Portrait (844dp) | Landscape (~366dp usable) |
|--------|-----------------|--------------------------|
| Display | ~160dp | ~80dp |
| Button grid | ~460dp (5 rows) | ~280dp (5 rows) |
| Spacing | ~100dp | ~6dp |
| Button height | ~80dp per row | ~48dp per row |

---

## 4. Display Area Design

The calculator display serves a dual purpose: showing the current expression/result and acting as a `DragTarget` for history items.

### Display Layout

```
┌──────────────────────────────────────────────────┐
│                                                  │
│  16dp padding                                    │
│                                                  │
│                               12 + 3.14   ←───  │  Expression line
│                                                  │  (Body Large, muted)
│                                   15.14   ←───  │  Result line
│                                                  │  (Display Medium, primary)
│                                                  │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  │
│  │     Drop a previous result here   ↓      │  │  Drop hint (hidden by
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │  default; shown during
│                                                  │  active drag only)
│  16dp padding                                    │
│                                                  │
└──────────────────────────────────────────────────┘
```

### Display States

| State | Expression Line | Result Line | Drop Hint |
|-------|----------------|-------------|-----------|
| **Empty** | (empty) | `0` | Hidden |
| **Inputting** | `12 +` | `12` | Hidden |
| **Evaluated** | `12 + 3.14` | `= 15.14` | Hidden |
| **Error** | `12 ÷ 0` | `Cannot divide by zero` (error colour) | Hidden |
| **Drag hovering** | (current) | (current) | Shown with highlight border |
| **Value dropped** | `12 + 42` (value appended) | (recalculates) | Fades out |

### Text Styles

| Element | MD3 Typography | Alignment | Colour |
|---------|---------------|-----------|--------|
| Expression line | `titleMedium` | Right | `onSurfaceVariant` (muted) |
| Result line | `displaySmall` | Right | `onSurface` (primary text) |
| Error text | `titleMedium` | Right | `error` |
| Drop hint | `bodySmall` | Centre | `primary` with 60% opacity |

### Drop Target Visual Feedback

When a `LongPressDraggable` item is being dragged anywhere on screen:

1. **Idle (no drag active):** No special decoration -- standard display appearance.
2. **Drag active, not hovering:** A subtle dashed border appears around the display area (2dp, `primary` colour at 30% opacity) to indicate it is a valid target.
3. **Drag hovering over display:** Border becomes solid (2dp, `primary` colour), background shifts to `primaryContainer` at 12% opacity. The drop hint text becomes visible.
4. **Drop accepted:** Brief scale animation (100ms) on the result line as the value is inserted. Border returns to idle state.

Implementation note: Use `DragTarget.onWillAcceptWithDetails` for hover state and `onAcceptWithDetails` for the drop action. The `AnimatedContainer` from the Sprint 001 PoC approach is suitable here.

---

## 5. Button Grid Layout

### Grid Arrangement

4 columns, 5 rows. Operators in the rightmost column. Utility buttons (clear, parentheses) in the top row. Most-used buttons (digits, equals) in the bottom rows for thumb reachability.

```
┌─────────┬─────────┬─────────┬─────────┐
│         │         │         │         │
│    C    │   ( )   │    %    │    ÷    │  Row 1: Utility
│         │         │         │         │
├─────────┼─────────┼─────────┼─────────┤
│         │         │         │         │
│    7    │    8    │    9    │    ×    │  Row 2: Digits 7-9
│         │         │         │         │
├─────────┼─────────┼─────────┼─────────┤
│         │         │         │         │
│    4    │    5    │    6    │    −    │  Row 3: Digits 4-6
│         │         │         │         │
├─────────┼─────────┼─────────┼─────────┤
│         │         │         │         │
│    1    │    2    │    3    │    +    │  Row 4: Digits 1-3
│         │         │         │         │
├─────────┼─────────┼─────────┼─────────┤
│         │         │         │         │
│    ⌫    │    0    │    .    │    =    │  Row 5: Zero row
│         │         │         │         │
└─────────┴─────────┴─────────┴─────────┘
```

### Button Inventory

| Position | Label | Action | Semantic Label | Category |
|----------|-------|--------|---------------|----------|
| R1C1 | `C` | Clear all (expression + result) | "Clear" | Utility |
| R1C2 | `( )` | Toggle parenthesis (auto-detect open/close) | "Parentheses" | Utility |
| R1C3 | `%` | Reserved for future use (percentage) | "Percentage" | Utility |
| R1C4 | `÷` | Division operator | "Divide" | Operator |
| R2C1 | `7` | Input digit 7 | "Seven" | Digit |
| R2C2 | `8` | Input digit 8 | "Eight" | Digit |
| R2C3 | `9` | Input digit 9 | "Nine" | Digit |
| R2C4 | `×` | Multiplication operator | "Multiply" | Operator |
| R3C1 | `4` | Input digit 4 | "Four" | Digit |
| R3C2 | `5` | Input digit 5 | "Five" | Digit |
| R3C3 | `6` | Input digit 6 | "Six" | Digit |
| R3C4 | `−` | Subtraction operator | "Subtract" | Operator |
| R4C1 | `1` | Input digit 1 | "One" | Digit |
| R4C2 | `2` | Input digit 2 | "Two" | Digit |
| R4C3 | `3` | Input digit 3 | "Three" | Digit |
| R4C4 | `+` | Addition operator | "Add" | Operator |
| R5C1 | `⌫` | Backspace (delete last character) | "Backspace" | Utility |
| R5C2 | `0` | Input digit 0 | "Zero" | Digit |
| R5C3 | `.` | Decimal point | "Decimal point" | Digit |
| R5C4 | `=` | Evaluate expression | "Equals" | Action |

### Parenthesis Button Behaviour

The `( )` button uses auto-detection to insert the appropriate parenthesis:

- Insert `(` when: expression is empty, after an operator, or after an opening `(`
- Insert `)` when: there are unmatched opening parentheses and the last character is a digit or `)`

### Button Styling

Buttons are visually grouped by category using colour from the MD3 colour scheme.

| Category | Background | Text | Example |
|----------|-----------|------|---------|
| Digit | `surfaceContainerHighest` | `onSurface` | `0`-`9`, `.` |
| Operator | `secondaryContainer` | `onSecondaryContainer` | `+` `−` `×` `÷` |
| Utility | `tertiaryContainer` | `onTertiaryContainer` | `C`, `( )`, `%`, `⌫` |
| Action (Equals) | `primary` | `onPrimary` | `=` |

### Button Sizing

Buttons are laid out using a `GridView` (or equivalent) with equal-width columns and equal-height rows. The grid fills all available space below the display, so button sizes are dynamic and scale with screen size.

| Measurement | Portrait (390dp wide) | Landscape (~500dp wide) |
|------------|----------------------|------------------------|
| Grid padding (horizontal) | 12dp | 8dp |
| Grid padding (vertical) | 8dp | 4dp |
| Button spacing | 8dp | 6dp |
| Button width | ~84dp per button | ~116dp per button |
| Button height | ~80dp per row | ~48dp per row (minimum) |
| Button corner radius | 16dp | 12dp |

All buttons exceed the 48x48dp minimum touch target requirement.

### Flutter Implementation Guidance

The `ButtonGrid` widget should use a `GridView.count` or a `Column` of `Row` widgets with `Expanded` children. Using `Expanded` within rows ensures buttons stretch to fill available width, while the outer `Expanded` on the grid itself ensures it fills the vertical space below the display.

```
Column
├── CalculatorDisplay (intrinsic height)
└── Expanded
    └── Padding(12dp horizontal, 8dp vertical)
        └── Column (mainAxisAlignment: spaceEvenly)
            ├── Expanded → Row [C] [( )] [%] [÷]
            ├── Expanded → Row [7] [8] [9] [×]
            ├── Expanded → Row [4] [5] [6] [−]
            ├── Expanded → Row [1] [2] [3] [+]
            └── Expanded → Row [⌫] [0] [.] [=]
```

Each button uses `SizedBox.expand` within an `Expanded` widget so it fills the available cell, with internal `InkWell` for touch feedback and `Semantics` for accessibility.

---

## 6. History Panel (Landscape)

The history panel appears on the right side of the screen in wide layouts (>= 600dp). It is a scrollable list of previous calculation results, each of which is a `LongPressDraggable`.

### Panel Layout

```
┌─────────────────────────────┐
│  Previous Results           │  Title (titleMedium)
│                             │
├─────────────────────────────┤
│  ┌─────────────────────┐    │
│  │ ⠿  42               │    │  History item
│  │    6 × 7             │    │  Result (titleLarge, bold)
│  │                      │    │  Expression (bodySmall, muted)
│  └─────────────────────┘    │
│  8dp spacing                │
│  ┌─────────────────────┐    │
│  │ ⠿  15.14            │    │
│  │    12 + 3.14         │    │
│  └─────────────────────┘    │
│  8dp spacing                │
│  ┌─────────────────────┐    │
│  │ ⠿  7                │    │
│  │    3 + 4             │    │
│  └─────────────────────┘    │
│                             │
│       (scrollable)          │
│                             │
└─────────────────────────────┘
```

### History Item Design

Each history item is a card-like element displaying the result value and the original expression.

```
┌──────────────────────────────────────┐
│  ⠿   42                              │  Drag handle + Result
│       6 × 7                    2m ago │  Expression + relative time
└──────────────────────────────────────┘
```

| Element | Typography | Colour | Notes |
|---------|-----------|--------|-------|
| Drag handle (`⠿`) | Icon, 18dp | `onSurfaceVariant` | Braille pattern dots icon or `Icons.drag_indicator` |
| Result value | `titleLarge` | `onSurface` | Bold weight |
| Expression | `bodySmall` | `onSurfaceVariant` | Muted |
| Relative time | `bodySmall` | `onSurfaceVariant` | Right-aligned; e.g. "2m ago", "1h ago" |

### History Item Dimensions

| Measurement | Value |
|-------------|-------|
| Item height | ~64dp (minimum, grows with content) |
| Item padding | 12dp horizontal, 8dp vertical |
| Drag handle area | 24dp wide (exceeds 48dp touch target with padding) |
| Corner radius | 12dp |
| Background | `surfaceContainerLow` |
| Elevation | 0dp (flat), 2dp on hover |
| Between items | 8dp vertical spacing |

### Empty State

When there are no history entries:

```
┌─────────────────────────────┐
│  Previous Results           │
│                             │
│                             │
│      No results yet.        │
│      Tap = to calculate.    │
│                             │
│                             │
└─────────────────────────────┘
```

Text centred, using `bodyMedium` in `onSurfaceVariant`.

### Scroll Behaviour

- `ListView.builder` for efficient rendering of potentially many items
- Items ordered newest-first (most recent at top)
- No pagination -- all items loaded (history is modest in size)
- Standard overscroll glow effect (Material)

---

## 7. History Sheet (Portrait)

In portrait mode (width < 600dp), the history is accessible via a `DraggableScrollableSheet` that overlays the bottom of the screen.

### Sheet Snap Sizes

As validated in the Sprint 001 PoC:

| Snap | Height % | Purpose | Visual |
|------|---------|---------|--------|
| 12% | ~100dp | Handle only -- shows drag bar and label | Peek state |
| 40% | ~340dp | A few history items visible | Browse state |
| 65% | ~550dp | Most items visible, calculator still partially visible | Expanded state |

### Collapsed State (12% -- Default)

```
┌──────────────────────────────────────┐
│                                      │
│  ════════════════════════════════════ │  Rounded top corners (16dp)
│              ━━━━━━━━━━              │  Drag handle bar (32dp wide, 4dp tall)
│                                      │
│         Previous Results             │  Label (bodyMedium)
│                                      │
└──────────────────────────────────────┘
```

### Partially Expanded State (40%)

```
┌──────────────────────────────────────┐
│  ════════════════════════════════════ │
│              ━━━━━━━━━━              │  Drag handle
│         Previous Results             │
│                                      │
│  ┌──────────────────────────────────┐│
│  │ ⠿  42                            ││  History item 1
│  │    6 × 7                   2m ago││
│  └──────────────────────────────────┘│
│  ┌──────────────────────────────────┐│
│  │ ⠿  15.14                         ││  History item 2
│  │    12 + 3.14               5m ago││
│  └──────────────────────────────────┘│
│  ┌──────────────────────────────────┐│
│  │ ⠿  7                             ││  History item 3
│  │    3 + 4                  12m ago││
│  └──────────────────────────────────┘│
│                                      │
│            (scrollable)              │
│                                      │
└──────────────────────────────────────┘
```

### Sheet Visual Design

| Element | Value |
|---------|-------|
| Top corners | 16dp radius (rounded) |
| Background | `surfaceContainerLow` |
| Drag handle bar | 32dp wide, 4dp tall, centred, `onSurfaceVariant` at 40% |
| Handle bar top padding | 8dp |
| Title padding | 12dp below handle bar |
| Content padding | 12dp horizontal |
| Shadow/elevation | 4dp (subtle shadow above sheet) |

### Sheet Interaction

- **Swipe up** from collapsed state to expand
- **Swipe down** from expanded state to collapse
- **Tap the handle area** to toggle between 12% and 40% snap
- **Long-press a history item** to initiate drag; the sheet remains visible during the drag
- Items are scrollable within the sheet at any snap size

### Cross-Boundary Drag (Portrait)

When a user long-presses a history item in the sheet and drags upward toward the calculator display:

1. The `LongPressDraggable` feedback widget follows the finger
2. The sheet remains at its current snap position (does not collapse)
3. As the finger enters the `CalculatorDisplay` `DragTarget` area, the display shows the hover state
4. On drop, the value is inserted into the expression

This works because `LongPressDraggable` creates an overlay that floats above the `Stack`, crossing the boundary between the sheet and the calculator beneath it.

---

## 8. Responsive Breakpoint Behaviour

### Transition at 600dp

The `ResponsiveShell` widget uses `LayoutBuilder` to measure available width. The layout switches at 600dp.

```
Width < 600dp:                       Width >= 600dp:

┌──────────────┐                     ┌──────────────┬──┬────────┐
│              │                     │              │  │        │
│  Calculator  │                     │  Calculator  │  │History │
│  (full width)│                     │  (flex: 3)   │  │(flex:2)│
│              │                     │              │  │        │
├──────────────┤                     │              │  │        │
│ History Sheet│                     │              │  │        │
│ (overlay)    │                     │              │  │        │
└──────────────┘                     └──────────────┴──┴────────┘
  Narrow (Stack)                       Wide (Row)
```

### What Triggers the Switch

- **Phone rotation:** Portrait (e.g. 390dp) to landscape (e.g. 844dp) crosses 600dp
- **Tablet:** May always be in wide mode regardless of orientation
- **Desktop window resize:** Crossing 600dp switches layouts dynamically

The transition is handled by `LayoutBuilder` rebuilding on constraint changes. No animation is applied between layouts -- Flutter handles the rebuild naturally. State is preserved because both layouts consume the same Riverpod providers.

---

## 9. Spacing and Dimensions Summary

### Display Area

| Property | Portrait | Landscape |
|----------|---------|-----------|
| Padding (all sides) | 16dp | 12dp |
| Expression line height | ~24dp | ~20dp |
| Result line height | ~48dp | ~36dp |
| Total display height | ~160dp | ~80dp |
| Min height | 100dp | 72dp |

### Button Grid

| Property | Portrait | Landscape |
|----------|---------|-----------|
| Outer padding (horizontal) | 12dp | 8dp |
| Outer padding (vertical) | 8dp | 4dp |
| Button gap (horizontal) | 8dp | 6dp |
| Button gap (vertical) | 8dp | 6dp |
| Button corner radius | 16dp | 12dp |
| Min button dimension | 48x48dp | 48x48dp |
| Typical button dimension | ~84x80dp | ~116x48dp |

### History Panel (Landscape)

| Property | Value |
|----------|-------|
| Flex ratio | 2 (of 5 total) |
| Padding | 12dp horizontal, 8dp vertical |
| Item spacing | 8dp |
| Item padding | 12dp horizontal, 8dp vertical |
| Item corner radius | 12dp |
| Min item height | 56dp |

### History Sheet (Portrait)

| Property | Value |
|----------|-------|
| Top corner radius | 16dp |
| Handle bar size | 32dp x 4dp |
| Handle bar top padding | 8dp |
| Content padding | 12dp horizontal |
| Item spacing | 8dp |
| Snap sizes | 12%, 40%, 65% |
| Elevation | 4dp |

---

## 10. References

### Project Documents

- [Architecture](../../RESEARCH/architecture.md) -- Widget tree, provider graph, layout structure
- [Sprint 002 Tasking](../../SPRINTS/sprint-002-architecture.md) -- Task 2.1 definition
- [Lessons Learnt](../../LESSONS_LEARNED.md) -- Project knowledge base

### External References

- [Material Design 3 -- Layout](https://m3.material.io/foundations/layout/understanding-layout/overview)
- [Material Design 3 -- Typography](https://m3.material.io/styles/typography/overview)
- [Material Design 3 -- Colour](https://m3.material.io/styles/color/overview)
- [Flutter LayoutBuilder](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html)
- [Flutter DraggableScrollableSheet](https://api.flutter.dev/flutter/widgets/DraggableScrollableSheet-class.html)
- [WCAG 2.1 AA -- Target Size](https://www.w3.org/WAI/WCAG21/Understanding/target-size.html)

---

_Last updated: 2026-02-11_
