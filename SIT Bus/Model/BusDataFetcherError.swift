//
//  BusDataFetcherError.swift
//  SIT Bus
//
//  Created by Yuto on 2024/12/23.
//


enum BusDataFetcherError: Error {
    case clientError
    case invalidResponse
    case invalidURL
    case networkError
    case noLocalData
    case parseError
    case serverError
    case undefined(statusCode: Int)
}
