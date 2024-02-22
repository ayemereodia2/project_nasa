//
//  CachedNetworkTests.swift
//  NasaTests
//
//  Created by DAVID ODIA on 13/10/2023.
//

import XCTest
@testable import Nasa

final class CachedNetworkTests: XCTestCase {
    private var networkProvider: MockNetworkProvider!
    let urlString = "https://api.nasa.gov/planetary/apod?api_key=NNKOjkoul8n1CH18TWA9gwngW1s1SmjESPjNoUFo"
    
    override func setUp() {
        super.setUp()
        // Use the mock network provider for testing
        networkProvider = MockNetworkProvider()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func testRetrieveCachedData() {
        // Perform the test
        let expectation = XCTestExpectation(description: "Retrieve cached data")
        Task {
            do {
                guard let url = URL(string: urlString) else {
                    XCTFail("Invalid url")
                    return
                }
                
                networkProvider.fakeData = """
                        {"copyright":"David Cruz","date":"2023-10-12","explanation":"Mu Cephei is a very large star.","hdurl":"https://apod.nasa.gov/apod/image/2310/MuCephei_apod.jpg","media_type":"image","service_version":"v1","title":"Mu Cephei","url":"https://apod.nasa.gov/apod/image/2310/MuCephei_apod1024.jpg"}
                    """.data(using: .utf8)!
                
                let cachedData: NasaPhoto? = try await networkProvider.retrieve(destination: url)
                XCTAssertNotNil(cachedData)
                XCTAssertEqual(cachedData?.copyright, "David Cruz")
                XCTAssertEqual(cachedData?.hdurl, "https://apod.nasa.gov/apod/image/2310/MuCephei_apod.jpg")
                XCTAssertEqual(cachedData?.date, "2023-10-12")
                XCTAssertEqual(cachedData?.explanation, "Mu Cephei is a very large star.")
                XCTAssertEqual(cachedData?.media_type, .imageForm)
                XCTAssertEqual(cachedData?.title, "Mu Cephei")
                XCTAssertEqual(cachedData?.url, "https://apod.nasa.gov/apod/image/2310/MuCephei_apod1024.jpg")
                XCTAssertEqual(cachedData?.service_version, "v1")
                expectation.fulfill()
            } catch {
                XCTFail("Error occurred: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testNetworkError() {
        Task {
           
            do {
                
                guard let url = URL(string: urlString) else {
                    XCTFail("Invalid url")
                    return
                }
                
                networkProvider.fakeData = """
                        {"gopyright":"David Cruz","cate":"2023-10-12","explanation":"Mu Cephei is a very large star.","hdurl":"https://apod.nasa.gov/apod/image/2310/MuCephei_apod.jpg","media_type":"image","service_version":"v1","title":"Mu Cephei","url":"https://apod.nasa.gov/apod/image/2310/MuCephei_apod1024.jpg"}
                    """.data(using: .utf8)!
                
                let _: NasaPhoto? = try await networkProvider.retrieve(destination: url)

            } catch let error {
                XCTAssertTrue(error is NetworkError)
                // Verify that our error is equal to what we expect
                XCTAssertEqual(error as? NetworkError, .unexpected(message: "Failed", innerError: "error"))
            }
        }
    }


}


// Define a mock network provider
private class MockNetworkProvider: NetworkProvider {
    var fakeData: Data?
    
    func retrieve<Response: Decodable>(destination: URL) async throws -> Response? {
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
