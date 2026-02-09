# Sprint 002: Architecture, Data Model & UX Design

**Status:** Planning
**Release:** R01 | **Phase:** P01
**Start:** 2026-02-09 | **Target End:** 2026-02-16

## Sprint Goal

Define the application architecture, data model, and UX wireframes so that Sprint 003+ implementation has a clear blueprint to follow.

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
| System Architect | `.agents/system-architect.md` | Available | - | 1.1, 1.2, 1.3 | None |
| UI Designer | `.agents/ui-designer.md` | Available | - | 2.1, 2.2, 2.3 | Task 1.1 |
| Senior Engineer | `.agents/senior-engineer.md` | Available | - | 3.1, 3.2 | Task 1.1, 1.2 |

**Available Persona Files:**
- System Architect: `.agents/system-architect.md`
- Senior Engineer: `.agents/senior-engineer.md`
- Junior Engineer: `.agents/junior-engineer.md`
- Security Specialist: `.agents/security-specialist.md`
- Documentation Specialist: `.agents/documentation-specialist.md`
- Researcher: `.agents/researcher.md`
- UI Designer: `.agents/ui-designer.md`

---

## Context from Sprint 001

Sprint 001 validated the following through proof-of-concept:

- **Drag-and-drop:** `LongPressDraggable<String>` + `DragTarget<String>` — works well, avoids scroll conflicts
- **Responsive layout:** `LayoutBuilder` with 600dp breakpoint — wide (side-by-side `Row`) and narrow (`DraggableScrollableSheet` bottom pane with snap sizes 12%/40%/65%)
- **State management:** Riverpod (no codegen) recommended — 3 providers: calculator, history, persistence
- **Linting:** `very_good_analysis` 10.1.0 active
- **CI/CD:** GitHub Actions pipeline running format, analyse, test, and build

PoC code lives in `lib/poc/` and should be replaced by production architecture in this sprint.

---

## Task List

### 1. Architecture Document

#### Task 1.1: Define Application Architecture

**Objective:** Create `RESEARCH/architecture.md` defining the overall application structure, layer boundaries, and component relationships.

**Acceptance Criteria:**
- [ ] `RESEARCH/architecture.md` created
- [ ] Layered architecture defined (presentation, domain/business logic, data)
- [ ] Widget tree structure documented (app → responsive shell → calculator display + history panel)
- [ ] Riverpod provider graph documented (which providers exist, what they expose, dependencies between them)
- [ ] Navigation strategy documented (single screen with responsive layout, no routes needed initially)
- [ ] Dependency direction rules defined (presentation → domain ← data; domain has no Flutter imports)

**Status:** Not Started
**Assigned:** System Architect
**Dependencies:** None
**Priority:** Critical

**Implementation Notes:**
- Keep it simple — NelliCalc is a single-screen app with a calculator and history panel
- The architecture should make it easy to test the calculator engine in isolation (no Flutter dependency)
- Reference the PoC findings from Sprint 001 progress log
- Include a directory structure proposal for `lib/`

---

#### Task 1.2: Define Data Model

**Objective:** Design the data model for calculator state, history entries, and persistence.

**Acceptance Criteria:**
- [ ] `CalculatorState` model defined (current expression, result, display mode, error state)
- [ ] `HistoryEntry` model defined (value, expression, timestamp, unique ID)
- [ ] Persistence strategy documented (which package, schema/format, read/write patterns)
- [ ] Data model documented in `RESEARCH/architecture.md` (data model section)
- [ ] Immutable data classes specified (using `freezed` or manual `copyWith`)

**Status:** Not Started
**Assigned:** System Architect
**Dependencies:** Task 1.1
**Priority:** Critical

**Implementation Notes:**
- Keep models simple — avoid premature abstraction
- `HistoryEntry` needs a stable ID for drag-and-drop (so Flutter can track which item is being dragged)
- Evaluate whether `freezed` code generation is worth it for ~2 data classes, or if manual `copyWith` is simpler
- Persistence decision: `shared_preferences` (simplest, key-value), `hive` (structured NoSQL), or `sqflite` (relational). NelliCalc probably only needs `hive` or `shared_preferences` for a list of history entries.

---

#### Task 1.3: Define Calculator Engine Interface

**Objective:** Design the public interface for the calculator engine (expression parsing, evaluation, error handling) so Sprint 003 implementation has a clear contract.

**Acceptance Criteria:**
- [ ] Calculator engine API defined (input methods, evaluation, clear, backspace)
- [ ] Expression representation decided (string-based vs AST vs token list)
- [ ] Operator precedence rules documented (standard maths: BODMAS/PEMDAS)
- [ ] Error handling strategy defined (division by zero, overflow, malformed expressions)
- [ ] Decimal precision strategy documented
- [ ] Interface documented in `RESEARCH/architecture.md` (calculator engine section)

