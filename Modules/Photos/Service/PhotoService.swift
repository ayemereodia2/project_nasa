//
//  PhotoService.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation
protocol PhotoService {
    func fetch() async throws -> NasaPhoto?
}
