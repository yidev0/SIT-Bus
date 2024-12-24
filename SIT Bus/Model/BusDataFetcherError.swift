//
//  BusDataFetcherError.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/23.
//

import SwiftUI

enum BusDataFetcherError: Error, LocalizedError {
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
            "Error.ClientError".localize
        case .invalidResponse:
            "Error.InvalidResponse".localize
        case .invalidURL:
            "Error.InvalidURL".localize
        case .networkError:
            "Error.NetworkError".localize
        case .noLocalData:
            "Error.NoLocalData".localize
        case .parseError:
            "Error.ParseError".localize
        case .serverError:
            "Error.ServerError".localize
        case .undefined(let statusCode):
            "Error.Undefined(\(statusCode))".localize
        }
    }
}
