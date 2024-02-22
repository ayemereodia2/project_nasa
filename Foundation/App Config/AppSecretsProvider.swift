//
//  AppSecrets.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

protocol AppSecretsProvider {
    func getNasaSecrets() -> SecretWithApiAndUrl?
}
