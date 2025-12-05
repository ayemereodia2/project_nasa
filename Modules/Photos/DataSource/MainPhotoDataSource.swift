//
//  MainPhotoDataSource.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation


actor MainPhotoDataSource: PhotoDataSource {
    // use in memory cache to save photo
    private var inMemoryCache = [String : Any]()
    
    func save(name: String, photo: Any) {
        inMemoryCache[name] = photo
    }
    
    func get(name: String) -> Any? {
        inMemoryCache[name]
    }
    
    func flush() {
        inMemoryCache.removeAll()
    }
    
    
}
