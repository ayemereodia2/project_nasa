//
//  ThumbnailFailedError.swift
//  Nasa
//
//  Created by ANDELA on 03/12/2023.
//

import Foundation
// MARK: - Error Type

enum ThumbnailFailedError: Error {
    case invalidResponse
    case decodingFailed
    case thumbnailGenerationFailed
}
