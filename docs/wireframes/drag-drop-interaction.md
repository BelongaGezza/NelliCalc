# Drag-and-Drop Interaction Design

**Purpose:** Define the complete interaction specification for dragging history results into the calculator display, covering all states, feedback, edge cases, and cross-boundary behaviour.

**Status:** Complete
**Author:** UI Designer
**Sprint:** sprint-002-architecture (Task 2.2)
**Date:** 2026-02-11

---

## Table of Contents

1. [Overview](#1-overview)
2. [Drag Initiation](#2-drag-initiation)
3. [Drag In Progress](#3-drag-in-progress)
4. [Drop Target States](#4-drop-target-states)
5. [Drop Behaviour](#5-drop-behaviour)
6. [Cancel Behaviour](#6-cancel-behaviour)
7. [Cross-Boundary Drag](#7-cross-boundary-drag)
8. [Haptic Feedback](#8-haptic-feedback)
9. [Animation Timing](#9-animation-timing)
10. [Accessibility](#10-accessibility)
11. [Edge Cases](#11-edge-cases)
12. [Flutter Implementation Notes](#12-flutter-implementation-notes)
13. [References](#13-references)

---

## 1. Overview

The drag-and-drop interaction allows users to take a previous calculation result from the history list and insert it into the current expression. This is the distinguishing feature of NelliCalc.

### Interaction Summary

```
History Item (source)  ──long-press──►  Drag feedback (chip)  ──move to display──►  Drop (append value)
```

### Components Involved

| Component | Widget | Role |
|-----------|--------|------|
| Source | `HistoryItem` (`LongPressDraggable<String>`) | Provides the draggable value |
| Feedback | Elevated chip (overlay) | Follows the user's finger during drag |
| Target | `CalculatorDisplay` (`DragTarget<String>`) | Receives the dropped value |

### Data Flow

The drag data type is `String` -- specifically, the `displayValue` of a `HistoryEntry` (e.g., `"42"`, `"3.14"`). On drop, `CalculatorNotifier.insertValue(value)` appends the value to the current expression.

---

## 2. Drag Initiation

### Long-Press Trigger

| Property | Value | Notes |
|----------|-------|-------|
| Gesture | Long-press | `LongPressDraggable` (not `Draggable`) to avoid scroll conflicts |
| Duration | 500ms | Flutter default `kLongPressTimeout`; do not customise unless user testing reveals issues |
| Touch slop | Platform default (~18px) | Distance the finger can move during long-press without cancelling |

### Visual Cue Sequence

Users need to know that history items are draggable before they attempt a drag. The following cues are used:

**1. Passive indicator (always visible):**

The drag handle icon (`Icons.drag_indicator`) is displayed on the leading edge of every history item. This six-dot icon is a widely recognised affordance for "this item can be moved."

```
┌──────────────────────────────────────┐
│  ⠿   42                              │  ← Drag handle always visible
│       6 x 7                    2m ago │
└──────────────────────────────────────┘
```

**2. Long-press acknowledgement (at 500ms):**

When the long-press threshold is reached:

- The source item reduces to 30% opacity (ghost state)
- The feedback widget (elevated chip) appears under the user's finger
- A subtle scale-up animation (100ms, from 0.95 to 1.0) plays on the feedback chip to emphasise "pick up"
- Haptic feedback fires (light impact, if enabled -- see Section 8)

**3. Visual timeline:**

```
t=0ms          Finger touches history item
               (no visual change yet -- normal touch)

t=500ms        Long-press threshold reached
               → Source item fades to 30% opacity
               → Feedback chip appears at finger position
               → Chip scales from 0.95 to 1.0 over 100ms
               → Light haptic pulse
               → Drop target (display) shows drag-active state

t=500ms+       Drag in progress (see Section 3)
```

---

## 3. Drag In Progress

### Feedback Widget (Elevated Chip)

The feedback widget is the visual element that follows the user's finger during the drag. It floats above all other content via Flutter's overlay system.

```
┌─────────────────────┐
│  ◈  42              │   Elevated chip with value
└─────────────────────┘
    ↑ shadow (6dp elevation)
```

| Property | Value | Notes |
|----------|-------|-------|
| Shape | `RoundedRectangleBorder`, 8dp corner radius | Compact, pill-like appearance |
| Background | `primaryContainer` | Stands out against any surface |
| Text colour | `onPrimaryContainer` | Contrast with chip background |
| Text style | `titleMedium`, bold | Readable at arm's length |
| Padding | 12dp horizontal, 8dp vertical | Comfortable touch area |
| Elevation | 6dp | Casts a visible shadow to convey "lifted" state |
| Max width | 120dp | Prevents very long values from creating an unwieldy chip |
| Overflow | Truncate with ellipsis | For values exceeding max width |
| Icon | Small drag icon (12dp, leading) | Optional -- reinforces dragging state |

### Source Item (Ghost State)

While the drag is in progress, the original history item remains in place but at reduced opacity to indicate that it is the source of the drag.

| Property | Value |
|----------|-------|
| Opacity | 0.3 (30%) |
| Transition | Immediate (set via `childWhenDragging`) |
| Interaction | Not tappable during drag |

The source item is not removed from the list -- it is a copy operation, not a move. The history entry remains in the list after the drag completes.

### Pointer Tracking

The feedback widget is offset so that its centre-bottom aligns with the finger position. This keeps the chip visible above the finger rather than hidden beneath it, and provides a clear line of sight to the drop target.

| Property | Value |
|----------|-------|
| Feedback offset | `Offset(0, -40)` (40dp above touch point) |
| Axis lock | None (free movement in both axes) |

---

## 4. Drop Target States

The `CalculatorDisplay` serves as the sole drop target. It progresses through four visual states during a drag interaction.

### State Diagram

```
         Drag starts              Finger enters              Finger releases
         anywhere                 display area               over display
┌──────┐           ┌────────────┐              ┌──────────┐              ┌──────────┐
│ Idle │──────────►│ Drag-Active│─────────────►│ Hovering │─────────────►│ Accepted │
│      │           │(not hover) │              │          │              │          │
└──────┘           └────────────┘              └──────────┘              └──────────┘
    ▲                    │                         │                          │
    │                    │ Drag ends               │ Finger leaves            │ Animation
    │                    │ (cancel)                │ display area             │ completes
    │                    ▼                         ▼                          │
    │               ┌──────┐                  ┌────────────┐                  │
    └───────────────│ Idle │◄─────────────────│ Drag-Active│                  │
                    └──────┘                  │(not hover) │                  │
                         ▲                    └────────────┘                  │
                         │                                                   │
                         └───────────────────────────────────────────────────┘
```

### State Definitions

#### Idle (no drag active)

The default state. No special decoration on the display area.

```
┌──────────────────────────────────────────────────┐
│                                                  │
│                               12 + 3.14          │  Expression
│                                   15.14          │  Result
│                                                  │
└──────────────────────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| Border | None (standard display appearance) |
| Background | Default surface colour |
| Drop hint | Hidden |

#### Drag-Active, Not Hovering

A drag is in progress somewhere on screen, but the finger is not over the display. A subtle visual cue indicates the display is a valid drop target.

```
┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐
│                                                  │
│                               12 + 3.14          │
│                                   15.14          │
│                                                  │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  │
│  │     Drop a previous result here   ↓      │  │  Drop hint (subtle)
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │
│                                                  │
└ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
```

| Property | Value |
|----------|-------|
| Border | 2dp dashed, `primary` at 30% opacity |
| Background | No change |
| Drop hint | Visible, `bodySmall`, `primary` at 60% opacity, centred |
| Transition in | 200ms ease-out |

#### Hovering (Drag Over Target)

The user's finger (and feedback widget) is directly over the display area. Strong visual feedback confirms the drop will succeed.

```
╔══════════════════════════════════════════════════╗
║                                                  ║
║                               12 + 3.14          ║
║                                   15.14          ║
║                                                  ║
║  ┌─────────────────────────────────────────────┐ ║
║  │     Drop a previous result here   ↓        │ ║  Drop hint (prominent)
║  └─────────────────────────────────────────────┘ ║
║                                                  ║
╚══════════════════════════════════════════════════╝
```

| Property | Value |
|----------|-------|
| Border | 2dp solid, `primary` colour (full opacity) |
| Background | `primaryContainer` at 12% opacity |
| Drop hint | Visible, `bodySmall`, `primary` at 80% opacity |
| Transition in | 150ms ease-out (from drag-active state) |
| Corner radius | 12dp (matches display container) |

#### Accepted (Drop Completed)

The user releases their finger over the display. A brief confirmation animation plays before returning to idle.

| Property | Value |
|----------|-------|
| Border | Briefly pulses to `primary` at full opacity, then fades to none over 300ms |
| Background | `primaryContainer` at 12% opacity, fading to default over 300ms |
| Result line | Scale animation: 1.0 to 1.05 to 1.0 over 200ms (subtle "absorb" effect) |
| Drop hint | Fades out over 150ms |
| Haptic | Medium impact (see Section 8) |

---

## 5. Drop Behaviour

### Primary Rule: Append to Expression End

When a value is dropped onto the `CalculatorDisplay`, it is appended to the end of the current expression. This is the simplest model and the starting point; more sophisticated insertion (e.g., at cursor position) may be iterated on based on user testing.

```
Before drop:  expression = "12 + "     →  After drop:  expression = "12 + 42"
              (user typed "12 +")                      (dropped "42")
```

### Context-Dependent Behaviour

The `CalculatorNotifier.insertValue(value)` method handles different expression states:

| Expression State | Current Expression | Dropped Value | Result | Notes |
|-----------------|-------------------|---------------|--------|-------|
| **Empty** | `""` | `"42"` | `"42"` | Value becomes the start of a new expression |
| **After operator** | `"12 + "` | `"42"` | `"12 + 42"` | Natural append -- most common case |
| **After digit** | `"12"` | `"42"` | `"12 + 42"` | Auto-insert `" + "` operator before the value |
| **After closing paren** | `"(3 + 4)"` | `"42"` | `"(3 + 4) + 42"` | Auto-insert `" + "` operator before the value |
| **After decimal point** | `"12."` | `"42"` | `"12. + 42"` | Treat as after-digit; auto-insert operator |
| **After evaluated result** | `"15.14"` (result displayed) | `"42"` | `"15.14 + 42"` | Start new expression using previous result + dropped value |
| **Error state** | (error displayed) | `"42"` | `"42"` | Clear error, start fresh with dropped value |

### Auto-Insert Operator Rule

When the dropped value would create an implicit concatenation (e.g., `"1242"` from `"12"` + `"42"`), the notifier automatically inserts `" + "` between the existing expression and the dropped value. Addition is chosen as the default operator because:

1. It is the most common "combine two values" intent
2. It is non-destructive (does not multiply/divide unexpectedly)
3. The user can immediately backspace and change the operator if needed

### Negative Dropped Values

If the dropped value is negative (e.g., `"-5"`), the auto-insert rule still applies:

| Current Expression | Dropped Value | Result |
|-------------------|---------------|--------|
| `"12"` | `"-5"` | `"12 + -5"` |
| `"12 + "` | `"-5"` | `"12 + -5"` |
| `""` (empty) | `"-5"` | `"-5"` |

The engine's parser handles `+ -` as addition of a negative number (see architecture doc, Section 7.4 on unary minus).

---

## 6. Cancel Behaviour

### Drop Outside Target

If the user releases their finger anywhere other than the `CalculatorDisplay`:

| Action | Result |
|--------|--------|
| Feedback widget | Fades out over 200ms at the release position |
| Source item | Restores to full opacity (100%) over 200ms |
| Drop target | Returns to idle state (border fades, hint hides) over 200ms |
| Expression | No change |
| Haptic | None |

The fade-out at the release position (rather than snapping back to the source) is deliberate. A snap-back animation would require tracking the source widget's global position, which is complex when the source is inside a scrollable sheet. The fade-out is simpler and provides adequate feedback that the drag was cancelled.

### Drag Cancelled by System

Drags can be cancelled by the system in several scenarios:

| Scenario | Behaviour |
|----------|-----------|
| **Incoming phone call** | Drag cancelled; same as drop-outside-target |
| **App sent to background** | Drag cancelled; state restored on resume |
| **Second finger touches screen** | `LongPressDraggable` cancels the drag by default; same restore behaviour |
| **Notification overlay appears** | Drag may continue if finger stays down; otherwise cancelled |

### User Lifts Finger During Long-Press (Before Threshold)

If the user lifts their finger before the 500ms long-press threshold:

- No drag initiates
- The item receives a normal tap event (currently no action -- history items are drag-only)
- No visual state change on the display

---

## 7. Cross-Boundary Drag

### How It Works

Flutter's `LongPressDraggable` creates a feedback widget on the `Overlay`, which sits above all other widgets in the widget tree. This means the feedback widget can visually cross any widget boundary -- including the boundary between the `DraggableScrollableSheet` and the calculator display in portrait mode, or between the history panel and the calculator in landscape mode.

The `DragTarget` detects the drag via hit-testing against the overlay's pointer events, regardless of the source widget's position in the tree.

### Portrait Mode (Sheet to Display)

In portrait mode, the user drags upward from the history sheet to the calculator display.

```
┌──────────────────────────────────────┐
│                                      │
│  CALCULATOR DISPLAY (DragTarget)     │
│  ╔══════════════════════════════════╗│  ← Hover state active
│  ║                    12 +          ║│
│  ║                    12            ║│
│  ║  Drop a previous result here ↓  ║│
│  ╚══════════════════════════════════╝│
│                                      │
│  BUTTON GRID                         │
│  ┌──────────────────────────────────┐│
│  │  [C] [( )] [ %] [ ÷]           ││
│  │  [7] [ 8 ] [ 9] [ x]           ││
│  │  ...                             ││
│  └────────────┌─────────┐──────────┘│
│               │  ◈ 42   │           │  ← Feedback chip (overlay)
├───────────────┤         ├───────────┤     follows finger upward
│  ═════════════└─────────┘═══════════│
│              ━━━━━━━━━━              │
│         Previous Results             │
│  ┌──────────────────────────────────┐│
│  │ ⠿  42         (0.3 opacity)     ││  ← Ghost of source item
│  │    6 x 7                         ││
│  └──────────────────────────────────┘│
│  ┌──────────────────────────────────┐│
│  │ ⠿  15.14                        ││
│  └──────────────────────────────────┘│
└──────────────────────────────────────┘
```

#### Portrait-Specific Considerations

| Consideration | Behaviour |
|--------------|-----------|
| **Sheet position during drag** | The sheet remains at its current snap position. It does not auto-collapse or auto-expand during a drag. |
| **Drag across button grid** | The button grid is not a `DragTarget`. No visual feedback as the finger passes over buttons. Buttons do not activate during a drag. |
| **Sheet scroll during drag** | Scrolling within the sheet is disabled once the drag begins (Flutter handles this automatically with `LongPressDraggable`). |
| **Short drag distance** | If the sheet is at the 65% snap, the display is close. The drag still works -- there is no minimum drag distance requirement. |
| **Sheet at 12% (collapsed)** | The user must first expand the sheet (swipe up) to see history items, then long-press to drag. The collapsed state only shows the handle and label. |

### Landscape Mode (Panel to Display)

In landscape mode, the user drags horizontally from the history panel on the right to the calculator display on the left.

```
┌────────────────────────────────────────────┬──┬─────────────────────────────┐
│                                            │  │                             │
│  CALCULATOR DISPLAY (DragTarget)           │  │  HISTORY PANEL              │
│  ╔════════════════════════════════════╗     │V │  ┌─────────────────────┐    │
│  ║                    12 +            ║     │e │  │ ⠿ 42  (0.3 opacity)│    │
│  ║                    12              ║     │r │  │   6 x 7             │    │
│  ║  Drop a result here ↓             ║     │t │  ├─────────────────────┤    │
│  ╚═══════════┌─────────┐═════════════╝     │i │  │ ⠿ 15.14            │    │
│              │  ◈ 42   │                   │c │  │   12 + 3.14         │    │
│  BUTTON GRID └─────────┘                   │a │  ├─────────────────────┤    │
│  ┌────────────────────────────────────┐    │l │  │ ⠿ 7                │    │
│  │ ...                                │    │  │  │   3 + 4             │    │
│  └────────────────────────────────────┘    │  │  └─────────────────────┘    │
│                                            │  │                             │
└────────────────────────────────────────────┴──┴─────────────────────────────┘
                                                          ↑
                                        Feedback chip crosses the VerticalDivider
                                        via the overlay system
```

#### Landscape-Specific Considerations

| Consideration | Behaviour |
|--------------|-----------|
| **Divider crossing** | The `VerticalDivider` is purely visual. The feedback widget floats above it on the overlay. |
| **Drag direction** | Primarily right-to-left, but any direction works -- the `DragTarget` is position-based, not direction-based. |
| **History panel scroll** | Scroll is disabled once the drag begins (same as portrait). |
| **Panel always visible** | Unlike portrait mode, the history panel is always visible in landscape. No extra gesture is needed to reveal history items. |

---

## 8. Haptic Feedback

Haptic feedback provides tactile confirmation at key moments in the drag interaction. It is optional and respects the device's system haptic settings.

### Haptic Events

| Event | Haptic Type | Flutter API | When |
|-------|------------|-------------|------|
| Drag initiated (long-press threshold met) | Light impact | `HapticFeedback.lightImpact()` | At 500ms, when feedback widget appears |
| Finger enters drop target | Selection click | `HapticFeedback.selectionClick()` | When `DragTarget.onWillAcceptWithDetails` fires |
| Drop accepted | Medium impact | `HapticFeedback.mediumImpact()` | When `DragTarget.onAcceptWithDetails` fires |
| Drop cancelled | None | N/A | No haptic on cancel (avoid "punishment" feedback) |

### Platform Notes

- Haptic feedback calls are no-ops on platforms that do not support them (desktop, web)
- On Android, haptic feedback requires the `VIBRATE` permission (included by default in most Flutter templates)
- On iOS, haptic feedback uses the Taptic Engine and works without additional permissions

### Implementation Note

Haptic calls should be wrapped in a helper function or service to allow easy disabling in tests and to respect a future "reduce haptics" user setting.

```dart
/// Fires haptic feedback if the platform supports it.
///
/// Calls are no-ops on unsupported platforms and can be
/// disabled for testing or user preference.
void triggerHaptic(HapticType type) {
  switch (type) {
    case HapticType.lightImpact:
      HapticFeedback.lightImpact();
    case HapticType.selectionClick:
      HapticFeedback.selectionClick();
    case HapticType.mediumImpact:
      HapticFeedback.mediumImpact();
  }
}
```

---

## 9. Animation Timing

All animations use Material Design 3 easing curves unless otherwise specified.

### Timing Reference

| Animation | Duration | Curve | Trigger |
|-----------|----------|-------|---------|
| Feedback chip scale-up (appear) | 100ms | `Curves.easeOut` | Long-press threshold met |
| Source item fade to ghost | Immediate | N/A | Set via `childWhenDragging` (no animation needed -- Flutter swaps instantly) |
| Drop target: idle to drag-active | 200ms | `Curves.easeOut` | Any drag starts on screen |
| Drop target: drag-active to hovering | 150ms | `Curves.easeOut` | Finger enters display area |
| Drop target: hovering to drag-active | 150ms | `Curves.easeIn` | Finger leaves display area |
| Drop target: hovering to accepted | 100ms | `Curves.easeOut` | Finger released over display |
| Accepted result line scale pulse | 200ms | `Curves.elasticOut` | Value inserted into expression |
| Drop target: accepted to idle | 300ms | `Curves.easeOut` | After accepted animation completes |
| Cancel: feedback chip fade-out | 200ms | `Curves.easeIn` | Finger released outside target |
| Cancel: source item restore opacity | 200ms | `Curves.easeOut` | Drag ends (any reason) |
| Cancel: drop target to idle | 200ms | `Curves.easeOut` | Drag ends without drop |

### Design Rationale

- **Short durations (100-300ms):** Drag interactions should feel responsive. Lengthy animations would make the interaction feel sluggish.
- **easeOut for appearing:** Elements that appear or expand should decelerate into their final position.
- **easeIn for disappearing:** Elements that leave should accelerate away.
- **elasticOut for the scale pulse:** A slight overshoot on the result line conveys a physical "absorb" sensation.

### AnimatedContainer Usage

The drop target state transitions use `AnimatedContainer` (validated in Sprint 001 PoC). The `duration` and `curve` parameters are set based on the current transition:

```dart
AnimatedContainer(
  duration: _isHovering
      ? const Duration(milliseconds: 150)
      : const Duration(milliseconds: 200),
  curve: Curves.easeOut,
  decoration: BoxDecoration(
    border: _buildBorder(),
    color: _buildBackground(),
    borderRadius: BorderRadius.circular(12),
  ),
  child: // ... display content
)
```

---

## 10. Accessibility

### Screen Reader Support

| Element | Semantic Label | Action |
|---------|---------------|--------|
| History item | "Result: [value]. Expression: [expression]. Long press to drag to calculator." | Long-press initiates drag |
| Drag handle icon | Excluded from semantics (redundant with item label) | N/A |
| Drop target (idle) | "Calculator display. Expression: [expression]. Result: [result]." | N/A |
| Drop target (drag-active) | "Calculator display. Drop zone ready. Drop a previous result here." | Announces when drag starts |
| Drop accepted | "Inserted [value] into expression." | Announced via `SemanticsService.announce()` |
| Drop cancelled | No announcement (silent cancellation avoids noise) | N/A |

### Alternative Input for Drag-and-Drop

Drag-and-drop is inherently visual and gesture-based. For users who cannot perform long-press-and-drag (motor impairments, screen reader users), an alternative input method should be provided:

- **Tap to insert:** A single tap on a history item could present a confirmation dialog or directly insert the value (to be designed in a future accessibility-focused sprint)
- **Context menu:** Long-press without drag could show a context menu with "Insert into expression" option

These alternatives are noted here as requirements for implementation but are out of scope for Sprint 002. They should be addressed before WCAG AA compliance is claimed.

### Contrast and Visibility

| Element | Foreground | Background | Min Contrast Ratio |
|---------|-----------|-----------|-------------------|
| Feedback chip text | `onPrimaryContainer` | `primaryContainer` | 4.5:1 (AA) |
| Drop hint text | `primary` at 60% | Display surface | 3:1 (AA for large text) |
| Hover border | `primary` | Display surface | Decorative (no minimum) |
| Ghost source item | 30% opacity original | List surface | Decorative (intentionally low contrast) |

---

## 11. Edge Cases

### Very Long Values

If a dropped value has many digits (e.g., `"0.3333333333"` from `1 / 3`):

| Concern | Solution |
|---------|----------|
| Feedback chip too wide | Max width 120dp with text truncation (ellipsis). Full value is still dropped. |
| Expression overflow in display | Expression line scrolls horizontally (single-line, right-aligned, clip overflow). This is a display concern, not a drag concern. |

### Dragging While Sheet Is Animating (Portrait)

If the user long-presses a history item while the `DraggableScrollableSheet` is mid-animation (e.g., snapping from 12% to 40%):

- The sheet animation continues; the drag initiates normally
- The feedback widget follows the finger on the overlay, unaffected by the sheet's scroll position
- The ghost (source item) moves with the sheet content as the animation completes
- No special handling is required -- Flutter's overlay system isolates the feedback from the sheet

### Rapid Sequential Drags

If the user quickly drops one value and immediately starts dragging another:

| Step | Behaviour |
|------|-----------|
| First drop completes | Value inserted, accepted animation begins (300ms) |
| Second drag starts during animation | The display state resets: accepted animation is interrupted, transitions directly to drag-active state |
| Second drop completes | Value appended after the first dropped value (following the auto-insert operator rule) |

There is no debounce or cooldown on drag interactions. Users should be able to drag values as fast as they can gesture.

### Dragging the Same Item Twice

Dragging the same history item twice in succession appends the value twice:

```
Expression: ""  →  drop "42"  →  "42"  →  drop "42"  →  "42 + 42"
```

This is expected and correct. The history list is not modified by drag operations.

### Empty History List

When the history list is empty:

- No items are available to drag
- The empty state message ("No results yet. Tap = to calculate.") is displayed
- The drop target never enters drag-active state because no drag can originate

### Dragging During Error State

If the calculator display is showing an error (e.g., "Cannot divide by zero") and the user drops a value:

- The error is cleared
- The dropped value becomes the new expression (e.g., `"42"`)
- The display returns to the normal inputting state

### History Item Partially Off-Screen

If a history item is partially scrolled off the visible area of the sheet or panel:

- The user can still long-press the visible portion to initiate a drag
- `LongPressDraggable` uses the widget's full hit-test area, not just the visible portion
- The feedback widget appears at the finger position regardless of source widget clipping

### Orientation Change During Drag

If the device is rotated while a drag is in progress:

- Flutter cancels the drag (the widget tree rebuilds)
- The expression remains unchanged
- The user must re-initiate the drag in the new orientation
- No special handling is required

---

## 12. Flutter Implementation Notes

### Key Widget Configuration

**HistoryItem (source):**

```dart
LongPressDraggable<String>(
  data: entry.displayValue,
  feedback: Material(
    elevation: 6,
    borderRadius: BorderRadius.circular(8),
    color: theme.colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 120),
        child: Text(
          entry.displayValue,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  ),
  childWhenDragging: Opacity(
    opacity: 0.3,
    child: // ... normal history item content
  ),
  feedbackOffset: const Offset(0, -40),
  hapticFeedbackOnStart: true,
  child: // ... normal history item content
)
```

**CalculatorDisplay (target):**

```dart
DragTarget<String>(
  onWillAcceptWithDetails: (details) {
    setState(() => _isHovering = true);
    HapticFeedback.selectionClick();
    return true;
  },
  onLeave: (data) {
    setState(() => _isHovering = false);
  },
  onAcceptWithDetails: (details) {
    setState(() => _isHovering = false);
    HapticFeedback.mediumImpact();
    ref.read(calculatorProvider.notifier).insertValue(details.data);
    // Trigger accepted animation
  },
  builder: (context, candidateData, rejectedData) {
    final isDragActive = candidateData.isNotEmpty;
    return AnimatedContainer(
      duration: Duration(milliseconds: _isHovering ? 150 : 200),
      curve: Curves.easeOut,
      // ... decoration based on state
    );
  },
)
```

### Detecting "Any Drag Active" State

The drag-active-not-hovering state (dashed border) requires knowing that a drag is happening somewhere on screen, even when the finger is not over the display. There are two approaches:

**Option A: Use `candidateData` from `DragTarget.builder`.**
The `candidateData` list is non-empty only when the drag is hovering over this specific target. For the broader "drag active anywhere" signal, this is insufficient.

**Option B: Use a shared state flag.**
A simple Riverpod `StateProvider<bool>` (e.g., `isDragActiveProvider`) that the `HistoryItem` sets to `true` on drag start and `false` on drag end. The display watches this provider to show the dashed border.

```dart
final isDragActiveProvider = StateProvider<bool>((ref) => false);
```

The `HistoryItem` wraps the `LongPressDraggable` with drag lifecycle callbacks:

```dart
LongPressDraggable<String>(
  onDragStarted: () => ref.read(isDragActiveProvider.notifier).state = true,
  onDragEnd: (details) => ref.read(isDragActiveProvider.notifier).state = false,
  onDraggableCanceled: (velocity, offset) =>
      ref.read(isDragActiveProvider.notifier).state = false,
  // ...
)
```

**Recommendation:** Option B. It is explicit, testable, and decoupled from the `DragTarget`'s internal state.

### Dashed Border Implementation

Flutter does not have a built-in dashed border. Options:

1. **`CustomPainter`** -- Draw dashed lines manually. Full control, zero dependencies.
2. **`dotted_border` package** -- Third-party widget for dashed/dotted borders.

**Recommendation:** Use a simple `CustomPainter` for the dashed border to avoid adding a dependency for a single visual element. The painter draws a `RRect` path with dash intervals.

---

## 13. References

### Project Documents

- [Calculator Layout Wireframes](calculator-layout.md) -- Spatial layout, display states, history item design
- [Architecture](../../RESEARCH/architecture.md) -- Widget tree, provider graph, drag-and-drop flow
- [Lessons Learnt](../../LESSONS_LEARNED.md) -- Project knowledge base

### Sprint 001 PoC Findings

- `LongPressDraggable` validated: avoids scroll conflicts, cross-boundary drag works via overlay
- 0.3 opacity ghost state confirmed as clear "source" indicator
- Elevated feedback chip is readable during drag
- `AnimatedContainer` hover highlight is smooth and performant
- Cross-boundary drag from `DraggableScrollableSheet` to main area works natively

### External References

- [Flutter LongPressDraggable](https://api.flutter.dev/flutter/widgets/LongPressDraggable-class.html)
- [Flutter DragTarget](https://api.flutter.dev/flutter/widgets/DragTarget-class.html)
- [Flutter HapticFeedback](https://api.flutter.dev/flutter/services/HapticFeedback-class.html)
- [Material Design 3 -- Motion](https://m3.material.io/styles/motion/overview)
- [WCAG 2.1 -- Pointer Gestures](https://www.w3.org/WAI/WCAG21/Understanding/pointer-gestures.html)

---

_Last updated: 2026-02-11_
