# Contributing to NelliCalc

Thank you for your interest in contributing!

## Development Status

This project is currently in initial setup phase. Once the repository structure is complete and the tech stack is selected, we will be open to contributions.

## How to Contribute

- Report issues via GitHub Issues
- Send code changes via Pull Requests
- Improve documentation and examples
- Add tests and maintain test coverage

## Development Process

### Finding Work

1. Check [PROJECT_STATUS.md](PROJECT_STATUS.md) for current sprint
2. Review active sprint file in [SPRINTS/](SPRINTS/)
3. Check [LESSONS_LEARNED.md](LESSONS_LEARNED.md) for gotchas before starting

### Making Changes

1. Fork the repository
2. Create a feature branch from the main branch
3. Make changes with tests and documentation
4. Follow British English for all documentation and user-facing text
5. Submit a Pull Request and request review

## Code Standards

Code standards will be defined once the tech stack is selected. General principles:

- Write tests for new functionality
- Document all public APIs
- Use conventional commits for commit messages
- Follow British English spelling in documentation (organise, colour, behaviour, etc.)
- Follow platform-specific conventions for code (e.g., if using Flutter, follow Dart conventions)

## CI & Checks

- Ensure CI passes on your PR
- Add integration tests for critical features
- All tests must pass before merging

## Project Management

This project uses a Sprint-based workflow:

- **Current work:** See [PROJECT_STATUS.md](PROJECT_STATUS.md)
- **Sprint files:** Located in [SPRINTS/](SPRINTS/)
- **Templates:** Use [SPRINTS/SPRINT_TEMPLATE.md](SPRINTS/SPRINT_TEMPLATE.md) for new sprints
- **Learnt lessons:** Document gotchas in [LESSONS_LEARNED.md](LESSONS_LEARNED.md)

When working on a sprint task:
1. Claim a role from the Role Assignment Table
2. Update task status in-place in the sprint file
3. Log progress and handovers in the Progress Log
4. Reference any lessons learnt (LESSON-NNN) in your PR

## AI Agents & Automation

This project supports AI-assisted development:

- Every AI-suggested change must be reviewed by a human
- Record significant prompt summaries in PR descriptions
- Document new patterns or issues in LESSONS_LEARNED.md
- Agents should follow the Role-Claiming Model (see [RESEARCH/AI_DEVELOPMENT_GUIDE.md](RESEARCH/AI_DEVELOPMENT_GUIDE.md) if created)

## British English Standards

All documentation, comments, and user-facing text use British English:
- organise (not organize)
- colour (not color)
- behaviour (not behavior)
- initialise (not initialize)
- optimise (not optimize)

**Exception:** Code follows platform-specific conventions (e.g., if using Flutter/Dart, follow Dart naming conventions).

## Platform-Specific Considerations

When contributing, consider:

- Touch-first design principles
- Responsive layouts for different screen sizes
- Platform-specific UI guidelines (Material Design for Android, Human Interface Guidelines for iOS, etc.)
- Accessibility requirements
- Performance on mobile devices

## Questions

Direct questions to the project maintainers or open an issue on GitHub.

For sprint-specific questions, check the relevant sprint file in [SPRINTS/](SPRINTS/).

---

_Last updated: 2026-02-09_
