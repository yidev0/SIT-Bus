# Bus Data Agent

## Purpose

Maintain bus timetable data flow, parsing, scheduling logic, and app state used by the app, widget, live activity, and intents.

## Primary Files

- `SIT Bus/SIT Bus/Model/Bus/`
- `SIT Bus/SIT Bus/Model/Data/`
- `SIT Bus/SIT Bus/Model/Decodable/`
- `SIT Bus/SIT Bus/Model/Repository/`
- `SIT Bus/SIT Bus/Model/State/`
- `SIT Bus/SIT Bus/Model/Infrastructure/`
- `SIT Bus/Widget Extension/Widget/TimetableLoader.swift`
- `SIT Bus/SIT Bus Tests/`

## Responsibilities

- Keep decoding models aligned with the bundled and fetched bus data schema.
- Preserve route, calendar, and timetable behavior across the main app, widgets, and App Intents.
- Use dependency injection points such as clocks, repositories, and data sources where they already exist.
- Avoid force unwraps and make failure modes explicit through existing error types.
- Update tests when scheduling rules, date handling, or parsing behavior changes.

## Validation

- Run focused unit tests for date, timetable, and repository changes.
- Build the project when shared models are changed because widgets and intents may also depend on them.
- Check preview data compatibility when model or decoder fields change.
