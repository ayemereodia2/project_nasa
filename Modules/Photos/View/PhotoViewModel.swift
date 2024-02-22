//
//  PhotoViewModel.swift
//  Nasa
//
//  Created by DAVID ODIA on 14/10/2023.
//

import Foundation
import SwiftUI

@MainActor
class PhotoViewModel: ObservableObject {
    @Published private var photo: NasaPhoto?
    @Published var showActivityIndicator = false
    @Published var showErrorMessage = false
    private var errorMessage: String?
    private let repository: PhotoRepository
    private let errorHandler: ErrorHandler
    
    init(
        repository: PhotoRepository = appMain.makePhotoRepository(),
        errorHandler: ErrorHandler = appMain.makeErrorHandler()
    ) {
        self.repository = repository
        self.errorHandler = errorHandler
    }
    
    func fetchPhoto() async {
        Task {
            do {
                showActivityIndicator = true
               let fetchedPhoto = try await repository.fetchPhoto()
                    photo = fetchedPhoto
                    showActivityIndicator = false
            } catch let error as PhotoError {
                errorMessage = errorHandler.handleError(error: error)
                showErrorMessage = true
            }
            catch let error as NetworkError {
                errorMessage = errorHandler.handleError(error: error)
                showErrorMessage = true
            }
       }
    }
    
    func getContentUrl() -> (MediaType?, String?)? {
        switch photo?.media_type {
        case .imageForm:
            return (MediaType.imageForm, photo?.hdurl)
        case .videoForm:
            return (MediaType.videoForm, photo?.hdurl)
        case .none:
            // should never get here
            return (nil,nil)
        }
    }
    
    func getImageTitle() -> String {
        if let photo = photo {
            return photo.title
        }
        return ""
    }
    
    func getImage(url: String) -> Image? {
        guard let image = try? repository.getImage(imageUrl: url) as? Image else {
            return nil
        }
        return image
    }
    
    func storeImage(url: String, image: Image) {
        repository.storeImage(key: url, image: image)
    }
    
    func getErrorTitle() -> String {
        .errorTitle
    }
    
    func okButtonTitle() -> String {
        .okButton
    }
    func tryAgainButtonTitle() -> String {
        .tryAgainButton
    }
    
    func hideProgressView() {
        showActivityIndicator = false
    }
    
    func getErrorMessage() -> String {
        errorMessage ?? ""
    }
    
    typealias appMain = AppDependencyContainer
}

private extension String {
    static let message = "Error Fetching Image"
    static let errorTitle = "error"
    static let okButton = "Ok"
    static let tryAgainButton = "Try Again"
}
