//
//  APIError.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// Errors that can occur during API requests
enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int, message: String?)
    case noData
    case cancelled
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to parse server response: \(error.localizedDescription)"
        case .serverError(let statusCode, let message):
            if let message = message {
                return "Server error (\(statusCode)): \(message)"
            }
            return "Server error (status code: \(statusCode))"
        case .noData:
            return "No data received from server"
        case .cancelled:
            return "Request was cancelled"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Please check your internet connection and try again."
        case .serverError(let statusCode, _):
            if statusCode >= 500 {
                return "The server is experiencing issues. Please try again later."
            } else if statusCode == 401 || statusCode == 403 {
                return "Authentication failed. Please check your API key."
            }
            return "Please try again."
        case .decodingError:
            return "The server returned unexpected data. Please try again or contact support if the problem persists."
        default:
            return "Please try again."
        }
    }
}
