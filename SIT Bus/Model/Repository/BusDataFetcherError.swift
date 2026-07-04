//
//  BusDataFetcherError.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/23.
//

import SwiftUI

enum BusDataFetcherError: Error, LocalizedError, Hashable, CaseIterable {
    static var allCases: [BusDataFetcherError] = [
        .clientError,
        .invalidResponse,
        .invalidURL,
        .networkError,
        .noLocalData,
        .parseError,
        .serverError,
        .undefined(statusCode: 0),
    ]
    
    case clientError
    case invalidResponse
    case invalidURL
    case networkError
    case noLocalData
    case parseError
    case serverError
    case undefined(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .clientError:
            String(localized: .errorClientError)
        case .invalidResponse:
            String(localized: .errorInvalidResponse)
        case .invalidURL:
            String(localized: .errorInvalidURL)
        case .networkError:
            String(localized: .errorNetworkError)
        case .noLocalData:
            String(localized: .errorNoLocalData)
        case .parseError:
            String(localized: .errorParseError)
        case .serverError:
            String(localized: .errorServerError)
        case .undefined(let statusCode):
            String(localized: .errorUndefined(statusCode))
        }
    }
}
