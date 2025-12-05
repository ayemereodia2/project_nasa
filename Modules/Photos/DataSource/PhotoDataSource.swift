//
//  PhotoDataSource.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

protocol PhotoDataSource: Actor {
    func save(name: String, photo: Any)
    func get(name: String) -> Any?
    func flush()
}
