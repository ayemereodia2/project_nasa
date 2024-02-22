//
//  NasaPhoto.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

struct NasaPhoto: Codable, Hashable {
    var copyright: String
    var date: String
    var explanation: String
    var hdurl: String
    var media_type: MediaType
    var title: String
    var url: String
    var service_version: String
}

enum MediaType: String, Codable {
    case imageForm = "image"
    case videoForm = "video"
}
