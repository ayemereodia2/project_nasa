//
//  MainPhotoServiceTest.swift
//  NasaTests
//
//  Created by DAVID ODIA on 14/10/2023.
//

import XCTest
@testable import Nasa

final class MainPhotoServiceTest: XCTestCase {
    private var mockNetworkProvider: MockNetworkProvider!
    private var mockAppSecretsProvider: MockAppSecretsProvider!
    private var sut: MainPhotoService!
    
    override func setUp() {
        super.setUp()
        self.mockNetworkProvider = MockNetworkProvider()
        self.mockAppSecretsProvider = MockAppSecretsProvider()
        
        self.sut = MainPhotoService(
            networkProvider: mockNetworkProvider,
            appSecretsProvider: mockAppSecretsProvider)
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func testPhotoServiceWhenFetchIsCalledThenGetNasaSecretsIsCalledTwoTime() {
        let expectation = expectation(description: "Fetch nasa photo")
        // when
        Task {
            
            do {
                _ = try await sut.fetch()
                expectation.fulfill()
                // then
                XCTAssertEqual(mockAppSecretsProvider.getNasaSecretsCount, 2)
                XCTAssertTrue(mockAppSecretsProvider.isGetNasaSecretsCalled)
            } catch {
                XCTFail("Error: \(error)")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)
    }
}

private class MockNetworkProvider: NetworkProvider {
    var isRetrieveCalled = false
    var retrieveCount = 0
    var fakeData: Data?
    
    func retrieve<Response: Decodable>(destination: URL) async throws -> Response? {
        isRetrieveCalled = true
        retrieveCount += 1
        
        guard let data = fakeData else { return nil }
        do {
            let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
            return decodedResponse
        } catch let error as NetworkError {
           throw error
       } catch {
           throw NetworkError.unexpected(
               message: "Failed",
               innerError: "error"
           )
       }
    }
    
}

private class MockAppSecretsProvider: AppSecretsProvider {
    var isGetNasaSecretsCalled = false
    var getNasaSecretsCount = 0
    
    func getNasaSecrets() -> SecretWithApiAndUrl? {
        isGetNasaSecretsCalled = true
        getNasaSecretsCount += 1
        
       return SecretWithApiAndUrl(apiKey: "NNKOjkoul8n1CH18TWA9gwngW1s1SmjESPjNoUFo", url: "https://api.nasa.gov/planetary/apod")
    }
}
