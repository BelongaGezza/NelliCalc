# Sprint D01: Visual Design Prototype

**Status:** Planning
**Track:** Parallel Design Track (runs alongside Sprint 003/004)
**Start:** After Sprint 002 completes | **Target End:** 1 week

## Sprint Goal

Build a non-functional but fully styled calculator prototype for early feedback on look and feel, before any engine implementation begins.

---

## CRITICAL: Role Selection (READ FIRST - STOP HERE UNTIL COMPLETE)

**You are an unassigned agent. You MUST claim a role before proceeding.**

1. Look at the Role Assignment Table below
2. Find a role with Status = `Available`
3. Claim it by:
   - Updating Status to `In Progress`
   - Adding your session ID to Assigned Agent column
   - Reading the persona file listed in Persona File column
   - Adopting that identity fully
4. If all roles are taken, STOP and notify the user

---

## Role Assignment Table

| Role | Persona File | Status | Assigned Agent | Tasks | Dependencies |
|------|--------------|--------|----------------|-------|--------------|
| UI Designer | `.agents/ui-designer.md` | Available | - | 1.1, 2.1, 2.2, 2.3, 3.1 | None |
| Senior Engineer | `.agents/senior-engineer.md` | Available | - | 1.2, 3.2 | Task 1.1 |

**Available Persona Files:**
- System Architect: `.agents/system-architect.md`
- Senior Engineer: `.agents/senior-engineer.md`
- Junior Engineer: `.agents/junior-engineer.md`
- Security Specialist: `.agents/security-specialist.md`
- Documentation Specialist: `.agents/documentation-specialist.md`
- Researcher: `.agents/researcher.md`
- UI Designer: `.agents/ui-designer.md`

---

## Context

This is the first sprint of the **parallel design track**. It runs independently of the engine work (Sprint 003-004). The goal is to produce a clickable visual prototype that can be reviewed on Linux desktop via screenshots, so look and feel feedback happens before the engine and UI are wired together in Sprint 005.

### What we know from Sprint 001 PoC:
- `LongPressDraggable` + `DragTarget` works well for drag interaction
- `LayoutBuilder` at 600dp breakpoint switches between wide/narrow layouts
- `DraggableScrollableSheet` with snap sizes (12%/40%/65%) works for portrait history pane
- Material 3 theming via `ColorScheme.fromSeed` is the starting point

### What this sprint produces:
- A **running Flutter app** with a styled calculator screen — buttons you can tap (with visual feedback), display area, history panel, responsive layout
- **No actual calculation** — tapping "5 + 3 =" shows dummy feedback, not a real result
- **Theme and visual identity** locked in for the rest of the project
- **Screenshots** captured for review

---

## Task List

### 1. Visual Identity

#### Task 1.1: Define Theme and Visual Language

**Objective:** Research calculator app design trends and define NelliCalc's visual identity — colour palette, typography, button styles, spacing, and overall aesthetic.

**Acceptance Criteria:**
- [ ] Colour palette defined (primary, secondary, surface, error colours) for both light and dark themes
- [ ] Typography scale defined (display font for results, body font for history, button font)
- [ ] Button style defined (shape, elevation, padding, pressed/ripple states)
- [ ] Spacing tokens defined (margins, padding, gaps between buttons)
- [ ] Corner radius convention defined (sharp, slightly rounded, or pill-shaped buttons)
- [ ] Visual mood/direction documented (e.g., minimal/clean, bold/colourful, skeuomorphic, etc.)
- [ ] Design rationale documented in `docs/design/visual-identity.md`

**Status:** Not Started
**Assigned:** UI Designer
**Dependencies:** None
**Priority:** Critical

**Implementation Notes:**
- Study existing calculator apps for inspiration: Apple Calculator, Google Calculator, Calcbot, PCalc, Numi
- NelliCalc's differentiator is drag-and-drop — the history panel and drag interaction should be visually prominent, not hidden
- Consider that the calculator display doubles as a drop target — it needs to look inviting as a drag destination
- Material 3 `ColorScheme.fromSeed` is the base — pick a seed colour that feels right
- Think about what makes this feel premium vs utilitarian
- Dark theme should be equally considered — many users prefer dark mode for calculator apps

---

#### Task 1.2: Implement ThemeData

**Objective:** Translate the visual identity into a Flutter `ThemeData` with custom `ColorScheme`, text themes, and component themes.

**Acceptance Criteria:**
- [ ] Light theme `ThemeData` implemented in `lib/theme/`
- [ ] Dark theme `ThemeData` implemented in `lib/theme/`
- [ ] Custom `ColorScheme` (not just default `fromSeed`)
- [ ] `TextTheme` customised for calculator display (large monospace numbers), buttons, and history items
- [ ] `ElevatedButton` / `FilledButton` themes for calculator buttons
- [ ] Theme toggling works (light/dark switch)
- [ ] `dart analyze` clean, `dart format` clean

