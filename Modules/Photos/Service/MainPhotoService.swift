//
//  MainPhotoService.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

class MainPhotoService: PhotoService {
    
    init(
        networkProvider: NetworkProvider,
        appSecretsProvider: AppSecretsProvider
    ) {
        self.networkProvider = networkProvider
        self.appSecretsProvider = appSecretsProvider
    }
    
    func fetch() async throws -> NasaPhoto? {
        guard let validUrl = await buildUrl() else {
            throw PhotoError.invalidUrl(message: "invalid connection url")
        }
        
        return try await networkProvider.retrieve(destination: validUrl)
    }
    
    private func buildUrl() async -> URL? {
        
        let queryComponents =  [
            URLQueryItem(name: "api_key", value: appSecretsProvider.getNasaSecrets()?.apiKey)
        ]
        
        guard let host = getHost() else {
            return nil
        }
       
        return host.appending(queryItems: queryComponents)
            .absoluteURL
    }
    
    private func getHost() -> URL? {
        guard let hostUrl = appSecretsProvider.getNasaSecrets()?.url else { return nil }
        return URL(string: hostUrl)
    }
    
    private let networkProvider: NetworkProvider
    private let appSecretsProvider: AppSecretsProvider
}
