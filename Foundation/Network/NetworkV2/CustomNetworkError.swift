//
//  CustomNetworkError.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation
// MARK: - CustomNetworkError Types

enum CustomNetworkError: Error, LocalizedError {
    case invalidResponse
    case http(statusCode: Int, body: String?)
    case decoding(Error)
    case underlying(Error)
    case cancelled

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server returned an invalid response."
        case .http(let statusCode, _):
            return "The server responded with status code \(statusCode)."
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .underlying(let error):
            return error.localizedDescription
        case .cancelled:
            return "The request was cancelled."
        }
    }
}


/*// MARK: - Example Usage with async/await

struct UserProfile: Decodable, Sendable {
    let id: Int
    let name: String
    let email: String
}

@MainActor
final class UserProfileViewModel: ObservableObject {
    @Published private(set) var profile: UserProfile?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let client: any NetworkClient

    init(client: any NetworkClient = URLSessionNetworkClient()) {
        self.client = client
    }

    func loadProfile(userID: Int) {
        isLoading = true
        errorMessage = nil

        Task {
            defer { isLoading = false }

            guard let url = URL(string: "https://example.com/api/users/\(userID)") else {
                errorMessage = "Invalid URL."
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            do {
                let user: UserProfile = try await client.request(
                    request,
                    decodeAs: UserProfile.self
                )
                self.profile = user
            } catch {
                self.errorMessage = (error as? LocalizedError)?.errorDescription
                    ?? "Something went wrong."
            }
        }
    }
}

enum SerNetworkError: Error, LocalizedError {
    case invalidResponse
    case http(statusCode: Int, body: String?)
    case decoding(Error)
    case underlying(Error)
    case cancelled

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server returned an invalid response."
        case .http(let statusCode, _):
            return "The server responded with status code \(statusCode)."
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .underlying(let error):
            return error.localizedDescription
        case .cancelled:
            return "The request was cancelled."
        }
    }
}

// MARK: - Networking Protocol

/// A generic networking client that supports both
/// legacy completion-handler based APIs and async/await.
protocol NetworkClient {
    /// Legacy API – non-async, uses an escaping completion handler.
    func request<T: Decodable & Sendable>(
        _ request: URLRequest,
        decodeAs type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )

    /// Modern API – async/await version with the same shape.
    func request<T: Decodable & Sendable>(
        _ request: URLRequest,
        decodeAs type: T.Type
    ) async throws -> T
}

// MARK: - Default async/await Bridge

extension NetworkClient {
    /// Default implementation that bridges from the
    /// completion-handler based API using a continuation.
    func request<T: Decodable & Sendable>(
        _ request: URLRequest,
        decodeAs type: T.Type
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            self.request(request, decodeAs: type) { result in
                continuation.resume(with: result)
            }
        }
    }
}

// MARK: - Concrete Implementation

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable & Sendable>(
        _ request: URLRequest,
        decodeAs type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let task = session.dataTask(with: request) { [decoder] data, response, error in
            // Use Result and first-order functions to keep logic declarative.
            let result: Result<T, Error> = Result<Data, Error> {
                if let error = error as? URLError, error.code == .cancelled {
                    throw SerNetworkError.cancelled
                }
                if let error = error {
                    throw SerNetworkError.underlying(error)
                }

                guard
                    let httpResponse = response as? HTTPURLResponse,
                    let data = data
                else {
                    throw SerNetworkError.invalidResponse
                }

                guard (200..<300).contains(httpResponse.statusCode) else {
                    let bodyString = String(data: data, encoding: .utf8)
                    throw SerNetworkError.http(statusCode: httpResponse.statusCode,
                                            body: bodyString)
                }

                return data
            }
            // Decode using flatMap to keep the pipeline fluent.
            .flatMap { data in
                Result<T, Error> {
                    do {
                        return try decoder.decode(T.self, from: data)
                    } catch {
                        throw SerNetworkError.decoding(error)
                    }
                }
            }

            completion(result)
        }

        task.resume()
    }
}

// MARK: - Example Usage with async/await

struct UserProfile: Decodable, Sendable {
    let id: Int
    let name: String
    let email: String
}

@MainActor
final class UserProfileViewModel: ObservableObject {
    @Published private(set) var profile: UserProfile?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let client: any NetworkClient

    init(client: any NetworkClient = URLSessionNetworkClient()) {
        self.client = client
    }

    func loadProfile(userID: Int) {
        isLoading = true
        errorMessage = nil

        Task {
            defer { isLoading = false }

            guard let url = URL(string: "https://example.com/api/users/\(userID)") else {
                errorMessage = "Invalid URL."
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            do {
                let user: UserProfile = try await client.request(
                    request,
                    decodeAs: UserProfile.self
                )
                self.profile = user
            } catch {
                self.errorMessage = (error as? LocalizedError)?.errorDescription
                    ?? "Something went wrong."
            }
        }
    }
}*/

