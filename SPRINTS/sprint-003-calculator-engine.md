# Sprint 003: Calculator Engine + Unit Tests

**Status:** Planning
**Release:** R02 | **Phase:** P02
**Start:** 2026-02-14 | **Target End:** 2026-02-21

## Sprint Goal

Implement the calculator engine (expression parsing, evaluation, error handling) and the CalculatorNotifier, with comprehensive unit tests. After this sprint, expressions can be evaluated programmatically end-to-end.

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
| Senior Engineer | `.agents/senior-engineer.md` | Available | - | 1.1, 1.2, 2.1, 2.2, 3.1 | None |
| Junior Engineer | `.agents/junior-engineer.md` | Available | - | 1.3, 2.3 | Task 1.1, 2.1 |

**Available Persona Files:**
- System Architect: `.agents/system-architect.md`
- Senior Engineer: `.agents/senior-engineer.md`
- Junior Engineer: `.agents/junior-engineer.md`
- Security Specialist: `.agents/security-specialist.md`
- Documentation Specialist: `.agents/documentation-specialist.md`
- Researcher: `.agents/researcher.md`
- UI Designer: `.agents/ui-designer.md`

---

## Context from Sprint 002

Sprint 002 delivered the complete architecture and data model:

- **Architecture document:** `RESEARCH/architecture.md` — layered design (presentation/domain/data), widget tree, Riverpod provider graph
- **Calculator engine interface:** Section 7 of architecture doc — `CalculatorEngine.evaluate(String) → double`, custom recursive descent parser, BODMAS/PEMDAS, `CalculatorError` thrown on failure
- **Data model classes implemented:** `CalculatorState`, `HistoryEntry`, `CalculatorError` with Equatable, copyWith, serialisation — all in `lib/models/` and `lib/engine/`
- **Production scaffold:** Directory structure in `lib/` with placeholder files and `ProviderScope` wrapping the app
- **UX wireframes:** `docs/wireframes/` — calculator layout, drag-drop interaction, accessibility

### Key Architecture Decisions (reference)

- **Expression representation:** String-based (engine parses on evaluate, not on each keystroke)
- **Parser approach:** Custom recursive descent (zero external dependencies)
- **Precision:** `double` (IEEE 754), display formatting rounds to 10 significant digits
- **Error handling:** Engine throws `CalculatorError`; `CalculatorNotifier` catches and stores in `CalculatorState.error`
- **Engine is stateless:** Receives expression string, returns `double` — no mutable state between calls
- **Engine is pure Dart:** Zero Flutter imports, testable with `package:test`

---

## Task List

### 1. Calculator Engine

#### Task 1.1: Implement Recursive Descent Parser

**Objective:** Implement `CalculatorEngine.evaluate(String)` in `lib/engine/calculator_engine.dart` using a recursive descent parser that supports the four basic operators, parentheses, decimal numbers, and unary minus.

**Acceptance Criteria:**
- [ ] `CalculatorEngine.evaluate(String)` implemented
- [ ] Grammar: `expression → term (('+' | '-') term)*`
- [ ] Grammar: `term → unary (('*' | '/') unary)*`
- [ ] Grammar: `unary → '-' unary | primary`
- [ ] Grammar: `primary → NUMBER | '(' expression ')'`
- [ ] Whitespace ignored during parsing
- [ ] Returns `double` result
- [ ] Pure Dart — zero Flutter imports in `lib/engine/`
- [ ] `dart analyze` clean, `dart format` clean

**Status:** Not Started
**Assigned:** Senior Engineer
**Dependencies:** None (data model and error types already implemented in Sprint 002)
**Priority:** Critical

**Implementation Notes:**
- Architecture doc Section 7.5 has the grammar and implementation sketch
- The stub file `lib/engine/calculator_engine.dart` already exists — replace the TODO with the implementation
- Use a cursor-based approach (`_source`, `_pos` instance variables) as described in the architecture doc
- The engine class is constructed once and reused; `evaluate()` resets internal state on each call

---

#### Task 1.2: Implement Engine Error Handling

**Objective:** Ensure the engine throws appropriate `CalculatorError` for all failure modes.

**Acceptance Criteria:**
- [ ] Empty/blank expression → `CalculatorError(type: malformedExpression)`
- [ ] Malformed expression (e.g., `3 + + 4`, `3 +`, unmatched parens) → `CalculatorError(type: malformedExpression)`
- [ ] Division by zero → `CalculatorError(type: divisionByZero)`
- [ ] Overflow (result is `infinity` or `NaN`) → `CalculatorError(type: overflow)`
- [ ] Unexpected characters → `CalculatorError(type: malformedExpression)`
- [ ] Result validation via `_validateResult()` as per architecture doc
- [ ] No unhandled exceptions escape `evaluate()` — wrap unexpected errors in `CalculatorError(type: unknownError)`

