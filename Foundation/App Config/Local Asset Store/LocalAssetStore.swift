//
//  LocalAssetStore.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

class LocalAssetStore: AssetStore {
    
    func getAsset(_ path: String ) -> Data? {
        let url = getFullUrl( path: path )
        return try? Data(contentsOf: url)
    }

    func saveAsset( _ path: String, data: Data, eTag: String ) {
        // TODO
    }
    
    private func getFullUrl(path: String, useBundle: Bool = true) -> URL {
        var url: URL
        if useBundle {
            url = Bundle.main.bundleURL
        } else {
            url = URL.applicationSupportDirectory
        }
        url = url
            .appending(path: path)
        return url
    }
    
}

protocol AssetStore {

    func getAsset( _ path: String ) -> Data?
    
    func saveAsset( _ path: String, data: Data, eTag: String )
}
