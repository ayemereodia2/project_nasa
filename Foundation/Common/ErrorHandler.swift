//
//  ErrorHandler.swift
//  Nasa
//
//  Created by DAVID ODIA on 14/10/2023.
//

import Foundation

protocol ErrorHandler {
    func handleError(error: Error) -> String
}
