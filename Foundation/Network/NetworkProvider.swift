//
//  NetworkProvider.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

public protocol NetworkProvider {
    
    func retrieve<Response: Decodable>(destination: URL) async throws -> Response?
}
