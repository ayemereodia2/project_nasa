//
//  MainPhotoRepository.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation
import SwiftUI

class MainPhotoRepository: PhotoRepository {
    
    init(
        dataSource: PhotoDataSource,
        service: PhotoService
    ) {
        self.dataSource = dataSource
        self.service = service
    }
    
    func fetchPhoto() async throws -> NasaPhoto? {
        // check object cache
      guard let validResult = await dataSource.get(name: "key") as? NasaPhoto else {
            
            do {
                if let photoResult = try await service.fetch() {
                    
                  await dataSource.save(name: "key", photo: photoResult)
                    
                    return photoResult
                }
            } 
            
            // note: generally won't happen; more typical is an exception
            throw PhotoError.generalError(message: "no photo exist")
        }
        
        return validResult
    }
    
  func getImage(imageUrl: String) async throws -> Any? {
        // check cache
        guard let validImage = await dataSource.get(name: imageUrl) else {
            // note: generally won't happen; more typical is an exception
            throw PhotoError.generalError(message: "no photo exist")
        }
        
        return validImage
    }
    
  func storeImage(key: String, image: Any) async {
         await dataSource.save(name: key, photo: image)
    }
    
    private let dataSource: PhotoDataSource
    private let service: PhotoService
}
