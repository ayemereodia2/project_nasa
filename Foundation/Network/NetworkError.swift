//
//  NetworkError.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import Foundation


/**
 This collects all types of errors that can happen while using the `NetworkProvider`
 -conformant classes.
 */
public enum NetworkError: Error, Equatable {
    
    /// An error happened that was unexpected.  An example could be JSON format
    /// failures of response objects
    case unexpected(message: String, innerError: String)

    /// A non-200 series code was returned and extended info
    case non200Code(errorCode: Int, message: String)
    
    /// A response that was supposed to contain Data had none
    case noData
}

