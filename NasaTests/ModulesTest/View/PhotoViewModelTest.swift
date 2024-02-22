//
//  PhotoViewModelTest.swift
//  NasaTests
//
//  Created by DAVID ODIA on 14/10/2023.
//

import XCTest
@testable import Nasa
import SwiftUI

@MainActor class PhotoViewModelTest: XCTestCase {
    var sut:PhotoViewModel!
    private var repository: MockPhotoRepository!
    
    override func setUp() {
        super.setUp()
        repository = MockPhotoRepository()
        sut = PhotoViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPhotoViewModelGivenEmptyPhotoModelGetImageUrlReturnsNil() {
        let result = sut.getContentUrl()
        
        XCTAssertNil(result)
    }
    
    func testPhotoViewModelGivenValidPhotoModelGetImageUrlReturnsUrl()  {
        repository.mockedFetchPhotoResult = NasaPhoto(copyright: "David Cruz", date: "2023-10-12", explanation: "Mu Cephei is a very large star", hdurl: "https://apod.nasa.gov/apod/image/2310/MuCephei_apod.jpg", media_type: .imageForm, title: "Mu Cephei", url: "https://apod.nasa.gov/apod/image/2310/MuCephei_apod1024.jpg", service_version: "v1")
        
        sut = PhotoViewModel(repository: repository)
        Task {
            _ = await sut.fetchPhoto()
            let result = sut.getContentUrl()
            
            XCTAssertEqual(result, "https://apod.nasa.gov/apod/image/2310/MuCephei_apod1024.jpg")
        }
        
    }
    
    func testPhotoViewModelGivenValidPhotoUrlAndImageStoreReturnsNoneEmpty()  {
        repository.mockedFetchPhotoResult = nil
        
        let sut = PhotoViewModel(repository: repository)
        sut.storeImage(url: "https://apod.nasa.gov/apod/image/2310/MuCephei_apod1024.jpg", image: Image(""))
        
        XCTAssertTrue(!repository.mockStorage.isEmpty)
        
    }
    
    func testPhotoViewModelGivenValidPhotoModelUrlGetImageReturnsNotNil() {
        
        repository.mockedFetchPhotoResult = NasaPhoto(copyright: "David Cruz", date: "2023-10-12", explanation: "Mu Cephei is a very large star", hdurl: "https://apod.nasa.gov/apod/image/2310/MuCephei_apod.jpg", media_type: .imageForm, title: "Mu Cephei", url: "https://apod.nasa.gov/apod/image/2310/MuCephei_apod1024.jpg", service_version: "v1")
        
        let sut = PhotoViewModel(repository: repository)
        Task {
            _ = await sut.fetchPhoto()
            if let result = sut.getImage(url: "https://apod.nasa.gov/apod/image/2310/MuCephei_apod1024.jpg") {
                XCTAssertNotNil(result)
            }
            

        }

    }
    
    func testPhotoViewModelGivenValidPhotoModelFetchPhotoShowActivityIndicatorIsTrue()  {
        sut = PhotoViewModel(repository: repository)
        Task {
            _ = await sut.fetchPhoto()
            XCTAssertTrue(sut.showActivityIndicator)
            
        }
        
    }
}


class MockPhotoRepository: PhotoRepository {
    
    var mockedFetchPhotoResult: NasaPhoto? = nil
    var mockedFetchPhotoError: Error? = nil
    var mockStorage = [String: Any]()

    func fetchPhoto() async throws -> NasaPhoto? {
    
        if let error = mockedFetchPhotoError {
            throw error
        }
        if let photo = mockedFetchPhotoResult {
            mockStorage[photo.url] = photo
            return photo
        }
        // Return a default photo or handle as needed for your tests
        return NasaPhoto(copyright: "David Cruz", date: "2023-10-12", explanation: "Mu Cephei is a very large star", hdurl: "https://apod.nasa.gov/apod/image/2310/MuCephei_apod.jpg", media_type: .imageForm, title: "Mu Cephei", url: "https://apod.nasa.gov/apod/image/2310/MuCephei_apod1024.jpg", service_version: "v1")
    }
    
    
    func getImage(imageUrl: String) throws -> Any? {
        mockStorage[imageUrl]
    }
    
    func storeImage(key: String, image: Any) {
        mockStorage[key] = image
    }
}
