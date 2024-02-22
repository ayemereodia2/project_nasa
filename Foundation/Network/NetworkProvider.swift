//
//  NetworkProvider.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

/**
 This provider declares how a system that will facilitate communication  with a remote
 resource will work.  It condenses the basic network activity "send", "send and get",
 and "get", into well-definied methods suitable for consumption by a Service.
 */
public protocol NetworkProvider {
    
    /**
     Requests information based on the Generic constraint that must conform to
     Decodable from the given microservice url.  This will always use "GET" as
     the HTTP Method.
     
     Note that the return type CAN be nil, because it is possible that the server
     does not have any data to return.
     
     Also, if the Response type is Data, the returned value will not go through
     any parsing, but will return the raw data buffer from the network, leaving
     the caller to perform any parsing needed.
     
     - parameters:
         - destination:  The URL for the request
     
     - throws: A `NetworkError`
     */
    func retrieve<Response: Decodable>(destination: URL) async throws -> Response?
}
