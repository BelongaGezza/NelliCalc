# Sprint 001: Flutter Project Scaffold, PoC & CI/CD

**Status:** Completed
**Release:** R01 | **Phase:** P01
**Start:** 2026-02-09 | **Target End:** 2026-02-16

## Sprint Goal

Scaffold the Flutter project, validate drag-and-drop with a proof-of-concept, and establish CI/CD and development tooling.

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
| Senior Engineer | `.agents/senior-engineer.md` | Available | - | 1.1, 1.2, 3.1, 3.2, 4.1 | None |
| System Architect | `.agents/system-architect.md` | Available | - | 2.1, 2.2 | Task 1.1 |
| Researcher | `.agents/researcher.md` | Available | - | 2.3 | None |

**Available Persona Files:**
- System Architect: `.agents/system-architect.md`
- Senior Engineer: `.agents/senior-engineer.md`
- Junior Engineer: `.agents/junior-engineer.md`
- Security Specialist: `.agents/security-specialist.md`
- Documentation Specialist: `.agents/documentation-specialist.md`
- Researcher: `.agents/researcher.md`
- UI Designer: `.agents/ui-designer.md`

---

## Task List

### 1. Flutter Project Scaffold

#### Task 1.1: Create Flutter Project

**Objective:** Initialise a new Flutter project within the existing repository structure, targeting all required platforms (iOS, Android, macOS, Windows).

**Acceptance Criteria:**
- [x] Flutter project created in the repository root (src/ contents replaced by Flutter project structure)
- [x] Project builds and runs on at least one platform (Linux or Android emulator)
- [x] All target platforms enabled: iOS, Android, macOS, Windows, Linux
- [x] `pubspec.yaml` configured with project metadata (name: nelli_calc, description, version 0.1.0)
- [x] Default Flutter counter app replaced with a minimal NelliCalc placeholder screen
- [x] `.gitignore` updated for Flutter-specific entries
- [x] QUICK_START.md updated with Flutter development setup instructions

**Status:** Completed
**Assigned:** Senior Engineer
**Dependencies:** None
**Priority:** Critical

**Implementation Notes:**
- Use `flutter create` with appropriate flags for the target platforms
- Project name should be `nelli_calc` (Dart package naming convention — lowercase with underscores)
- Minimum SDK versions: iOS 12.0, Android API 21 (Android 5.0), macOS 10.14, Windows 10
- Ensure the Flutter project integrates cleanly with the existing repo structure (README, CLAUDE.md, RESEARCH/, SPRINTS/, etc. remain at root level)

---

#### Task 1.2: Configure Development Tooling

**Objective:** Set up linting, formatting, and static analysis for consistent code quality.

**Acceptance Criteria:**
- [x] `analysis_options.yaml` configured with strict linting rules (very_good_analysis 10.1.0)
- [x] `dart format` runs cleanly on all Dart files
- [x] `dart analyze` reports zero warnings/errors
- [x] `very_good_analysis` package added as dev dependency (replaced `flutter_lints`)
- [x] Pre-commit checks documented in CONTRIBUTING.md

**Status:** Completed
**Assigned:** Senior Engineer
**Dependencies:** Task 1.1
**Priority:** High

**Implementation Notes:**
- Consider using `very_good_analysis` for stricter linting (evaluate vs `flutter_lints`)
- Add `analysis_options.yaml` at project root
- Document the linting setup in CONTRIBUTING.md so future contributors know the standards

---

### 2. Drag-and-Drop Proof of Concept

#### Task 2.1: Implement Basic Drag-and-Drop PoC

**Objective:** Build a minimal proof-of-concept demonstrating that Flutter's drag-and-drop APIs meet NelliCalc's requirements — dragging a "result" item from a list into a "calculator display" target area.

**Acceptance Criteria:**
- [x] PoC screen with a list of mock "previous results" (42, 3.14159, 100, 7.5, 256, 0.001, 99.99, 1024)
- [x] Each result is draggable using `LongPressDraggable`
- [x] A "calculator display" area acts as a `DragTarget` that accepts dropped results
- [x] Dropped result appears in the calculator display area
- [x] Visual feedback during drag (elevated feedback widget, target highlights on hover with colour change + border)
- [x] Works on Linux desktop (build verified), tests pass in headless runner

