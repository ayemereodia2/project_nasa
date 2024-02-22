//
//  MainPhotoRepositoryTest.swift
//  NasaTests
//
//  Created by DAVID ODIA on 14/10/2023.
//

import XCTest
@testable import Nasa
import SwiftUI

final class MainPhotoRepositoryTest: XCTestCase {
    private var mockDataSource: MockPhotoDataSource!
    private var mockPhotoService: MockPhotoService!
    private var sut: MainPhotoRepository!

    override func setUp() {
        super.setUp()
        self.mockDataSource = MockPhotoDataSource()
        self.mockPhotoService = MockPhotoService()
        self.sut = MainPhotoRepository(dataSource: mockDataSource, service: mockPhotoService)

    }

    override class func tearDown() {
        super.tearDown()
    }
    
    func testPhotoRepositoryWhenFetchPhotoIsCalledDataSourceGetIsCalledOneTime() {
        let expectation = expectation(description: "Fetch nasa photo")

        // when
        Task {
            
            do {
                _ = try await sut.fetchPhoto()
                expectation.fulfill()
                // then
                XCTAssertEqual(mockDataSource.getCount, 1)
                XCTAssertTrue(mockDataSource.isGetCalled)
            } catch {
                XCTFail("Error: \(error)")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testPhotoRepositoryWhenFetchPhotoIsCalledServiceFetchIsCalledOneTime() {
        let expectation = expectation(description: "Fetch nasa photo")

        // when
        Task {
            
            do {
                _ = try await sut.fetchPhoto()
                expectation.fulfill()
                // then
                XCTAssertEqual(mockPhotoService.fetchPhotoCount, 1)
                XCTAssertTrue(mockPhotoService.isfetchPhotoCalled)
            } catch {
                XCTFail("Error: \(error)")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testPhotoRepositoryWhenFetchPhotoIsCalledDataSourceSaveIsCalledOneTime() {
        let expectation = expectation(description: "Fetch nasa photo")

        // when
        Task {
            
            do {
                _ = try await sut.fetchPhoto()
                expectation.fulfill()
                // then
                XCTAssertEqual(mockDataSource.saveCount, 1)
                XCTAssertTrue(mockDataSource.isSaveCalled)
            } catch {
                XCTFail("Error: \(error)")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testPhotoRepositoryWhenGetImageIsCalledDataSourceGetIsCalledOneTime() {

        // when
        Task {
            
            do {
                _ = try sut.getImage(imageUrl: "protocol:port//domain/url")
                // then
                XCTAssertEqual(mockDataSource.getCount, 1)
                XCTAssertTrue(mockDataSource.isGetCalled)
            } catch {
                XCTFail("Error: \(error)")
            }
        }
        
    }
    
    func testPhotoRepositoryWhenSaveIsCalledDataSourceSaveIsCalledOneTime() {

        // when
        sut.storeImage(key: "protocol:port//domain/url", image: fakedata)
        // then
        XCTAssertEqual(mockDataSource.saveCount, 1)
        XCTAssertTrue(mockDataSource.isSaveCalled)
        XCTAssertTrue(mockDataSource.fakePhotos.keys.contains("protocol:port//domain/url"))
        
    }
}

private class MockPhotoDataSource: PhotoDataSource {
    var isSaveCalled = false
    var saveCount = 0
    
    var isGetCalled = false
    var getCount = 0
    var fakePhotos = ["key": fakedata]
    
    func save(name: String, photo: Any) {
        isSaveCalled = true
        saveCount += 1
        fakePhotos[name] = photo as? NasaPhoto
    }
    
    func get(name: String) -> Any? {
        isGetCalled = true
        getCount += 1
        return fakePhotos
    }
    
    func flush() {
        
    }
}

private class MockPhotoService: PhotoService {
    var isfetchPhotoCalled = false
    var fetchPhotoCount = 0
    
    func fetch() async throws -> NasaPhoto? {
        isfetchPhotoCalled = true
        fetchPhotoCount += 1
        return fakedata
    }
}
let fakedata = NasaPhoto(copyright: "David Cruz", date: "2023-10-12", explanation: "Mu Cephei is a very large star", hdurl: "https://apod.nasa.gov/apod/image/2310/MuCephei_apod.jpg", media_type: .imageForm, title: "Mu Cephei", url: "https://apod.nasa.gov/apod/image/2310/MuCephei_apod1024.jpg", service_version: "v1")
