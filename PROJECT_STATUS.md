# Project Status

**Current Release:** R01 (Foundation)
**Current Phase:** P01 (Tech Stack & Architecture)
**Current Sprint:** sprint-002-architecture
**Tech Stack:** Flutter (Dart)

## Release Roadmap

| Release | Focus | Status |
|---------|-------|--------|
| R00 | Repository setup and configuration | COMPLETE |
| R01 | Tech stack, architecture, and project foundation | CURRENT |
| R02 | Core calculator engine and data persistence | Planned |
| R03 | UI/UX implementation (responsive, touch, drag-and-drop) | Planned |
| R04 | Platform optimisation, testing, and release | Planned |

## Phase Breakdown

### R00-P00: Initial Setup (COMPLETE)

- Sprint 000: Repository structure and documentation setup — COMPLETE (archived)

### R01-P01: Foundation

- Sprint 001: Flutter project scaffold, drag-and-drop PoC, CI/CD setup
- Sprint 002: Architecture document, data model, UX wireframes and interaction design

### R02-P02: Core Development

- Sprint 003: Calculator engine (expression parsing, evaluation, error handling) + unit tests
- Sprint 004: Result history and data persistence (local storage) + tests

### R03-P03: UI/UX Development

- Sprint 005: Core UI layout — responsive from the start (landscape side panel, portrait slide-over)
- Sprint 006: Drag-and-drop interactions, touch gestures, haptic feedback + tests
- Sprint 007: UI polish, accessibility (WCAG AA), theming (light/dark)

### R04-P04: Platform & Release

- Sprint 008: Cross-platform testing and platform-specific optimisations
- Sprint 009: Integration testing, documentation, app store preparation

## Sprint Summary

| Sprint | Release | Description | Status |
|--------|---------|-------------|--------|
| 000 | R00 | Repository setup | Complete |
| 001 | R01 | Flutter scaffold + PoC + CI/CD | Complete |
| 002 | R01 | Architecture + data model + UX design | Pending |
| 003 | R02 | Calculator engine + tests | Pending |
| 004 | R02 | Result history + persistence + tests | Pending |
| 005 | R03 | Core responsive UI layout | Pending |
| 006 | R03 | Drag-and-drop + touch interactions | Pending |
| 007 | R03 | UI polish + accessibility + theming | Pending |
| 008 | R04 | Cross-platform testing + optimisations | Pending |
| 009 | R04 | Integration testing + docs + release prep | Pending |

## Key Decisions

| Decision | Date | Outcome | Reference |
|----------|------|---------|-----------|
| Tech stack | 2026-02-09 | Flutter (Dart) | [tech-stack-evaluation.md](RESEARCH/tech-stack-evaluation.md) |
| State management | 2026-02-09 | Riverpod (no codegen) | [state-management-evaluation.md](RESEARCH/state-management-evaluation.md) |
| Responsive breakpoint | 2026-02-09 | 600dp (wide/narrow) | Sprint 001 PoC |
| Licensing | 2026-02-09 | Dual MIT/Apache-2.0 | Sprint 000 |

## Design Principles

- **Touch-first**: Primary platform is handheld touchscreen phones
- **Responsive from day one**: Landscape and portrait layouts designed upfront, not retrofitted
- **Test as you go**: Unit tests required from Sprint 003 onwards; no deferred testing phase
- **Accessibility built-in**: WCAG AA compliance, adequate touch targets (48x48dp minimum)
- **Simple architecture**: Prefer the simplest solution that meets requirements

## Quick Links

- Active Sprint: [SPRINTS/sprint-002-architecture.md](SPRINTS/sprint-002-architecture.md)
- Archived Sprints: [SPRINTS/archive/](SPRINTS/archive/)
- Lessons Learnt: [LESSONS_LEARNED.md](LESSONS_LEARNED.md)
- Research Docs: [RESEARCH/](RESEARCH/)
- Tech Stack Decision: [RESEARCH/tech-stack-evaluation.md](RESEARCH/tech-stack-evaluation.md)

## Naming Conventions

- Releases: R00, R01, R02...
- Phases: P00, P01, P02...
- Sprints: sprint-NNN-description.md
- Lessons: LESSON-NNN (category-based ranges)

---

_Last updated: 2026-02-09_