**Status:** Completed
**Assigned:** System Architect
**Dependencies:** Task 1.1
**Priority:** Critical

**Implementation Notes:**
- This is a throwaway PoC to validate the approach — code quality matters less than validation
- Place PoC code in `lib/poc/` directory so it can be removed later
- Key widgets to evaluate: `Draggable`, `LongPressDraggable`, `DragTarget`
- Test both short tap-drag and long-press-drag to determine which feels more natural on touch
- Consider `LongPressDraggable` as the default — it avoids accidental drags when scrolling the history list

---

#### Task 2.2: Validate Responsive Layout PoC

**Objective:** Extend the PoC to demonstrate both landscape (side-by-side) and portrait (slide-over pane) layouts.

**Acceptance Criteria:**
- [x] Landscape mode: history panel displayed beside the calculator area (side-by-side Row layout, 60/40 split)
- [x] Portrait mode: history accessible via `DraggableScrollableSheet` bottom pane with drag handle and snap sizes
- [x] Drag-and-drop works in both orientations (tested)
- [x] Layout switches automatically based on `LayoutBuilder` constraints
- [x] Breakpoint documented: width >= 600dp = wide (landscape) layout

**Status:** Completed
**Assigned:** System Architect
**Dependencies:** Task 2.1
**Priority:** High

**Implementation Notes:**
- Use `LayoutBuilder` to switch layouts based on available width
- Consider `OrientationBuilder` as an alternative or complement
- The breakpoint decision will inform Sprint 002 architecture
- Evaluate `DraggableScrollableSheet` for the portrait slide-over — it provides a native-feeling pull-up pane
- Document findings and recommendations for Sprint 002

---

#### Task 2.3: Research State Management Options

**Objective:** Evaluate state management options for NelliCalc and recommend an approach for Sprint 002's architecture document.

**Acceptance Criteria:**
- [x] 4 state management options evaluated (Riverpod, BLoC, Provider, ValueNotifier)
- [x] Evaluation considers: simplicity, testability, boilerplate, scalability, community, NelliCalc fit
- [x] Recommendation documented in `RESEARCH/state-management-evaluation.md`
- [x] Recommendation considers NelliCalc's specific needs (simple state, testability, future growth)

**Status:** Completed
**Assigned:** Researcher
**Dependencies:** None
**Priority:** High

**Implementation Notes:**
- NelliCalc's state is relatively simple: current expression, result, and a list of history items
- Drag-and-drop state is managed by Flutter's built-in widgets, not the state management layer
- Overly complex state management (e.g., full BLoC for a calculator) should be flagged as unnecessary
- Consider whether `ValueNotifier`/`ChangeNotifier` with Provider is sufficient before recommending heavier solutions

---

### 3. CI/CD Setup

#### Task 3.1: Configure GitHub Actions CI

**Objective:** Set up a GitHub Actions workflow that runs on every push and pull request to validate code quality.

**Acceptance Criteria:**
- [x] `.github/workflows/ci.yml` created
- [x] Workflow runs `dart format --set-exit-if-changed .` to enforce formatting
- [x] Workflow runs `dart analyze --fatal-infos` to enforce zero warnings/infos
- [x] Workflow runs `flutter test` (9 tests currently passing)
- [x] Workflow triggers on push to `main` and on all pull requests
- [x] Workflow uses Flutter 3.38.9 stable with dependency caching

**Status:** Completed
**Assigned:** Senior Engineer
**Dependencies:** Task 1.2
**Priority:** High

**Implementation Notes:**
- Use the `subosito/flutter-action` GitHub Action for Flutter setup
- Pin to a specific Flutter stable version for reproducibility
- Keep the workflow simple — format, analyse, test. No deployment yet
- Consider caching pub dependencies for faster CI runs

---

#### Task 3.2: Add Build Verification

**Objective:** Add build verification steps to CI to catch compilation errors early.

