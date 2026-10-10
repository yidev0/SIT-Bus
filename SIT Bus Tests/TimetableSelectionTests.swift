import Foundation
import Testing
@testable import SIT_Bus

@Suite @MainActor
struct TimetableSelectionTests {
    private func withSettings(_ test: (AppSettings) throws -> Void) throws {
        let name = "TimetableSelectionTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: name))
        defer { defaults.removePersistentDomain(forName: name) }
        try test(AppSettings(sharedDefaults: defaults, standardDefaults: defaults))
    }

    @Test(arguments: BusType.allCases.flatMap(\.cases))
    func compactSelectionUpdatesCategoryAndSurvivesRelaunch(route: BusLineType) throws {
        try withSettings { settings in
            let model = TimetableViewModel(settings: settings)
            model.busLineType = route

            #expect(model.busType == route.busType)
            #expect(settings.timetableBusType == route.busType.rawValue)
            let restored = TimetableViewModel(settings: settings)
            #expect(restored.busLineType == route)
            #expect(restored.busType == route.busType)
        }
    }

    @Test(arguments: BusType.allCases)
    func regularSelectionChoosesMatchingRouteAndPreservesDate(category: BusType) throws {
        try withSettings { settings in
            let model = TimetableViewModel(settings: settings)
            model.busLineType = category == .shuttle ? .schoolBus(.campusToStation) : .shuttleBus(.toOmiya)
            let date = Date(timeIntervalSince1970: 1_800_000_000)
            model.date = date
            model.showDatePicker = true
            model.busType = category

            #expect(model.busLineType == category.cases.first)
            #expect(model.date == date)
            #expect(model.showDatePicker)
            #expect(settings.timetableBus == model.busLineType.rawValue)
            let restored = TimetableViewModel(settings: settings)
            #expect(restored.busLineType == model.busLineType)
            #expect(restored.busType == category)
        }
    }

    @Test(arguments: BusType.allCases)
    func reselectingCategoryPreservesDirection(category: BusType) throws {
        try withSettings { settings in
            let route = try #require(category.cases.last)
            let model = TimetableViewModel(settings: settings)
            model.busLineType = route
            model.busType = category
            #expect(model.busLineType == route)
        }
    }

    @Test func restoresSavedRouteWhenLegacySelectionsDisagree() throws {
        try withSettings { settings in
            settings.timetableBus = BusLineType.schoolBusIwatsuki(.campusToStation).rawValue
            settings.timetableBusType = BusType.schoolOmiya.rawValue
            let model = TimetableViewModel(settings: settings)
            #expect(model.busLineType == .schoolBusIwatsuki(.campusToStation))
            #expect(model.busType == .schoolIwatsuki)
            #expect(settings.timetableBusType == BusType.schoolIwatsuki.rawValue)
        }
    }

    @Test(arguments: BusType.allCases)
    func restoresCategoryWhenNoRouteWasSaved(category: BusType) throws {
        try withSettings { settings in
            settings.timetableBusType = category.rawValue
            let model = TimetableViewModel(settings: settings)
            #expect(model.busType == category)
            #expect(model.busLineType == category.cases.first)
            #expect(settings.timetableBus == model.busLineType.rawValue)
        }
    }
}
