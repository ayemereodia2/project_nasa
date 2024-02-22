//
//  MainAppSecretsProvider.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

class MainAppSecretsProvider: AppSecretsProvider {
    
    init(
        assetProvider: AppAssetProvider
    ) {
        self.assetProvider = assetProvider
    }
    
    func getNasaSecrets() -> SecretWithApiAndUrl? {
        guard let newConfig: SecretWithApiAndUrl = assetProvider.getJsonAsset(configurationAsset) else {
            // error loading the config
            return nil
        }
        
        return newConfig
    }
    
    
    private let assetProvider: AppAssetProvider
    private let configurationAsset = "serversecrets.json"
}
