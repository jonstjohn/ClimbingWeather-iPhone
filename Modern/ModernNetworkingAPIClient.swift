//
//  APIClient.swift
//  climbingweather
//
//  Created on 2/6/26.
//

import Foundation

/// Protocol defining the API client interface for testing/mocking
protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

/// Main API client for making network requests
final class APIClient: APIClientProtocol {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let configuration: APIConfiguration
    private let decoder: JSONDecoder
    
    // MARK: - Initialization
    
    init(configuration: APIConfiguration, session: URLSession? = nil) {
        self.configuration = configuration
        
        // Configure URLSession
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = configuration.timeout
        sessionConfig.timeoutIntervalForResource = configuration.timeout * 2
        sessionConfig.waitsForConnectivity = true
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        self.session = session ?? URLSession(configuration: sessionConfig)
        
        // Configure JSON decoder
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .useDefaultKeys
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Public Methods
    
    /// Performs an API request and returns the decoded response
    /// - Parameter endpoint: The endpoint to request
    /// - Returns: The decoded response object
    /// - Throws: APIError if the request fails
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        // Build URL
        let url = try buildURL(for: endpoint)
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("ClimbingWeather-iOS/4.0", forHTTPHeaderField: "User-Agent")
        
        // Log request (for debugging)
        #if DEBUG
        print("🌐 API Request: \(request.httpMethod ?? "GET") \(url.absoluteString)")
        #endif
        
        // Perform request
        do {
            let (data, response) = try await session.data(for: request)
            
            // Validate response
            try validateResponse(response, data: data)
            
            // Log response (for debugging)
            #if DEBUG
            if let httpResponse = response as? HTTPURLResponse {
                print("✅ API Response: \(httpResponse.statusCode)")
            }
            #endif
            
            // Decode and return
            return try decode(data: data)
            
        } catch let error as URLError where error.code == .cancelled {
            throw APIError.cancelled
        } catch let error as URLError {
            throw APIError.networkError(error)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Private Methods
    
    /// Builds a complete URL for the given endpoint
    private func buildURL(for endpoint: APIEndpoint) throws -> URL {
        guard var urlComponents = URLComponents(
            url: configuration.baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: true
        ) else {
            throw APIError.invalidURL
        }
        
        // Add query items from endpoint
        var queryItems = endpoint.queryItems
        
        // Add API key
        queryItems.append(URLQueryItem(name: "apiKey", value: configuration.apiKey))
        
        // Set query items (only if not empty)
        urlComponents.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        return url
    }
    
    /// Validates the HTTP response
    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // Success range: 200-299
        guard (200...299).contains(httpResponse.statusCode) else {
            // Try to extract error message from response
            let errorMessage = try? extractErrorMessage(from: data)
            throw APIError.serverError(statusCode: httpResponse.statusCode, message: errorMessage)
        }
    }
    
    /// Attempts to extract an error message from error response data
    private func extractErrorMessage(from data: Data) throws -> String? {
        struct ErrorResponse: Decodable {
            let error: String?
            let message: String?
        }
        
        if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
            return errorResponse.error ?? errorResponse.message
        }
        
        return nil
    }
    
    /// Decodes the response data
    private func decode<T: Decodable>(data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            #if DEBUG
            // Log the raw response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("❌ Decoding failed. Raw response:")
                print(responseString)
            }
            #endif
            throw APIError.decodingError(error)
        }
    }
}

// MARK: - Convenience Extensions

extension APIClient {
    /// Convenience method to check API health
    func checkHealth() async throws -> Bool {
        struct EmptyResponse: Decodable {}
        let _: EmptyResponse = try await request(ClimbingWeatherEndpoint.healthCheck)
        return true
    }
}