**Status:** Not Started
**Assigned:** Senior Engineer
**Dependencies:** Task 1.1
**Priority:** Critical

**Implementation Notes:**
- Architecture doc Section 7.6 defines error types, flow, and edge cases
- Division by zero check: when parsing a `/` term, check if the divisor is zero before dividing
- Overflow check: after evaluation, check `result.isInfinite` and `result.isNaN`
- The `CalculatorError` class already exists in `lib/engine/calculator_error.dart` (implemented in Sprint 002)

---

#### Task 1.3: Engine Unit Tests

**Objective:** Comprehensive unit tests for the calculator engine covering arithmetic, precedence, edge cases, and errors.

**Acceptance Criteria:**
- [ ] Tests in `test/engine/calculator_engine_test.dart`
- [ ] Basic arithmetic: `3 + 4`, `10 - 3`, `6 * 7`, `15 / 3`
- [ ] Decimal numbers: `3.14 + 1`, `0.1 + 0.2` (precision check)
- [ ] Operator precedence: `2 + 3 * 4 = 14`, `(2 + 3) * 4 = 20`
- [ ] Left-to-right associativity: `10 / 2 * 3 = 15`, `10 - 2 + 3 = 11`
- [ ] Unary minus: `-5 + 3`, `-(2 + 3)`, `2 * -3`
- [ ] Nested parentheses: `((2 + 3) * (4 - 1))`
- [ ] Whitespace handling: `  2 + 3  `, `2+3` (no spaces)
- [ ] Error cases: empty string, `3 + + 4`, `3 +`, `10 / 0`, unmatched `(`, `)`
- [ ] Large numbers and edge cases
- [ ] All tests passing, `dart analyze` clean

**Status:** Not Started
**Assigned:** Junior Engineer
**Dependencies:** Task 1.1, 1.2
**Priority:** Critical

**Implementation Notes:**
- Architecture doc Section 7.4 has a table of precedence examples — use these as test cases
- Architecture doc Section 7.7 defines display formatting — but that is the notifier's responsibility, not the engine's; engine tests should check raw `double` values
- Test with `package:flutter_test` (project convention)
- Organise tests in groups: basic arithmetic, precedence, unary minus, parentheses, errors

---

### 2. Calculator Notifier

#### Task 2.1: Implement CalculatorNotifier

**Objective:** Implement `CalculatorNotifier` in `lib/providers/calculator_provider.dart` — the Riverpod StateNotifier that manages `CalculatorState` and delegates evaluation to `CalculatorEngine`.

**Acceptance Criteria:**
- [ ] `CalculatorNotifier extends StateNotifier<CalculatorState>` implemented
- [ ] `calculatorProvider` defined as `StateNotifierProvider<CalculatorNotifier, CalculatorState>`
- [ ] Input methods: `inputDigit(String)`, `inputOperator(String)`, `inputDecimal()`, `inputParenthesis(String)`
- [ ] Action methods: `evaluate()`, `clear()`, `backspace()`
- [ ] Drag-and-drop method: `insertValue(String)`
- [ ] `evaluate()` delegates to `CalculatorEngine`, catches `CalculatorError`, updates state
- [ ] `clear()` resets to default `CalculatorState`
- [ ] Engine injected via constructor (testable without Riverpod overrides)
- [ ] `dart analyze` clean, `dart format` clean

**Status:** Not Started
**Assigned:** Senior Engineer
**Dependencies:** Task 1.1 (needs working engine)
**Priority:** High

**Implementation Notes:**
- Architecture doc Section 5 defines the notifier interface and interaction flows
- Architecture doc Section 7.7 defines `formatResult()` — implement as a private helper or top-level function in the same file
- The `display` field should update as the user types (mirror the `expression` for now; can be refined in later sprints)
- On `evaluate()`: if expression is empty, return early (no error, no state change)
- On `backspace()`: remove the last character from `expression`; if expression becomes empty, reset display to `'0'`
- `insertValue()`: append the value string to the current expression (per architecture doc Section 5, drag-and-drop interaction flow)

---

#### Task 2.2: Implement Result Formatting

**Objective:** Implement the `formatResult()` function that converts a raw `double` to a clean display string.

**Acceptance Criteria:**
- [ ] Trailing zeros stripped: `4.0` → `"4"`, `3.10` → `"3.1"`
- [ ] Maximum 10 significant digits
- [ ] Floating-point correction: `0.1 + 0.2` displays as `"0.3"`
- [ ] Integer results display without decimal: `15.0` → `"15"`
- [ ] Negative results handled correctly
- [ ] Function located in or alongside `calculator_provider.dart`

