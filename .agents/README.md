# Agents

This directory defines focused coding-agent roles for the SIT Bus project.
Use these files as task briefs when assigning work to an agent.

## Available Agents

- [SwiftUI App Agent](swiftui-app-agent.md): Implements and updates app screens, controls, and navigation.
- [Bus Data Agent](bus-data-agent.md): Works on timetable models, repositories, parsing, and scheduling behavior.
- [Localization Release Agent](localization-release-agent.md): Maintains localized strings, privacy text, release metadata, and final checks.

## Shared Project Rules

- Prefer the existing SwiftUI patterns and folder boundaries.
- Keep changes narrowly scoped to the requested behavior.
- Use async/await for asynchronous work and avoid adding Combine.
- Use Swift Testing for unit tests and XCUIAutomation for UI tests.
- Validate Swift changes with Xcode diagnostics or a project build when practical.