**Acceptance Criteria:**
- [x] CI workflow includes `flutter build apk --debug` (Android build verification)
- [x] CI workflow includes `flutter build linux --debug` (Linux desktop build verification)
- [x] Build job runs after quality job (`needs: quality`)
- [x] Build failures block PR merges

**Status:** Completed
**Assigned:** Senior Engineer
**Dependencies:** Task 3.1
**Priority:** Medium

**Implementation Notes:**
- Only build debug variants in CI — release builds are unnecessary at this stage
- Linux build is used because GitHub Actions runners are Linux-based
- iOS and macOS builds require macOS runners (more expensive) — defer to Sprint 008
- Android build requires Java/Gradle setup — ensure the CI workflow includes this

---

### 4. Documentation Updates

#### Task 4.1: Update Project Documentation

**Objective:** Update project documentation to reflect the Flutter scaffold and development workflow.

**Acceptance Criteria:**
- [x] QUICK_START.md updated with Flutter SDK installation and setup steps
- [x] QUICK_START.md includes how to run the app, run tests, and check formatting
- [x] CONTRIBUTING.md updated with Flutter-specific code standards and pre-submit checks
- [x] CHANGELOG.md updated with comprehensive v0.1.0 entry
- [x] README.md updated with tech stack, platform status table (including Linux), responsive layout details

**Status:** Completed
**Assigned:** Senior Engineer
**Dependencies:** Task 1.1, Task 1.2
**Priority:** Medium

**Implementation Notes:**
- QUICK_START.md should cover: installing Flutter SDK, cloning the repo, running `flutter pub get`, running the app, running tests
- Keep setup instructions concise — link to official Flutter installation docs rather than duplicating them
- CONTRIBUTING.md should mention: format check, analyse, test cycle before submitting PRs

---

## Progress Log

Record handover notes, blockers, and status updates here in chronological order (newest first).

### 2026-02-09 - Senior Engineer

**Task:** Tasks 3.1, 3.2, 4.1: CI/CD and Documentation
**Status Update:** Completed
**Deliverables:**
- `.github/workflows/ci.yml` — Two-job pipeline:
  - `quality` job: format check, analysis (`--fatal-infos`), tests
  - `build` job (depends on quality): Android APK debug build, Linux desktop debug build
  - Flutter 3.38.9 pinned with dependency caching, concurrency groups for PR dedup
- `CHANGELOG.md` — Comprehensive v0.1.0 entry covering all Sprint 001 deliverables
- `README.md` — Updated with tech stack, Linux platform, responsive layout details
- `CONTRIBUTING.md` — Already updated in Task 1.2 with pre-submit checks

**Blockers:** None
**Next Steps:** Sprint 001 complete — proceed to Sprint 002

---

### 2026-02-09 - Researcher

**Task:** Task 2.3: Research State Management Options
**Status Update:** Completed
**Deliverables:**
- `RESEARCH/state-management-evaluation.md` — Evaluated 4 options:
  - Riverpod (recommended), BLoC (too heavy), Provider (adequate but superseded), ValueNotifier (too simple)
- Recommendation: **Riverpod without code generation** — right-sized for NelliCalc's simple state, excellent testability, no BuildContext dependency
- Proposed 3-provider structure: calculatorProvider, historyProvider, historyRepositoryProvider

**Blockers:** None
**Next Steps:** Implement Riverpod in Sprint 002 architecture

---

### 2026-02-09 - System Architect

**Task:** Task 2.2: Validate Responsive Layout PoC
**Status Update:** Completed
**Deliverables:**
- `lib/poc/responsive_poc.dart` — Responsive PoC screen with two layouts:
  - **Wide layout (>= 600dp):** Side-by-side Row with calculator display (flex 3) and history panel (flex 2) separated by a VerticalDivider
  - **Narrow layout (< 600dp):** Full-width calculator display with a `DraggableScrollableSheet` bottom pane for history. Sheet has drag handle, snap sizes (12%, 40%, 65%), and shadow
