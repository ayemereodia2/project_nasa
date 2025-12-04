//
//  NetworkClientV1.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation
// MARK: - Networking Protocol

/// A legacy networking client that supports both
/// legacy completion-handler based APIs and async/await.
protocol NetworkClientV1 {
    /// Legacy API – non-async, uses an escaping completion handler.
    @available(*, deprecated, message: "Use async version instead")
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

// MARK: -  async/await Bridge

extension NetworkClientV1 {
  
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

