# AI Agents — NelliCalc

**Purpose:** AI agent commands and coordination for NelliCalc.

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
- [SPRINTS/](SPRINTS/) — Sprint tasking files
- [LESSONS_LEARNED.md](LESSONS_LEARNED.md) — Knowledge base and gotchas

### Research & Architecture
- [RESEARCH/tech-stack-evaluation.md](RESEARCH/tech-stack-evaluation.md) — Tech stack research and evaluation
- [RESEARCH/architecture.md](RESEARCH/architecture.md) — Implementation architecture (to be created)
- [RESEARCH/AI_DEVELOPMENT_GUIDE.md](RESEARCH/AI_DEVELOPMENT_GUIDE.md) — Multi-agent coordination (optional)

### Agent Definitions
- [.agents/](.agents/) — Agent persona files (if using agent system)

## Coding Standards

Code standards will be defined once the tech stack is selected. General principles:

- Document all public APIs
- Include examples in documentation
- Add tests for new functionality
- Follow platform-specific conventions

## Agent Coordination

### Role-Claiming Model

Agents claim roles from sprint tasking files. See [RESEARCH/AI_DEVELOPMENT_GUIDE.md](RESEARCH/AI_DEVELOPMENT_GUIDE.md) for details (if created).

**Quick start:**
1. Agent reads sprint file (e.g., `SPRINTS/sprint-001-feature.md`)
2. Finds available role in Role Assignment Table
3. Claims role by updating status to "In Progress"
4. Reads persona file and adopts that identity
5. Executes assigned tasks

### Sprint Workflow

1. Senior Engineer creates sprint from [SPRINT_TEMPLATE.md](SPRINTS/SPRINT_TEMPLATE.md)
2. Defines roles, tasks, and dependencies
3. Agents claim roles and work autonomously
4. Progress logged in sprint file
5. Sprint archived when complete

## British English Standards

All documentation and user-facing text uses British English (organise, colour, behaviour, etc.).

**Exception:** Code follows platform-specific conventions (e.g., if using Flutter/Dart, follow Dart naming conventions).

## Agent Use Guidelines

- All AI suggestions require human review and PR with tests
- Record significant decisions in LESSONS_LEARNED.md
- Reference lesson IDs in PRs and code comments
- Archive completed sprints to minimise context usage

## Project-Specific Notes

- **Primary Platform**: Handheld touchscreen phones
- **Key Feature**: Drag-and-drop previous results into calculations
- **Responsive Design**: Landscape (side panel) and portrait (slide-over pane) layouts
- **Tech Stack**: Under evaluation (see RESEARCH/tech-stack-evaluation.md)

---

_Last updated: 2026-02-09_