- `test/poc/responsive_poc_test.dart` — 5 tests covering:
  - Wide layout renders with visible history panel
  - Drag-and-drop works in wide layout
  - Narrow layout shows bottom sheet handle
  - Drag-and-drop works in narrow layout (sheet pulled up, then drag)
  - Layout switches correctly at the 600dp breakpoint
- `main.dart` updated to use `ResponsivePocScreen` as home

**Handover Notes:**
- **Breakpoint:** 600dp width. Aligns with Material Design compact/medium breakpoint. Phones in portrait = narrow; phones in landscape, tablets, desktops = wide.
- **`LayoutBuilder`** is the right tool — it responds to the actual widget constraints, not just screen size, which will matter if NelliCalc is ever embedded in a split-screen or multi-window context.
- **`DraggableScrollableSheet`** works well for the portrait slide-over pane. Snap sizes give it a polished feel. The 12% initial size shows just the handle + label, pulling up to 40% reveals a few items, 65% shows most of the list.
- **Drag across sheet boundary:** `LongPressDraggable` works correctly when dragging from the bottom sheet upward into the calculator display. Flutter's overlay system handles the drag feedback across widget boundaries without issue.
- **Key architecture recommendation for Sprint 002:** Keep the calculator display and history panel as independent widgets that receive callbacks. The responsive shell (`LayoutBuilder` switch) should be a separate layout widget that composes them. This separation makes it easy to test each component independently.

**Blockers:** None
**Next Steps:** Task 2.3 (state management research), Task 3.1 (CI/CD)

---

### 2026-02-09 - System Architect

**Task:** Task 2.1: Implement Basic Drag-and-Drop PoC
**Status Update:** Completed
**Deliverables:**
- `lib/poc/drag_drop_poc.dart` — Full PoC screen with:
  - 8 mock history items in a scrollable list
  - `LongPressDraggable<String>` on each item (avoids accidental drags when scrolling)
  - `DragTarget<String>` calculator display area
  - Visual feedback: elevated floating chip during drag, display highlights with colour change + thicker border on hover
  - Ghost (opacity 0.3) shown at original position while dragging
  - Reset button (FAB) to clear the display
- `test/poc/drag_drop_poc_test.dart` — 3 tests covering display, drag-drop interaction, and reset
- `test/widget_test.dart` — updated smoke test

**Handover Notes:**
- `LongPressDraggable` is the correct choice for NelliCalc — it avoids conflict with scrolling the history list
- `DragTarget.onWillAcceptWithDetails` / `onAcceptWithDetails` work well for hover feedback
- `AnimatedContainer` provides smooth visual transitions on hover state changes
- All verification passed: format, analyse, 4/4 tests, Linux debug build

**Blockers:** None
**Next Steps:** Task 2.2 (responsive layout PoC — landscape/portrait)

---

### 2026-02-09 - Senior Engineer

**Task:** Task 1.2: Configure Development Tooling
**Status Update:** Completed
**Deliverables:**
- Replaced `flutter_lints` with `very_good_analysis` 10.1.0 (stricter rules)
- `analysis_options.yaml` configured: includes very_good_analysis, excludes generated files, relaxes `public_member_api_docs` for PoC phase
- Fixed 2 lint issues: sorted pub dependencies, removed explicit type on closure parameter
- CONTRIBUTING.md updated with Flutter-specific code standards and pre-submit checks section

**Blockers:** None
**Next Steps:** Task 2.1 (drag-and-drop PoC)

---

### 2026-02-09 - Senior Engineer

**Task:** Task 1.1: Create Flutter Project
**Status Update:** Completed
**Deliverables:**
- Flutter 3.38.9 project scaffolded at repo root (nelli_calc)
- All 5 platforms enabled: iOS, Android, macOS, Windows, Linux
- Default counter app replaced with NelliCalc placeholder (calculator icon + tagline)
- Widget test updated and passing
- pubspec.yaml set to version 0.1.0 with clean metadata
- .gitignore updated with Flutter-specific entries, removed "(if selected)" placeholders
- QUICK_START.md rewritten with full Flutter development setup instructions
- Linux debug build verified: `build/linux/x64/debug/bundle/nelli_calc`
- `dart analyze` — zero issues, `dart format` — zero changes, `flutter test` — 1/1 passing
- Removed empty pre-Flutter `src/` and `tests/` directories (Flutter uses `lib/` and `test/`)

