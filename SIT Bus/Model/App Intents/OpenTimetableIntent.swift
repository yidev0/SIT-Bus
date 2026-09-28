//
//  OpenTimetableIntent.swift
//  SIT Bus
//

import AppIntents

struct OpenTimetableIntent: OpenIntent {
    static var title: LocalizedStringResource = .init("OpenTimetable.Title", table: "Intents")
    static var description: IntentDescription? = .init(
        .init("OpenTimetable.Description", table: "Intents")
    )

    @Parameter(
        title: LocalizedStringResource("BusRoute", table: "Intents"),
        requestDisambiguationDialog: IntentDialog(
            LocalizedStringResource("BusRoute.Disambiguation", table: "Intents")
        )
    )
    var target: IntentBusLineType

    @Parameter(title: LocalizedStringResource("Date"), default: .now)
    var date: Date?

    static var parameterSummary: some ParameterSummary {
        Summary("OpenTimetableFor\(\.$target)On\(\.$date).Summary", table: "Intents")
    }

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            AppNavigation.shared.openTimetable(
                line: target.toBusLineType(),
                date: date ?? .now
            )
        }
        return .result()
    }
}

struct SITBusShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: NextSchoolBusIntent(),
            phrases: ["Get the next bus with \(.applicationName)"],
            shortTitle: LocalizedStringResource("AppShortcut.GetNextBus.ShortTitle", table: "Intents"),
            systemImageName: "bus.fill"
        )

        AppShortcut(
            intent: OpenTimetableIntent(),
            phrases: ["Open the timetable in \(.applicationName)"],
            shortTitle: LocalizedStringResource("AppShortcut.OpenTimetable.ShortTitle", table: "Intents"),
            systemImageName: "tablecells"
        )
    }
}
