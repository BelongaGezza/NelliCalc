# AI Agents — NelliCalc

**Purpose:** AI agent commands and coordination for NelliCalc.
**Tech Stack:** Flutter (Dart)

## Available Agent Commands

- `/agent architect` — Architecture & design decisions
- `/agent senior` — Senior Engineer for implementation and reviews
- `/agent junior` — Junior Engineer for implementations and tests
- `/agent security` — Security reviews
- `/agent docs` — Documentation assistance
- `/agent research` — Ecosystem research and technology evaluation
- `/agent ui` — UI design assistance

## Project Context & Key Documents

### Project Management
- [PROJECT_STATUS.md](PROJECT_STATUS.md) — Current release, phase, and sprint
- [SPRINTS/](SPRINTS/) — Sprint tasking files (archived sprints in SPRINTS/archive/)
- [LESSONS_LEARNED.md](LESSONS_LEARNED.md) — Knowledge base and gotchas

### Research & Architecture
- [RESEARCH/tech-stack-evaluation.md](RESEARCH/tech-stack-evaluation.md) — Tech stack decision (Flutter selected)
- [RESEARCH/architecture.md](RESEARCH/architecture.md) — Implementation architecture (Sprint 002 deliverable)

### Agent Definitions
- [.agents/system-architect.md](.agents/system-architect.md) — System Architect persona
- [.agents/senior-engineer.md](.agents/senior-engineer.md) — Senior Engineer persona
- [.agents/junior-engineer.md](.agents/junior-engineer.md) — Junior Engineer persona
- [.agents/security-specialist.md](.agents/security-specialist.md) — Security Specialist persona
- [.agents/documentation-specialist.md](.agents/documentation-specialist.md) — Documentation Specialist persona
- [.agents/researcher.md](.agents/researcher.md) — Researcher persona
- [.agents/ui-designer.md](.agents/ui-designer.md) — UI Designer persona

## Coding Standards

### Flutter/Dart Conventions
- Follow [Effective Dart](https://dart.dev/effective-dart) style guide
- Use `dart format` for code formatting
- Use `dart analyze` for static analysis — zero warnings policy
- Document all public APIs with dartdoc comments (`///`)
- Add tests for new functionality (unit tests from Sprint 003 onwards)
- Prefer composition over inheritance for widgets
- Use `const` constructors wherever possible

### General Principles
- Include examples in documentation
- Keep widgets small and focused (single responsibility)
- Separate business logic from UI (no logic in widget `build` methods)

## Agent Coordination

### Role-Claiming Model

Agents claim roles from sprint tasking files.

**Quick start:**
1. Agent reads sprint file (e.g., `SPRINTS/sprint-001-flutter-scaffold.md`)
2. Finds available role in Role Assignment Table
3. Claims role by updating status to "In Progress"
4. Reads persona file from `.agents/` and adopts that identity
5. Executes assigned tasks

### Sprint Workflow

1. Senior Engineer creates sprint from [SPRINT_TEMPLATE.md](SPRINTS/SPRINT_TEMPLATE.md)
2. Defines roles, tasks, and dependencies
3. Agents claim roles and work autonomously
4. Progress logged in sprint file
5. Sprint archived to `SPRINTS/archive/` when complete

## British English Standards

All documentation and user-facing text uses British English (organise, colour, behaviour, etc.).

**Exception:** Code follows Dart naming conventions (e.g., `Color` not `Colour` in Dart code, as this matches the Flutter API).

## Agent Use Guidelines

- All AI suggestions require human review and PR with tests
- Record significant decisions in LESSONS_LEARNED.md
- Reference lesson IDs in PRs and code comments
- Archive completed sprints to minimise context usage

## Project-Specific Notes

- **Primary Platform**: Handheld touchscreen phones
- **Key Feature**: Drag-and-drop previous results into calculations
- **Responsive Design**: Landscape (side panel) and portrait (slide-over pane) layouts
- **Tech Stack**: Flutter (Dart) — [decision rationale](RESEARCH/tech-stack-evaluation.md)
- **Accessibility**: WCAG AA compliance, 48x48dp minimum touch targets
- **Testing**: Unit tests required from Sprint 003 onwards; test as you go, not deferred

---

_Last updated: 2026-02-09_