**Handover Notes:**
- Flutter SDK is at `/home/gerry/develop/flutter/bin/flutter` (not on default PATH — add to shell profile or use full path)
- Android SDK and Chrome not yet installed — Linux desktop is the current development target
- `flutter doctor` shows 2 issues (Android toolchain, Chrome) — not blocking for current work

**Blockers:** None
**Next Steps:** Task 1.2 (configure development tooling — linting and analysis_options.yaml)

---

## Dependencies and Handovers

| Provider Task | Consumer Task | Status | Handover Completed | Notes |
|---------------|---------------|--------|-------------------|-------|
| Task 1.1 | Task 1.2 | Ready | Yes | Scaffold complete, tooling can proceed |
| Task 1.1 | Task 2.1 | Ready | Yes | Scaffold complete, PoC can proceed |
| Task 1.2 | Task 3.1 | Ready | Yes | Linting config complete, CI can proceed |
| Task 2.1 | Task 2.2 | Ready | Yes | Drag-and-drop PoC complete, responsive layout can proceed |
| Task 3.1 | Task 3.2 | Complete | Yes | Build job included in same CI workflow |
| Task 1.1, 1.2 | Task 4.1 | Ready | Yes | Scaffold and tooling complete |
| Task 2.1, 2.2 | Sprint 002 | Ready | Yes | PoC findings documented in progress log |
| Task 2.3 | Sprint 002 | Ready | Yes | Riverpod (no codegen) recommended |

---

## Completion Criteria

Sprint is considered complete when:

- [x] Flutter project scaffolded and builds on at least one platform
- [x] Drag-and-drop PoC validates the core interaction model
- [x] Responsive layout PoC validates landscape/portrait approach
- [x] State management recommendation documented
- [x] GitHub Actions CI pipeline runs format, analyse, test, and build
- [x] All documentation updated
- [x] No critical blockers remain
- [x] PoC findings and recommendations documented for Sprint 002 handover

---

## Retrospective (Complete at Sprint End)

### What Went Well
- Flutter scaffold was clean and immediate — `flutter create` + merge into existing repo worked without issues
- `LongPressDraggable` was the right choice for drag-and-drop — avoids scroll conflicts, natural touch feel
- `DraggableScrollableSheet` with snap sizes provides a polished portrait-mode history pane
- `very_good_analysis` caught issues early (sorted deps, redundant types) — worth the stricter rules
- All 9 tests passed first time including drag-and-drop interaction tests
- PoC validated all key assumptions before committing to architecture

### What Could Improve
- Android SDK not installed on dev machine — could not manually test Android builds locally
- PoC code duplicates some widgets between `drag_drop_poc.dart` and `responsive_poc.dart` — acceptable for throwaway code but Sprint 002 should extract shared components

### Lessons Learnt
- `LongPressDraggable` > `Draggable` for lists — prevents accidental drags during scroll (potential LESSON-900)
- `LayoutBuilder` > `OrientationBuilder` for responsive layouts — responds to actual widget constraints, not just screen orientation (potential LESSON-401)
- `DraggableScrollableSheet` snap sizes create a polished bottom-pane UX with minimal code (potential LESSON-901)
- Cross-boundary drag (from sheet to main area) works natively in Flutter's overlay system — no special handling needed (potential LESSON-402)

### Action Items for Next Sprint
- Create `RESEARCH/architecture.md` with component design, data model, and widget tree
- Implement Riverpod (`flutter_riverpod`) for state management
- Design UX wireframes for calculator layout, button grid, and history interaction
- Remove PoC code (`lib/poc/`) once architecture is established
- Install Android SDK on dev machine for local testing

---

## Archival

**Archived Date:** TBD
**Archived By:** TBD
**Archive Location:** `SPRINTS/archive/sprint-001-flutter-scaffold.md`

_Move completed sprints to archive/ to minimise context loading for active work._
