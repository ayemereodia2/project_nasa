//
//  URLSessionNetworkClientV1.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation
import UIKit
// MARK: - Old Concrete Implementation

final class URLSessionNetworkClientV1: NetworkClientV1 {
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
                  // No structured error handling
                    throw CustomNetworkError.cancelled
                }
              
                if let error = error {
                  // No structured error handling
                    throw CustomNetworkError.underlying(error)
                }

                guard
                    let httpResponse = response as? HTTPURLResponse,
                    let data = data
                else {
                    throw CustomNetworkError.invalidResponse
                }

                guard (200..<300).contains(httpResponse.statusCode) else {
                    let bodyString = String(data: data, encoding: .utf8)
                    throw CustomNetworkError.http(statusCode: httpResponse.statusCode,
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
                        throw CustomNetworkError.decoding(error)
                    }
                }
            }

            completion(result)
        }

        task.resume()
    }
  
  
  // Asynchronous fetching of images with GCD Queues is unstructured and manual
  
  func fetchThumbnails(
      for ids: [String],
      thumbSize: CGSize,
      completionHandler: @escaping ([String: UIImage]?, Error?) -> Void
  ) {
      // Base case: no IDs → return empty dictionary
      guard let id = ids.first else {
          completionHandler([:], nil)
          return
      }

      let request = thumbnailURLRequest(for: id)

      URLSession.shared.dataTask(with: request) { data, response, error in
          // Network-level error
          if let error = error {
              completionHandler(nil, error)
              return
          }

          // Validate response + data
          guard
              let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode),
              let data = data
          else {
              completionHandler(nil, ThumbnailFailedError.invalidResponse)
              return
          }

          // Decode image
          guard let image = UIImage(data: data) else {
              completionHandler(nil, ThumbnailFailedError.decodingFailed)
              return
          }

          // Generate thumbnail asynchronously
          image.prepareThumbnail(of: thumbSize) { thumbnail in
            
              guard let thumbnail = thumbnail else {
                  completionHandler(nil, ThumbnailFailedError.thumbnailGenerationFailed)
                  return
              }

              // UGLY RECURSIVE FETCHING
            
              // Recurse on the remaining IDs
              let remaining = Array(ids.dropFirst())
              self.fetchThumbnails(for: remaining, thumbSize: thumbSize) { thumbnails, error in
                
                  if let error = error {
                      completionHandler(nil, error)
                      return
                  }

                  var result = thumbnails ?? [:]
                  result[id] = thumbnail
                  completionHandler(result, nil)
              }
          }
      }.resume()
  }
  
  // TODO: -
  func thumbnailURLRequest(for id: String) -> URLRequest {
      return URLRequest(url: URL(string: "https://imagepro-thumbnails/id")!)
  }
  
  
  // Asynchronous code with async/await is structured.
  func fetchThumbnails(for ids: [String], thumbSize: CGSize) async throws -> [String: UIImage] {
    
    var thumbnails: [String: UIImage] = [:]
    
    for id in ids {
      let request = thumbnailURLRequest(for: id)
      let (data, response) = try await URLSession.shared.data (for: request)
      
      //try validateResponse (response)
      guard let image = await UIImage(data: data)?.byPreparingThumbnail(ofSize: thumbSize) else {
        throw ThumbnailFailedError.thumbnailGenerationFailed
      }
      
      thumbnails[id] = image
    }
    
    return thumbnails
  }
  
}