**Status:** Not Started
**Assigned:** Senior Engineer
**Dependencies:** Task 1.1
**Priority:** Critical

**Implementation Notes:**
- Create `lib/theme/nelli_theme.dart` with light and dark `ThemeData` factories
- Use `GoogleFonts` package or a system monospace font for the calculator display (numbers should be tabular/monospaced so digits don't shift as the display updates)
- Component themes to customise: `ElevatedButtonThemeData`, `CardTheme`, `AppBarTheme`, `DividerThemeData`
- Consider defining a `NelliSpacing` class or extension with standard spacing constants (4, 8, 12, 16, 24, 32dp)

---

### 2. Interactive Prototype

#### Task 2.1: Design and Build Calculator Button Grid

**Objective:** Create a styled calculator button grid with all standard buttons, proper sizing, spacing, and visual feedback on tap.

**Acceptance Criteria:**
- [ ] Button grid with: digits 0-9, decimal point (.), operators (+, −, ×, ÷), equals (=), clear (C), backspace (⌫), parentheses ( )
- [ ] Buttons respond to tap with ripple/ink effect and colour change
- [ ] Operator buttons visually distinct from digit buttons (different colour or weight)
- [ ] Equals button visually prominent (accent colour, larger or distinct shape)
- [ ] Button grid fills available width with consistent spacing
- [ ] Minimum 48x48dp touch targets maintained
- [ ] Button grid works in both portrait and landscape orientations
- [ ] Tapping buttons updates a dummy display string (e.g., tapping "5" "+" "3" shows "5+3" in the display)

**Status:** Not Started
**Assigned:** UI Designer
**Dependencies:** Task 1.1
**Priority:** Critical

**Implementation Notes:**
- Use a `GridView` or manual `Row`/`Column` layout for the button grid
- Standard 4-column layout: digits on the left 3 columns, operators on the right column
- Bottom row: typically "0" spans 2 columns, "." and "=" take 1 column each
- Consider `AspectRatio` to keep buttons square or near-square
- The dummy display just concatenates button labels — no parsing or evaluation

---

#### Task 2.2: Build Styled Calculator Display

**Objective:** Create the calculator display area with proper typography, showing both the expression line and result line, styled as a drag target.

**Acceptance Criteria:**
- [ ] Display shows two lines: current expression (smaller, top) and current result/value (larger, bottom)
- [ ] Result text uses the monospace/tabular number font from the theme
- [ ] Display area is visually a `DragTarget` — subtle visual cue that items can be dropped here (e.g., a faint drop zone indicator, or a label that appears when the history panel is open)
- [ ] Display area highlights when a draggable hovers over it (as in PoC, but styled to match the theme)
- [ ] Display has enough vertical padding to be comfortable as a drop target (tall enough to aim at)
- [ ] Right-aligned numbers, left-aligned expression
- [ ] Overflow handling: long expressions scroll or shrink text, long results use scientific notation or scroll

**Status:** Not Started
**Assigned:** UI Designer
**Dependencies:** Task 1.1, Task 2.1
**Priority:** High

**Implementation Notes:**
- The display is the emotional centre of the app — it should feel clean and spacious
- Consider a subtle background colour or card elevation to distinguish it from the button area
- The expression line and result line should have clear visual hierarchy (size, weight, opacity)
- Drop zone indicator ideas: faint dashed border, subtle icon, or text like "Drop result here" that appears contextually

---

#### Task 2.3: Build Styled History Panel

**Objective:** Create a styled history panel (wide layout side panel + narrow layout bottom sheet) with draggable result items that match the visual identity.

**Acceptance Criteria:**
- [ ] History items show: result value (prominent), expression (secondary), timestamp (tertiary)
- [ ] History items are `LongPressDraggable` with styled feedback widget matching the theme
- [ ] Wide layout: history panel with header, scrollable list, visually separated from calculator
- [ ] Narrow layout: `DraggableScrollableSheet` with styled drag handle, rounded top corners, shadow
- [ ] Empty state: message shown when no history exists ("No calculations yet")
- [ ] History items have hover/focus states for desktop use
- [ ] Drag feedback widget: elevated card with the result value, matching theme colours

**Status:** Not Started
**Assigned:** UI Designer
**Dependencies:** Task 1.1, Task 2.1
**Priority:** High

**Implementation Notes:**
- History items should feel like "chips" or "cards" that are obviously draggable
- The drag indicator icon from the PoC worked well — keep it but style it to match the theme
- Consider subtle animations: items could have a slight scale effect on long-press start before the drag begins
- The bottom sheet handle should match Material 3 conventions (small rounded rectangle, subtle colour)
- Use mock history data (8-10 items with varied lengths) for a realistic feel

---

### 3. Feedback Capture

#### Task 3.1: Assemble Complete Prototype Screen

**Objective:** Wire together the display, button grid, and history panel into a complete responsive prototype screen and capture screenshots.

**Acceptance Criteria:**
- [ ] Complete calculator screen working in both wide and narrow layouts
- [ ] Tapping buttons updates the dummy display string
- [ ] Dragging a history item into the display appends it to the dummy display string
- [ ] Theme toggle (light/dark) accessible from the app bar
- [ ] All animations and transitions smooth (no janky frames)
- [ ] Screenshots captured in `docs/design/screenshots/`:
  - Portrait narrow layout (light theme)
  - Portrait narrow layout (dark theme)
  - Portrait narrow layout with history sheet pulled up
  - Wide landscape layout (light theme)
  - Wide landscape layout (dark theme)
  - Drag in progress (item being dragged from history to display)
- [ ] `dart analyze` clean, `dart format` clean, `flutter test` all passing

**Status:** Not Started
**Assigned:** UI Designer
**Dependencies:** Tasks 1.2, 2.1, 2.2, 2.3
**Priority:** Critical

**Implementation Notes:**
- This is the deliverable that gets reviewed — it should look polished
- Use `flutter screenshot` or the Linux screenshot tool to capture screenshots
- Place the prototype in `lib/prototype/` (separate from `lib/poc/` which is throwaway)
- Update `main.dart` to launch the prototype screen (keep PoC accessible via a debug route if needed)
- Run on Linux desktop at phone-like window sizes (360x800 for narrow, 800x400 for wide) to simulate mobile proportions
- Consider adding a simple `SegmentedButton` or `Switch` to toggle between light/dark theme

---

#### Task 3.2: Document Design Decisions and Open Questions

**Objective:** Create a design decisions document summarising what was chosen, what alternatives were considered, and what questions remain for feedback.

**Acceptance Criteria:**
- [ ] `docs/design/design-decisions.md` created
- [ ] Colour palette rationale documented
- [ ] Button layout rationale documented
- [ ] Open questions listed for reviewer feedback (e.g., "Should the history panel have a search/filter?", "Is the button size comfortable?", "Does the colour scheme feel right?")
- [ ] Known limitations of the prototype noted (no real calculation, no persistence, etc.)

**Status:** Not Started
**Assigned:** Senior Engineer
**Dependencies:** Task 3.1
**Priority:** Medium

**Implementation Notes:**
- Keep this concise — it's a conversation starter, not a formal spec
- Include "What do you think about..." questions to guide feedback
- Link to the screenshots in `docs/design/screenshots/`

---

## Progress Log

Record handover notes, blockers, and status updates here in chronological order (newest first).

_No entries yet._

---

## Dependencies and Handovers

| Provider Task | Consumer Task | Status | Handover Completed | Notes |
|---------------|---------------|--------|-------------------|-------|
| Sprint 002 wireframes | Task 2.1 | Pending | No | Wireframes inform button layout and component placement |
| Task 1.1 | Task 1.2 | Pending | No | Visual identity before theme implementation |
| Task 1.1 | Tasks 2.1, 2.2, 2.3 | Pending | No | Visual identity before styled components |
| Task 1.2 | Task 3.1 | Pending | No | Theme must be implemented before final assembly |
| Tasks 2.1, 2.2, 2.3 | Task 3.1 | Pending | No | All components needed for complete screen |
| Task 3.1 | Task 3.2 | Pending | No | Screenshots needed for design decisions doc |
| Task 3.1 | Sprint 005 | Pending | No | Styled prototype informs production UI |
| Task 3.1 | Sprint D02 | Pending | No | Feedback may trigger design iteration |

---

## Completion Criteria

Sprint is considered complete when:

- [ ] Visual identity defined and documented
- [ ] Light and dark themes implemented in code
- [ ] Calculator button grid styled and responsive to taps
- [ ] Calculator display styled with expression + result lines
- [ ] History panel styled in both wide and narrow layouts
- [ ] Drag-and-drop works with styled feedback widgets
- [ ] Screenshots captured for all required views (6 minimum)
- [ ] Design decisions and open questions documented
- [ ] All code passes format, analyse, and test checks
- [ ] Prototype ready for review

---

## Feedback Process

1. Sprint D01 produces screenshots in `docs/design/screenshots/`
2. Design decisions and open questions in `docs/design/design-decisions.md`
3. **Reviewer (project owner)** reviews screenshots and runs the prototype on Linux desktop
4. Feedback captured as comments or a feedback document
5. If significant changes needed → Sprint D02 iterates
6. If approved → design track complete, styled components carry forward to Sprint 005

---

## Retrospective (Complete at Sprint End)

### What Went Well
-

### What Could Improve
-

### Lessons Learnt
- Reference: LESSON-NNN in LESSONS_LEARNED.md

### Action Items for Next Sprint
-

---

## Archival

**Archived Date:** TBD
**Archived By:** TBD
**Archive Location:** `SPRINTS/archive/sprint-D01-visual-prototype.md`

_Move completed sprints to archive/ to minimise context loading for active work._
