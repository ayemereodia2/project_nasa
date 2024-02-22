//
//  LogProvider.swift
//  Nasa
//
//  Created by DAVID ODIA on 14/10/2023.
//

import Foundation

public protocol LogProvider {
    func info(message: String)
    func warn(message: String)
    func error(message: String)
    func fatal(message: String)
}
