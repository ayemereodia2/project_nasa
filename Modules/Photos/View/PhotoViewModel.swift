//
//  PhotoViewModel.swift
//  Nasa
//
//  Created by DAVID ODIA on 14/10/2023.
//

import SwiftUI

@MainActor
final class PhotoViewModel: PhotoViewModelProtocol {
  // MARK: - Published State
  
  @Published private var photo: NasaPhoto?
  @Published private var internalErrorMessage: String?
  @Published var showActivityIndicator = false
  @Published var showErrorMessage = false
  @Published  var isFullScreen = false
  @Published  var shouldShowTitle = false
  
  // MARK: - Dependencies
  
  private let repository: PhotoRepository
  private let errorHandler: ErrorHandler
  
  // MARK: - Init
  
  init(
    repository: PhotoRepository = AppDependencyContainer.makePhotoRepository(),
    errorHandler: ErrorHandler = AppDependencyContainer.makeErrorHandler()
  ) {
    self.repository = repository
    self.errorHandler = errorHandler
  }
  
  
  func showTitle() {
    shouldShowTitle = true
  }
  
  func fullScreen() {
    isFullScreen.toggle()
  }
  
  func fetchPhoto() async {
    showActivityIndicator = true
    
    do {
      let fetchedPhoto = try await repository.fetchPhoto()
      photo = fetchedPhoto
      shouldShowTitle = true
    } catch let error as PhotoError {
      handleError(with: errorHandler.handleError(error: error))
      showErrorMessage = true
    } catch let error as NetworkError {
      handleError(with: errorHandler.handleError(error: error))
      showErrorMessage = true
    } catch {
      handleError(with: error.localizedDescription)
      showErrorMessage = true
    }
    
    showActivityIndicator = false
  }
  
  // MARK: - Additional Helpers
  
  func getContentUrl() -> (MediaType?, String?)? {
    guard let mediaType = photo?.media_type else {
      return (nil, nil)   // Should not normally happen
    }
    
    switch mediaType {
    case .imageForm:
      return (.imageForm, photo?.hdurl)
    case .videoForm:
      return (.videoForm, photo?.hdurl)
    }
  }
  
  func getImage(url: String) -> Image? {
    // Assuming repository returns something convertible to SwiftUI.Image
    guard let image = try? repository.getImage(imageUrl: url) as? Image else {
      return nil
    }
    return image
  }
  
  func storeImage(url: String, image: Image) {
    repository.storeImage(key: url, image: image)
  }
  
  func handleError(with message: String) {
    internalErrorMessage = message
  }
  
  func dismiss() {
    showErrorMessage = false
  }
}

extension PhotoViewModel {
  // MARK: - Computed properties
  
  var imageTitle: String {
    guard let photo = photo else { return "" }
    return photo.title
  }
  
  // MARK: - Helpers
  var errorTitle: String {
    .errorTitle
  }
  
  var errorMessage: String {
    internalErrorMessage ?? .defaultErrorMessage
  }
  
  var okButtonTitle: String {
    .okButton
  }
  
  var tryAgainButtonTitle: String {
    .tryAgainButton
  }
}

// MARK: - Strings

private extension String {
  static let defaultErrorMessage = "Try again later."
  static let errorTitle = "Error"
  static let okButton = "OK"
  static let tryAgainButton = "Try Again"
}

protocol PhotoViewModelProtocol: ObservableObject {
  func fetchPhoto() async
}
