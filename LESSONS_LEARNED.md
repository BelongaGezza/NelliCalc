# Lessons Learnt

**Purpose:** Capture issues, gotchas, and solutions to prevent repeated mistakes and build institutional knowledge.

## Lesson ID Ranges (by Category)

- LESSON-001 to 099: Build & Tooling Issues
- LESSON-100 to 199: Language-Specific Gotchas (depends on tech stack)
- LESSON-200 to 299: Dependencies & Packages
- LESSON-300 to 399: Testing & CI/CD
- LESSON-400 to 499: Architecture & Design
- LESSON-500 to 599: AI Agent Coordination
- LESSON-600 to 699: Performance & Optimisation
- LESSON-700 to 799: Security & Safety
- LESSON-800 to 899: Documentation & Process
- LESSON-900 to 999: Project-Specific

## Lesson Template

### LESSON-NNN: Brief Title

**Category:** [Build/Language/Dependencies/Testing/etc.]
**Date:** YYYY-MM-DD
**Severity:** [Critical/High/Medium/Low]
**Sprint:** sprint-NNN-description

**Problem:**
Clear description of the issue encountered.

**Solution:**
How it was resolved.

**Prevention:**
How to avoid this in future. What to check for during reviews.

**Related Files:** [file paths if applicable]
**Cross-References:** [Related lesson IDs, issues, or documentation]

---

## Build & Tooling (001-099)

_No lessons recorded yet. This section will populate as issues are encountered._

## Language-Specific Gotchas (100-199)

_Reserve for language-specific issues once tech stack is selected (e.g., Dart/Flutter, TypeScript/React Native, etc.)._

## Dependencies & Packages (200-299)

_Reserve for dependency conflicts, version issues, breaking changes in ecosystem._

## Testing & CI/CD (300-399)

_Reserve for test failures, CI pipeline issues, coverage problems._

## Architecture & Design (400-499)

_Reserve for design pattern issues, refactoring lessons, API design._

## AI Agent Coordination (500-599)

_Reserve for agent handover issues, role conflicts, tasking problems._

## Performance & Optimisation (600-699)

_Reserve for performance issues, optimisation techniques, mobile-specific considerations._

## Security & Safety (700-799)

### LESSON-700: Defensive parsing for persisted JSON (HistoryEntry.fromJson)

**Category:** Security & Safety  
**Date:** 2026-02-14  
**Severity:** Medium  
**Sprint:** sprint-002-architecture (security review)

**Problem:**  
`HistoryEntry.fromJson` uses direct casts and `DateTime.parse` without validation. When persistence is implemented (Sprint 004), corrupted or tampered storage can cause uncaught exceptions on load and crash the app or leave history in a bad state.

**Solution:**  
In the data layer (e.g. `LocalHistoryRepository.loadAll()`), decode the stored list in a try/catch. When iterating list elements, call a safe parser (e.g. try/catch per element or a `HistoryEntry.tryFromJson` that returns `null` on invalid input). Skip invalid entries and log; do not let a single bad entry crash the app.

**Prevention:**  
For any model that deserialises from storage or network, use defensive parsing: validate types and required keys, handle null/missing fields, and catch parse exceptions at the boundary. See security review: `docs/security-review-sprint-002.md`.

**Related Files:** `lib/models/history_entry.dart`, `lib/data/local_history_repository.dart`  
**Cross-References:** LESSON-701, RESEARCH/architecture.md §6.6

---

### LESSON-701: Security review checklist for future sprints

**Category:** Security & Safety  
**Date:** 2026-02-14  
**Severity:** Low  
**Sprint:** sprint-002-architecture (security review)

**Problem:**  
Several low-severity items should be addressed in later sprints to maintain security posture: expression input validation, user-facing error messages, dependency audit in CI, and PoC code in the release bundle.

**Solution:**  
- **Sprint 003:** Engine must accept only allowed expression characters (digits, `+`, `-`, `*`, `/`, `.`, `(`, `)`, whitespace); keep `CalculatorError.message` user-safe (no stack traces or paths).  
- **CI:** Add a step that runs `dart pub outdated` (and vulnerability checks when available).  
- **Pre-release:** Remove or guard `lib/poc/` so it is not included in production builds.

**Prevention:**  
Re-run the Security Specialist checklist (data storage, input validation, dependencies, permissions, platform config, error handling) at the end of each release phase. Reference `docs/security-review-sprint-002.md` and `.agents/security-specialist.md`.

**Related Files:** `lib/engine/calculator_engine.dart`, `lib/engine/calculator_error.dart`, `lib/poc/`, CI workflow  
**Cross-References:** LESSON-700, OWASP Mobile Top 10

## Documentation & Process (800-899)

_Reserve for documentation issues, process improvements, workflow optimisations._

## Project-Specific (900-999)

_Reserve for NelliCalc-specific issues, calculator logic, UI/UX patterns, platform-specific considerations._

---

_This file grows as the project learns. Reference lessons in code comments, PRs, and sprints._
