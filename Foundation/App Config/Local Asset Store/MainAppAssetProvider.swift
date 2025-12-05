//
//  MainAppAssetProvider.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

class MainAppAssetProvider: AppAssetProvider {
    
    init(assetStore: AssetStore) {
        self.assetStore = assetStore
    }
        
    func getAsset(_ path: String) -> Data? {
        var asset: Data?

        if let data = assetStore.getAsset(path) {
            // found it!
            asset = data
        }
        
        // do we have an asset?
        guard let asset else {  // log, and return nothing
          return nil  }

        return asset
    }
    
    func getJsonAsset<T>(_ path: String) -> T? where T : Decodable {
        guard let data = getAsset( path ) else {
            // no data
            return nil
        }
        
        // now decode the data
        let json: T
        do {
            let decoder = JSONDecoder()
            json = try decoder.decode(T.self, from: data)
        } catch {
            // error decoding the JSON
            let _ = String( data: data, encoding: .utf8)
            // handle error
            return nil
        }
        
        // return the decoded object
        return json
    }
    
    private let assetStore: AssetStore
}


protocol AppAssetProvider {
    
    func getAsset(_ path: String) -> Data?
    
    func getJsonAsset<T: Decodable>(_ path: String ) -> T?
}
