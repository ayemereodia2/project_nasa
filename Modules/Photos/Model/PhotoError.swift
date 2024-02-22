//
//  PhotoError.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

enum PhotoError: Error {
    case invalidUrl(message: String)
    case generalError(message: String)
}
