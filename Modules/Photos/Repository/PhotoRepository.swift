//
//  PhotoRepository.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation


protocol PhotoRepository {
    func fetchPhoto() async throws -> NasaPhoto? 
    // use core foundation types
    func getImage(imageUrl: String) throws -> Any?
    func storeImage(key: String, image: Any)
}