**Status:** Not Started
**Assigned:** Senior Engineer
**Dependencies:** Task 2.1
**Priority:** High

**Implementation Notes:**
- Architecture doc Section 7.7 has the formatting rules and implementation sketch
- Use `value.toStringAsPrecision(10)` then strip trailing zeros
- This can be a top-level function or a static method — keep it testable

---

#### Task 2.3: Notifier Unit Tests

**Objective:** Unit tests for `CalculatorNotifier` covering input methods, evaluation, error handling, and state transitions.

**Acceptance Criteria:**
- [ ] Tests in `test/providers/calculator_provider_test.dart`
- [ ] Input digit appends to expression
- [ ] Input operator appends to expression
- [ ] Input decimal appends to expression
- [ ] Input parenthesis appends to expression
- [ ] Evaluate produces correct result and display
- [ ] Evaluate with error sets `state.error` and clears `state.result`
- [ ] Clear resets to default state
- [ ] Backspace removes last character
- [ ] Backspace on empty expression keeps display as `'0'`
- [ ] `insertValue()` appends to expression
- [ ] `formatResult()` tested for trailing zeros, precision, negatives
- [ ] All tests passing, `dart analyze` clean

**Status:** Not Started
**Assigned:** Junior Engineer
**Dependencies:** Task 2.1, 2.2
**Priority:** High

**Implementation Notes:**
- Construct `CalculatorNotifier` directly (no need for `ProviderContainer` for basic tests)
- Inject a real `CalculatorEngine` — the engine is pure and fast, no need to mock it
- Test state transitions: construct → inputDigit('5') → verify state.expression == '5'
- Test evaluate flow: input '2+3' → evaluate → verify state.result == 5.0, state.display == '5'

---

### 3. Integration

#### Task 3.1: Verify End-to-End Provider Wiring

**Objective:** Ensure `calculatorProvider` works correctly within a Riverpod `ProviderContainer`, verifying that the full provider graph is wired up.

**Acceptance Criteria:**
- [ ] Integration test in `test/providers/calculator_integration_test.dart`
- [ ] Create `ProviderContainer`, read `calculatorProvider`
- [ ] Verify initial state is default `CalculatorState`
- [ ] Perform a full calculation via the notifier and verify the result
- [ ] All existing tests still pass (54 + new tests)
- [ ] `dart analyze` clean, `dart format` clean, `flutter test` all passing

**Status:** Not Started
**Assigned:** Senior Engineer
**Dependencies:** Task 2.1
**Priority:** Medium

**Implementation Notes:**
- This is a lightweight integration check, not a widget test
- Uses `ProviderContainer` from `package:flutter_riverpod` to test the provider in isolation
- Confirms that `calculatorProvider` can be read and its notifier invoked without errors

---

## Progress Log

Record handover notes, blockers, and status updates here in chronological order (newest first).

_No entries yet._

---

## Dependencies and Handovers

| Provider Task | Consumer Task | Status | Handover Completed | Notes |
|---------------|---------------|--------|-------------------|-------|
| Sprint 002 (all) | All tasks | Ready | Yes | Architecture, data model, wireframes complete |
| Task 1.1 | Task 1.2 | Pending | No | Parser needed before error handling refinement |
| Task 1.1, 1.2 | Task 1.3 | Pending | No | Engine implementation needed before engine tests |
| Task 1.1 | Task 2.1 | Pending | No | Working engine needed before notifier can delegate |
| Task 2.1 | Task 2.2 | Pending | No | Notifier needed before formatting integration |
| Task 2.1, 2.2 | Task 2.3 | Pending | No | Notifier + formatting needed before notifier tests |
| Task 2.1 | Task 3.1 | Pending | No | Notifier needed for integration test |
| All tasks | Sprint 004 | Pending | No | Calculator engine needed before history + persistence |

---

## Completion Criteria

Sprint is considered complete when:

- [ ] Calculator engine evaluates expressions with correct BODMAS/PEMDAS precedence
- [ ] All error cases handled (division by zero, malformed, overflow)
- [ ] CalculatorNotifier manages state transitions for all input methods
- [ ] Result formatting strips trailing zeros and corrects floating-point artefacts
- [ ] Comprehensive unit tests for engine, notifier, and formatting
- [ ] Provider integration test passes
- [ ] All tests passing (existing + new)
- [ ] `dart analyze` clean, `dart format` clean
- [ ] No critical blockers remain
- [ ] Sprint 004 can begin history + persistence without ambiguity

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
**Archive Location:** `SPRINTS/archive/sprint-003-calculator-engine.md`

_Move completed sprints to archive/ to minimise context loading for active work._
