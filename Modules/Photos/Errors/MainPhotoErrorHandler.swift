//
//  MainPhotoErrorHandler.swift
//  Nasa
//
//  Created by DAVID ODIA on 14/10/2023.
//

import Foundation

class MainPhotoErrorHandler: ErrorHandler {
    
    func handleError(error: Error) -> String {
        var errorMessage = "An error occured!"
        if let caught = error as? NetworkError {
            switch caught {
            case .unexpected(message: _, innerError: let innerError):
                errorMessage = innerError
            case .non200Code(errorCode: _, message: let message):
                errorMessage = message
            case .noData:
                errorMessage = .message
            }
            return errorMessage
        } else if let caught = error as? PhotoError {
            switch caught {
            case .generalError(message: let message):
                errorMessage = message
            case .invalidUrl(message: let message):
                errorMessage = message
            }
            return errorMessage
        }
        
        return errorMessage
    }
}

private extension String {
    static let message = "Error Fetching Image"
    static let errorTitle = "error"
    static let okButton = "Ok"
    static let tryAgainButton = "Try Again"
}
