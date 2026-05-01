//
//  APIError.swift
//  FindingFalcone
//
//  Created by Abhishek Pandey on 01/05/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case httpError(statusCode: Int)
    case missingToken

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL."
        case .httpError(let code):
            return "Server returned error \(code)."
        case .missingToken:
            return "Could not retrieve an authentication token."
        }
    }
}
