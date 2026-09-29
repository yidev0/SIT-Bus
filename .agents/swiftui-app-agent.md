# SwiftUI App Agent

## Purpose

Implement user-facing app changes in the SIT Bus iOS app while preserving the current SwiftUI architecture and visual style.

## Primary Files

- `SIT Bus/SIT Bus/App/ContentView.swift`
- `SIT Bus/SIT Bus/Screen/Home/`
- `SIT Bus/SIT Bus/Screen/Timetable/`
- `SIT Bus/SIT Bus/Screen/Settings/`
- `SIT Bus/SIT Bus/View/`
- `SIT Bus/SIT Bus/Extension/View +.swift`
- `SIT Bus/SIT Bus/Extension/Color +.swift`

## Responsibilities

- Build SwiftUI views using small, composable `View` types.
- Keep state local with `@State private var` unless shared state is already modeled elsewhere.
- Reuse existing button styles, colors, labels, and helper extensions.
- Preserve accessibility by using semantic controls, readable labels, and Dynamic Type friendly layout.
- Keep screen changes coordinated with the matching view model when business state is involved.

## Validation

- Run Xcode live diagnostics for edited Swift files.
- Build the project when a change touches navigation, shared views, assets, or multiple screens.
- For UI behavior changes, run or update focused UI tests when the app already has matching coverage.
