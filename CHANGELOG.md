# Changelog

All notable changes to this project will be documented in this file.

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

_No unreleased changes._

---

## [0.1.0] - 2026-02-09

### Added
- Flutter project scaffold (`nelli_calc`) targeting iOS, Android, macOS, Windows, Linux
- Drag-and-drop proof of concept (`lib/poc/drag_drop_poc.dart`)
  - `LongPressDraggable` history items with `DragTarget` calculator display
  - Visual feedback: elevated chip during drag, hover highlight on target
- Responsive layout proof of concept (`lib/poc/responsive_poc.dart`)
  - Wide layout (>= 600dp): side-by-side calculator + history panel
  - Narrow layout (< 600dp): full-width calculator + `DraggableScrollableSheet` bottom pane
- Strict linting via `very_good_analysis` 10.1.0
- GitHub Actions CI pipeline (format, analyse, test, build)
- State management evaluation (`RESEARCH/state-management-evaluation.md`) — Riverpod recommended
- Tech stack evaluation (`RESEARCH/tech-stack-evaluation.md`) — Flutter selected
- 9 widget tests covering smoke, drag-and-drop, responsive layouts, and breakpoint switching
- Agent persona files for 7 roles (`.agents/`)
- Sprint-based development workflow with sprint template

### Changed
- Migrated from GPL v3 to dual MIT/Apache-2.0 licensing
- Updated all documentation for Flutter tech stack
- Copyright year updated to 2021-2026

---

_Last updated: 2026-02-09_
