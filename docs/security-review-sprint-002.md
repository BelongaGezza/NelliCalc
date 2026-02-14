# Security Review: NelliCalc (Post–Sprint 002)

**Reviewer:** Security Specialist  
**Scope:** Codebase and architecture as at completion of Sprint 002 (Architecture, Data Model & UX Design)  
**Date:** 2026-02-14  
**Reference:** [.agents/security-specialist.md](../.agents/security-specialist.md), OWASP Mobile Top 10

---

## Executive Summary

The project is in an early phase: production UI and calculator engine are not yet implemented, and persistence is stubbed. The architecture and existing code (models, repository interface, platform configuration) were reviewed for security posture and future risk.

**Verdict:** No critical or high-severity issues at this stage. A small number of medium- and low-severity items are documented with clear remediation for Sprint 003/004 and beyond.

---

## Scope of Review

| Area | Status at Sprint 002 | Reviewed |
|------|----------------------|----------|
| Architecture document | Complete | Yes |
| Data models (`CalculatorState`, `HistoryEntry`) | Implemented | Yes |
| Calculator engine | Stub only | Yes (design only) |
| Persistence (`LocalHistoryRepository`) | Stub only | Yes (interface + design) |
| Platform config (Android, iOS) | Default Flutter | Yes |
| Dependencies | `equatable`, `flutter_riverpod`, `uuid` | Yes |
| PoC code in `lib/poc/` | Retained, not home screen | Yes |

---

## Findings by Severity

### Medium

#### M1: Defensive parsing for `HistoryEntry.fromJson`

**Location:** `lib/models/history_entry.dart`  
**OWASP:** M2 (Insecure Data Storage) — robustness of stored data handling

**Issue:**  
`HistoryEntry.fromJson` assumes well-formed input. It uses direct casts (`as String`, `as num`) and `DateTime.parse`. Corrupted or tampered storage (e.g. when `shared_preferences` is used in Sprint 004) can cause uncaught exceptions during load and crash the app or leave history in a bad state.

**Remediation:**

- In the data layer (e.g. `LocalHistoryRepository.loadAll()`), call `fromJson` inside try/catch when decoding each list element.
- Either skip invalid entries and log, or return an empty list and log when the top-level decode fails.
- Optionally add a safe factory, e.g. `HistoryEntry.tryFromJson(Map<String, dynamic>? json)` that returns `HistoryEntry?` and validates types and presence of required keys before constructing.

**Target:** Before or during Sprint 004 (when persistence is implemented).

---

### Low

#### L1: Expression input validation (Sprint 003)

**Location:** Architecture §7 (Calculator Engine), future `CalculatorNotifier.insertValue(String)`  
**OWASP:** M7 (Client Code Quality), input validation

**Issue:**  
Drag-and-drop currently will pass `HistoryEntry.displayValue` (controlled). If later the app accepts pasted or externally supplied text (e.g. intents), the engine must accept only allowed characters (digits, `+`, `-`, `*`, `/`, `.`, `(`, `)`, whitespace) and reject or sanitise the rest to avoid malformed expressions or unexpected behaviour.

**Remediation:**

- In Sprint 003, implement the engine to accept only the character set above and treat any other character as invalid (e.g. throw `CalculatorError` with `malformedExpression`).
- If a separate “insert value” or paste path is added, validate or sanitise the string (e.g. allow only numeric and one optional decimal point) before passing to the engine.

---

#### L2: User-facing error messages

**Location:** `lib/engine/calculator_error.dart`, architecture §7.6  
**OWASP:** M7 (Client Code Quality)

**Issue:**  
`CalculatorError.message` is intended for user display. If implementation ever includes stack traces, file paths, or internal details in `message`, it could leak information.

**Remediation:**

- Keep `message` as short, generic, user-facing text (e.g. “Cannot divide by zero”, “Invalid expression”).
- Do not assign exception messages or stack traces to `CalculatorError.message`; log those separately in development only.

---

#### L3: Dependency audit in CI

**Location:** CI pipeline, `pubspec.yaml`  
**OWASP:** M9 (Reverse Engineering) / supply chain

**Issue:**  
There is no automated check for known vulnerable or outdated dependencies.

**Remediation:**

- Add a CI step that runs `dart pub outdated` (and optionally a vulnerability check when available for the Dart ecosystem).
- Review and update dependencies periodically; address any known vulnerabilities before release.

---

#### L4: PoC code in release bundle

**Location:** `lib/poc/`  
**OWASP:** M10 (Extraneous Functionality)

**Issue:**  
PoC screens are still under `lib/` and will be included in the release bundle. They are not the home screen but add surface and are not part of the product.

**Remediation:**

- Before release (e.g. R04), either remove `lib/poc/` or move PoC code behind a build flag / debug-only entry so it is not shipped in production builds.

---

## Checklist Summary

| # | Item | Status | Notes |
|---|------|--------|--------|
| 1 | Data storage secure? | N/A | Persistence not implemented; design uses app-private storage. |
| 2 | Inputs validated/sanitised? | Partial | Engine not implemented; architecture specifies validation in engine (Sprint 003). |
| 3 | Dependencies up to date, no known vulnerabilities? | Pass | No known issues; add CI audit (L3). |
| 4 | Only necessary permissions requested? | Pass | Android: launcher + documented PROCESS_TEXT query. iOS: no extra permissions. |
| 5 | Platform security config appropriate? | Pass | Default Flutter config; no network, no cleartext. |
| 6 | Error handling avoids leaking sensitive data? | Pass | Errors as data; recommend keeping messages user-safe (L2). |

---

## OWASP Mobile Top 10 (Brief)

| ID | Topic | Relevance at Sprint 002 |
|----|--------|--------------------------|
| M1 | Improper Platform Usage | Minimal platform-specific code; manifests/plist standard. |
| M2 | Insecure Data Storage | No sensitive data yet; history will be app-private; add defensive parsing (M1). |
| M3 | Insecure Communication | No network usage. |
| M4 | Insecure Authentication | N/A (no auth). |
| M5 | Insufficient Cryptography | N/A at this stage. |
| M6 | Insecure Authorization | N/A. |
| M7 | Client Code Quality | Layering and separation good; input validation in Sprint 003 (L1). |
| M8 | Code Tampering | Standard Flutter build. |
| M9 | Reverse Engineering | No extra controls; dependency audit recommended (L3). |
| M10 | Extraneous Functionality | PoC in bundle (L4); no debug-only backdoors observed. |

---

## Positive Notes

- **Layered architecture:** Domain has no Flutter imports; engine is pure Dart and testable without UI. Clear separation supports security review and containment of logic.
- **Minimal permissions:** No network, storage, or dangerous permissions; Android only declares the documented `queries` for PROCESS_TEXT.
- **Errors as data:** `CalculatorError` and state-based error handling avoid unhandled exceptions and keep error handling in one place.
- **Repository abstraction:** Persistence behind `HistoryRepository` allows swapping implementation and testing without touching domain.

---

## Recommendations for Next Sprints

1. **Sprint 003:** Implement engine with strict expression character set; keep user-facing error messages generic (L1, L2).
2. **Sprint 004:** Implement persistence with defensive JSON parsing and safe `HistoryEntry` loading (M1); confirm history storage remains app-private.
3. **CI:** Add dependency audit step (L3).
4. **Pre-release:** Resolve or isolate PoC code in release builds (L4).

---

## Lessons Learnt

Security-related lessons from this review are recorded in [LESSONS_LEARNED.md](../LESSONS_LEARNED.md) under the 700–799 range (Security & Safety). Reference them in Sprint 004 and security follow-ups.

---

_Last updated: 2026-02-14_
