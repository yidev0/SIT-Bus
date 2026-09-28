//
//  NextSchoolBusIntent.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/23.
//

import AppIntents

struct NextSchoolBusIntent: AppIntent {

    static var title: LocalizedStringResource = .init("GetNextBus.Title", table: "Intents")
    static var description: IntentDescription? = .init(.init("GetNextBus.Description", table: "Intents"))

    @Parameter(
        title: LocalizedStringResource("BusRoute", table: "Intents"),
        requestDisambiguationDialog: IntentDialog(
            LocalizedStringResource("BusRoute.Disambiguation", table: "Intents")
        )
    )
    var busType: IntentBusLineType

    @Parameter(title: LocalizedStringResource("Date"), default: .now)
    var date: Date

    static var parameterSummary: some ParameterSummary {
        Summary("NextBusFor\(\.$busType)From\(\.$date).Summary", table: "Intents")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<Date> & ProvidesDialog {
        let line = busType.toBusLineType()
        let referenceData: SBReferenceData?
        switch line.busType {
        case .schoolOmiya, .schoolIwatsuki:
            let route: BusDataFetcher.Route = line.busType == .schoolOmiya ? .omiya : .iwatsuki
            switch await BusDataFetcher(route: route).fetchFreshData(remoteTimeout: 1.5) {
            case .success(let data):
                referenceData = data
            case .failure:
                throw NextBusIntentError.dataUnavailable
            }
        case .shuttle:
            referenceData = nil
        }
        let timetable: BusTimetable
        switch line.busType {
        case .schoolOmiya:
            guard let referenceData else { throw NextBusIntentError.dataUnavailable }
            timetable = referenceData.toBusTimetable()
        case .schoolIwatsuki:
            guard let referenceData else { throw NextBusIntentError.dataUnavailable }
            timetable = referenceData.toBusTimetable(source: BusDataFetcher.Route.iwatsuki.url)
        case .shuttle:
            timetable = .shuttleBus
        }

        if let departure = timetable.getNext(from: date, type: line.destinationType) {
            if timetable.getNextNote(from: date, nextDate: departure, type: line.destinationType) != nil {
                throw NextBusIntentError.timelyOperation
            }
            let formattedDeparture = departure.formatted(date: .abbreviated, time: .shortened)
            let dialog = LocalizedStringResource(
                "GetNextBus.Success.Dialog",
                defaultValue: "The next bus departs at \(formattedDeparture).",
                table: "Intents"
            )
            return .result(value: departure, dialog: IntentDialog(dialog))
        } else if timetable.isActive(for: date) {
            throw NextBusIntentError.serviceEnded
        } else {
            throw NextBusIntentError.noService
        }
    }
}

private enum NextBusIntentError: Error, CustomLocalizedStringResourceConvertible {
    case timelyOperation
    case serviceEnded
    case noService
    case dataUnavailable

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .timelyOperation:
            LocalizedStringResource("GetNextBus.Error.TimelyOperation", table: "Intents")
        case .serviceEnded:
            .busServiceEnded
        case .noService:
            .noBusService
        case .dataUnavailable:
            .errorNoLocalData
        }
    }
}
