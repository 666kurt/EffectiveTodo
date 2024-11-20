//
//  TodoError.swift
//  EffectiveTodo
//
//  Created by Максим Шишлов on 15.11.2024.
//

import Foundation

enum TodoError: Error {
    
    case invalidData
    case jsonParcingFailure
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var description: String {
        switch self {
        case .invalidData:
            return "Invalid data"
        case .jsonParcingFailure:
            return "Failed to parse json"
        case .requestFailed(let description):
            return "Request failed: \(description)"
        case .invalidStatusCode(let statusCode):
            return "Invalid status code: \(statusCode)"
        case .unknownError(let error):
            return "An unknown error: \(error.localizedDescription)"
        }
    }
    
}
