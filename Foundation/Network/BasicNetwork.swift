//
//  BasicNetwork.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation

class BasicNetwork: NetworkProvider {
    
    init(
        logProvider: LogProvider
    ) {
        self.logProvider = logProvider

        let config = URLSessionConfiguration.default
        
        let headers: [AnyHashable : Any] = [
            "Content-Type" : "application/json; charset=utf-8"
        ]
        config.httpAdditionalHeaders = headers
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 15
        
        self.session = URLSession(configuration: config)
    }
    
    func retrieve<Response: Decodable>(destination: URL) async throws -> Response? {

        var request = URLRequest(url: destination)
        request.httpMethod = HTTPMethod.get.rawValue
        
        do {
            let (data, response) = try await self.session.data(for: request)
            
            return try confirmResponse(
                data: data,
                response: response,
                type: Response.self,
                method: request.httpMethod,
                url: destination,
                requestBody: EmptyBody()
            )
        } catch let error as NetworkError {
            throw error
        } catch let error {
          print(error)
            throw NetworkError.unexpected(
                message: "Network Error",
                innerError: "Check your connection"
            )
        }
    }
    
    private func confirmResponse<Response: Decodable>(
        data: Data,
        response: URLResponse,
        type: Response.Type? = nil,
        method: String?,
        url: URL,
        requestBody: Body
    ) throws -> Response? {
        //check to make sure that we have a good clean response.
        //First, do we have a 200-299?
        guard let httpResponse = response as? HTTPURLResponse else {

            throw NetworkError.unexpected(
                message: "Returned a non-HTTPURLResponse (very strange!)", innerError: "An error occured"
            )
        }
        
        let code = httpResponse.statusCode
        guard (200...299).contains(code) else {
            
        
            do {
                var _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                logProvider.error(message: "Parsing error: failed to JSON-decode non-200 response")
            }
            

            throw NetworkError.non200Code(errorCode: code, message: "Parsing error: failed to JSON-decode non-200 response")
        }
        
        //Ok, at this point, if the type to decode is nil, we're done
        guard let type = type else {
            return nil //this is ok, just means nothing to decode
        }
        
        //If we got a 204, there's nothing to get, so let's return nil
        if code == 204 {
            return nil
        }
        
        //If the Response type is Data, return the data as is without going
        //through the parsing operation
        if type == Data.self {
            return data as? Response
        }
        
        do {
            return try JSONDecoder().decode(type, from: data)
        
        } catch {

            throw error
        }
    }
    
    private let logProvider: LogProvider
    private let session: URLSession
}

public protocol Body: Encodable {
    func asData() -> Data
}


extension Body {
    public func asData() -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return (try? encoder.encode(self)) ?? Data()
    }
}

struct EmptyBody: Body {
    func asData() -> Data {
        Data()
    }
}
