//
//  NetworkError.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case unexpected(message: String, innerError: String)
    case non200Code(errorCode: Int, message: String)
    case noData
}

