//
//  HttpHelper.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

struct HttpHelper {
  func makeUrl(with userID: String) -> URLRequest? {
    guard let url = URL(string:"https://example.com/api/users/\(userID)")
    else {return nil }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    return request
  }
}
