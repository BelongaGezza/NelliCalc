# Project Status

**Current Release:** R02 (Core Development)
**Current Phase:** P02 (Core Development)
**Current Sprint:** sprint-003-calculator-engine
**Tech Stack:** Flutter (Dart)

## Release Roadmap

| Release | Focus | Status |
|---------|-------|--------|
| R00 | Repository setup and configuration | COMPLETE |
| R01 | Tech stack, architecture, and project foundation | COMPLETE |
| R02 | Core calculator engine and data persistence | CURRENT |
| R03 | UI/UX implementation (responsive, touch, drag-and-drop) | Planned |
| R04 | Platform optimisation, testing, and release | Planned |

## Phase Breakdown

### R00-P00: Initial Setup (COMPLETE)

- Sprint 000: Repository structure and documentation setup — COMPLETE (archived)

### R01-P01: Foundation

- Sprint 001: Flutter project scaffold, drag-and-drop PoC, CI/CD setup — COMPLETE
- Sprint 002: Architecture document, data model, UX wireframes and interaction design — COMPLETE

### R02-P02: Core Development

- Sprint 003: Calculator engine (expression parsing, evaluation, error handling) + unit tests
- Sprint 004: Result history and data persistence (local storage) + tests

### D-Track: Parallel Design Track (runs alongside R02)

- Sprint D01: Visual design prototype — theme, styled calculator UI, feedback capture
- Sprint D02: Design iteration based on feedback (if needed)

The design track runs independently of the engine sprints. It produces a non-functional but fully styled UI prototype for early feedback. The design track and engine track converge at R03 when the styled UI is wired to the real engine.

### R03-P03: UI/UX Integration (design + engine converge)

- Sprint 005: Integrate styled UI with calculator engine (responsive layout + real state)
- Sprint 006: Drag-and-drop interactions, touch gestures, haptic feedback + tests
- Sprint 007: UI polish, accessibility (WCAG AA), theming (light/dark)

### R04-P04: Platform & Release

- Sprint 008: Cross-platform testing and platform-specific optimisations
- Sprint 009: Integration testing, documentation, app store preparation

## Sprint Summary

| Sprint | Track | Description | Status |
|--------|-------|-------------|--------|
| 000 | R00 | Repository setup | Complete |
| 001 | R01 | Flutter scaffold + PoC + CI/CD | Complete |
| 002 | R01 | Architecture + data model + UX design | Complete |
| 003 | R02 | Calculator engine + tests | Current |
| 004 | R02 | Result history + persistence + tests | Pending |
| D01 | Design | Visual prototype + theme + feedback | Pending |
| D02 | Design | Design iteration (if needed) | Planned |
| 005 | R03 | Integrate styled UI + engine | Pending |
| 006 | R03 | Drag-and-drop + touch interactions | Pending |
| 007 | R03 | UI polish + accessibility + theming | Pending |
| 008 | R04 | Cross-platform testing + optimisations | Pending |
| 009 | R04 | Integration testing + docs + release prep | Pending |

## Parallel Track Schedule

```
Sprint 002  ──────────────────►  (architecture)
                                  │
                 ┌────────────────┤
                 ▼                ▼
Sprint 003 ─────────►   Sprint D01 ─────────►  (engine + design in parallel)
Sprint 004 ─────────►   Sprint D02 ─────────►  (engine + design iterate)
                 │                │
                 └───────┬────────┘
                         ▼
                  Sprint 005  (converge: styled UI + working engine)
```

## Key Decisions

| Decision | Date | Outcome | Reference |
|----------|------|---------|-----------|
| Tech stack | 2026-02-09 | Flutter (Dart) | [tech-stack-evaluation.md](RESEARCH/tech-stack-evaluation.md) |
| State management | 2026-02-09 | Riverpod (no codegen) | [state-management-evaluation.md](RESEARCH/state-management-evaluation.md) |
| Responsive breakpoint | 2026-02-09 | 600dp (wide/narrow) | Sprint 001 PoC |
| UI feedback approach | 2026-02-09 | Parallel design track + Linux screenshots | Team Leader review |
| Licensing | 2026-02-09 | Dual MIT/Apache-2.0 | Sprint 000 |
| Architecture | 2026-02-11 | Three-layer (presentation/domain/data) + Riverpod | [architecture.md](RESEARCH/architecture.md) |
| Persistence | 2026-02-11 | shared_preferences (JSON array) | [architecture.md](RESEARCH/architecture.md) |
| Calculator engine | 2026-02-11 | Custom recursive descent parser, double precision | [architecture.md](RESEARCH/architecture.md) |

## Design Principles

- **Touch-first**: Primary platform is handheld touchscreen phones
- **Responsive from day one**: Landscape and portrait layouts designed upfront, not retrofitted
- **Test as you go**: Unit tests required from Sprint 003 onwards; no deferred testing phase
- **Accessibility built-in**: WCAG AA compliance, adequate touch targets (48x48dp minimum)
- **Simple architecture**: Prefer the simplest solution that meets requirements
- **Design early, iterate fast**: Visual prototype before engine implementation; feedback via Linux desktop + screenshots

## Quick Links

- Active Sprint: [SPRINTS/sprint-003-calculator-engine.md](SPRINTS/sprint-003-calculator-engine.md)
- Design Track: [SPRINTS/sprint-D01-visual-prototype.md](SPRINTS/sprint-D01-visual-prototype.md) (pending)
- Archived Sprints: [SPRINTS/archive/](SPRINTS/archive/)
- Lessons Learnt: [LESSONS_LEARNED.md](LESSONS_LEARNED.md)
- Research Docs: [RESEARCH/](RESEARCH/)
- Tech Stack Decision: [RESEARCH/tech-stack-evaluation.md](RESEARCH/tech-stack-evaluation.md)

## Naming Conventions

- Releases: R00, R01, R02...
- Phases: P00, P01, P02...
- Sprints: sprint-NNN-description.md (numbered) or sprint-DNN-description.md (design track)
- Lessons: LESSON-NNN (category-based ranges)

---

_Last updated: 2026-02-14_
