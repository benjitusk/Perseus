//
//  RedditErrors.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/25/22.
//

import Foundation
enum RedditError: Error {
    case noResponse
    case invalidResponse
    case unauthorized
    case userNotLoggedIn
    case unknownError
}

extension RedditError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Either the server returned invalid data, or we are not handling the data properly."
        case .unknownError:
            return "An unspecified error has occured. Try searching the code for all cases where this error is passed."
        case .userNotLoggedIn:
            return "The requested operation could not be performed because the user is not logged in."
        case .unauthorized:
            return "The requested operation could not be performed becuase the authenticated user does not have sufficient permissions."
        case .noResponse:
            return "The server did not return a response."
        }
        
    }
}
