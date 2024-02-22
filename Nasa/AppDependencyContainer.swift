//
//  AppDependencyContainer.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

class AppDependencyContainer {
    static let shared = AppDependencyContainer()

    private init() {
        self.logProvider = DefaultLogger()
        self.localAssetStore = LocalAssetStore()
        self.appAssetProvider = MainAppAssetProvider(assetStore: localAssetStore)

        self.appSecretsProvider = MainAppSecretsProvider(assetProvider: appAssetProvider)
        self.networkProvider = BasicNetwork(logProvider: logProvider)
    }
    
   static func makePhotoRepository() -> PhotoRepository {
       let service = MainPhotoService(networkProvider: shared.networkProvider, appSecretsProvider: shared.appSecretsProvider)
       
        let dataSource = MainPhotoDataSource()
        
        return MainPhotoRepository(dataSource: dataSource, service: service)
    }
    
    static func makeErrorHandler() -> MainPhotoErrorHandler {
        MainPhotoErrorHandler()
    }
    
    let logProvider: LogProvider
    private let appAssetProvider: AppAssetProvider
    private let localAssetStore: AssetStore
    private let appSecretsProvider: AppSecretsProvider
    private let networkProvider: NetworkProvider
}
