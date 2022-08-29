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
    case decodingError
    case forbidden
    case notFound
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
        case .decodingError:
            return "There was an error decoding the data."
        case .forbidden:
            return "Reddit did not allow the request (HTTP 403)"
        case .notFound:
            return "The requested data couldn't be found (HTTP 404)"
        }
        
    }
}