**Status:** Not Started
**Assigned:** System Architect
**Dependencies:** Task 1.1
**Priority:** High

**Implementation Notes:**
- The engine should be a pure Dart class with zero Flutter imports — fully unit-testable
- Consider whether to use an existing expression parsing package (e.g., `math_expressions`, `petitparser`) or build a simple custom parser
- For a basic calculator: addition, subtraction, multiplication, division, parentheses, decimal numbers, negative numbers
- Advanced features (percentage, square root, memory) can be noted as future extensions but not designed now
- Result precision: consider using `Decimal` package for financial-grade precision, or `double` with controlled formatting

---

### 2. UX Design

#### Task 2.1: Calculator Layout Wireframes

**Objective:** Design the calculator screen layout including button grid, display area, and history panel positioning for both orientations.

**Acceptance Criteria:**
- [ ] Portrait mode wireframe: calculator display + button grid + history sheet access
- [ ] Landscape mode wireframe: calculator (display + buttons) alongside history panel
- [ ] Button grid layout defined (which buttons, arrangement, sizing)
- [ ] Display area design defined (expression line, result line, drop target indicator)
- [ ] Wireframes documented in `docs/wireframes/` (text-based or ASCII art is fine)

**Status:** Not Started
**Assigned:** UI Designer
**Dependencies:** Task 1.1 (need architecture to know component boundaries)
**Priority:** High

**Implementation Notes:**
- Standard calculator buttons: digits 0-9, decimal point, operators (+, −, ×, ÷), equals, clear (C), backspace (⌫), parentheses
- Display area must double as a `DragTarget` — show visual affordance that results can be dropped here
- Consider thumb reachability — most-used buttons (digits, equals) should be in the bottom half of the screen
- Minimum touch target: 48x48dp with spacing
- History panel in landscape: scrollable list with drag handles (as validated in PoC)
- History sheet in portrait: `DraggableScrollableSheet` with snap sizes (as validated in PoC)

---

#### Task 2.2: Drag-and-Drop Interaction Design

**Objective:** Define the detailed interaction model for dragging history items into the calculator, including all edge cases and feedback states.

**Acceptance Criteria:**
- [ ] Drag initiation: long-press timing, visual cue that item is draggable
- [ ] Drag in progress: feedback widget appearance, what happens to the source item
- [ ] Drop target states: idle, hover (accepting), drop animation
- [ ] Drop behaviour: where does the dropped value go in the expression? (append, replace selection, insert at cursor)
- [ ] Cancel behaviour: what happens if the user drops outside the target?
- [ ] Cross-boundary drag: portrait mode (from sheet up to display), landscape mode (from panel across to display)
- [ ] Interaction spec documented in `docs/wireframes/`

**Status:** Not Started
**Assigned:** UI Designer
**Dependencies:** Task 2.1
**Priority:** High

**Implementation Notes:**
- Sprint 001 PoC validated: `LongPressDraggable` with 0.3 opacity ghost, elevated feedback chip, `AnimatedContainer` hover highlight
- Key decision: does dropping a value **replace** the entire expression, **append** it to the current position, or **insert** at a cursor position?
  - Simplest: append to end of expression (e.g., display shows `12 +`, drop `42`, display becomes `12 + 42`)
  - Most flexible: insert at cursor — but this requires a cursor concept in the calculator display
  - Recommend: start with append, iterate based on user testing
- Consider haptic feedback on drag start and successful drop

---

#### Task 2.3: Accessibility Design

**Objective:** Define accessibility requirements and how they apply to NelliCalc's specific UI patterns (drag-and-drop, bottom sheet, calculator buttons).

**Acceptance Criteria:**
- [ ] Touch target sizes specified (minimum 48x48dp for all interactive elements)
- [ ] Colour contrast requirements documented (WCAG AA: 4.5:1 for normal text, 3:1 for large text)
- [ ] Screen reader strategy for drag-and-drop (alternative tap-to-insert for VoiceOver/TalkBack)
- [ ] Semantic labels defined for calculator buttons and display
- [ ] Font scaling behaviour documented (what happens when user has large text enabled?)
- [ ] Accessibility spec documented in `docs/wireframes/`

**Status:** Not Started
**Assigned:** UI Designer
**Dependencies:** Task 2.1
**Priority:** Medium

**Implementation Notes:**
- Drag-and-drop is not accessible via screen readers — need an alternative interaction (e.g., tap a history item to insert it into the expression)
- Flutter's `Semantics` widget and `semanticsLabel` properties should be planned for all interactive elements
- Calculator buttons should announce their function (e.g., "plus", "equals", "clear")
- Display should announce the current expression and result
- Test with Android TalkBack and iOS VoiceOver (Sprint 008)

---

### 3. Implementation Scaffold

#### Task 3.1: Set Up Production Directory Structure

**Objective:** Create the production directory structure in `lib/` following the architecture document, and add Riverpod dependency.

**Acceptance Criteria:**
- [ ] `flutter_riverpod` added to `pubspec.yaml`
- [ ] `lib/` directory structure created per architecture document
- [ ] `ProviderScope` wrapping the app in `main.dart`
- [ ] Empty placeholder files created for key modules (with TODO comments)
- [ ] PoC code (`lib/poc/`) retained for reference but no longer the home screen
- [ ] `main.dart` updated to show a placeholder production screen (not the PoC)
- [ ] All existing tests still pass (update if needed for new home screen)
- [ ] `dart analyze` clean, `dart format` clean

**Status:** Not Started
**Assigned:** Senior Engineer
**Dependencies:** Task 1.1, Task 1.2 (need architecture and data model before creating structure)
**Priority:** High

**Implementation Notes:**
- Proposed directory structure (to be confirmed by architecture doc):
  ```
  lib/
  ├── main.dart
  ├── app.dart                    # NelliCalcApp widget
  ├── models/                     # Data classes (CalculatorState, HistoryEntry)
  ├── providers/                  # Riverpod providers
  ├── features/
  │   ├── calculator/             # Calculator display, button grid
  │   └── history/                # History list, draggable items
  ├── layout/                     # Responsive shell (LayoutBuilder switch)
  └── poc/                        # PoC code (retained for reference)
  ```
- This task is about scaffolding the structure, not implementing features — Sprint 003 does that
- Placeholder files should have a class stub and a `// TODO(sprint-003):` comment

---

#### Task 3.2: Create Data Model Classes

**Objective:** Implement the data model classes defined in Task 1.2 with unit tests.

**Acceptance Criteria:**
- [ ] `CalculatorState` class implemented in `lib/models/`
- [ ] `HistoryEntry` class implemented in `lib/models/`
- [ ] Both classes are immutable with `copyWith` methods
- [ ] Both classes have `==` and `hashCode` overrides (or use `Equatable`)
- [ ] Unit tests for both classes in `test/models/`
- [ ] `dart analyze` clean, `dart format` clean, `flutter test` all passing

**Status:** Not Started
**Assigned:** Senior Engineer
**Dependencies:** Task 1.2 (need data model specification)
**Priority:** High

**Implementation Notes:**
- Decide: manual `copyWith` + `Equatable` mixin, or `freezed` code generation?
  - Recommendation from state management evaluation: avoid code generation. Use `Equatable` for equality and manual `copyWith`.
- Keep models in `lib/models/` — they should have zero Flutter imports (pure Dart)
- `HistoryEntry` needs: `String id`, `double value`, `String expression`, `DateTime timestamp`
- `CalculatorState` needs: `String expression`, `String display`, `double? result`, `CalculatorError? error`
- Tests should cover: construction, copyWith, equality, hashCode

---

## Progress Log

Record handover notes, blockers, and status updates here in chronological order (newest first).

_No entries yet._

---

## Dependencies and Handovers

| Provider Task | Consumer Task | Status | Handover Completed | Notes |
|---------------|---------------|--------|-------------------|-------|
| Sprint 001 PoC | All tasks | Ready | Yes | PoC findings in Sprint 001 progress log |
| Task 1.1 | Task 1.2, 1.3 | Pending | No | Architecture needed before data model and engine interface |
| Task 1.1 | Task 2.1 | Pending | No | Architecture defines component boundaries for wireframes |
| Task 2.1 | Task 2.2 | Pending | No | Layout wireframes before interaction design |
| Task 2.1 | Task 2.3 | Pending | No | Layout wireframes before accessibility spec |
| Task 1.1, 1.2 | Task 3.1 | Pending | No | Architecture and data model before directory structure |
| Task 1.2 | Task 3.2 | Pending | No | Data model spec before implementation |
| All tasks | Sprint 003 | Pending | No | Architecture, data model, wireframes needed before engine implementation |

---

## Completion Criteria

Sprint is considered complete when:

- [ ] Architecture document created with layers, widget tree, provider graph, and directory structure
- [ ] Data model defined and implemented with unit tests
- [ ] Calculator engine interface designed
- [ ] UX wireframes for both orientations
- [ ] Drag-and-drop interaction model fully specified
- [ ] Accessibility requirements documented
- [ ] Production directory structure set up with Riverpod
- [ ] All tests passing
- [ ] No critical blockers remain
- [ ] Sprint 003 can begin implementation without ambiguity

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
**Archive Location:** `SPRINTS/archive/sprint-002-architecture.md`

_Move completed sprints to archive/ to minimise context loading for active work._
