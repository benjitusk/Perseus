//
//  CurrentUser.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import Foundation
import UIKit

// Should be an Environment Object, not an Observed Singleton (see https://developer.apple.com/forums/thread/704622 for more info)
class CurrentUser: ObservableObject {
    /// The Current User should have the follwing properties:
    /// `isLoggedIn: Bool`
    /// `authCode: String`
    /// `authState: String`
    /// `username: String`
    
    @Published var isLoggedIn: Bool
    var authCode: String?
    var authState: String?
    var username: String?
    var token: String?
    init() {
        // Check CoreData for an authCode, authState and refreshToken code
        // If they exist, make a call to the Reddit API to confirm the
        // credentials are valid
        self.isLoggedIn = false
    }
    
    func signInPrompt() {
        let clientID = Bundle.main.infoDictionary?["CLIENT_ID"] as! String
        let responseType = "code"
        let state = UUID().uuidString
        let redirectURI = "infrareddit://token"
        let duration = "permanent"
        let scope = ["identity", "edit", "flair", "history", "modconfig", "modflair", "modlog", "modposts", "modwiki", "mysubreddits", "privatemessages", "read", "report", "save", "submit", "subscribe", "vote", "wikiedit"]
        var url = URL(string: "https://www.reddit.com/api/v1/authorize.compact")!
        url.append(queryItems: [URLQueryItem(name: "client_id", value: clientID),
                                URLQueryItem(name: "response_type", value: responseType),
                                URLQueryItem(name: "state", value: state),
                                URLQueryItem(name: "redirect_uri", value: redirectURI),
                                URLQueryItem(name: "duration", value: duration),
                                URLQueryItem(name: "scope", value: scope.joined(separator: " "))
                               ])
        self.authState = state
        UIApplication.shared.open(url)

    }
    
    private func oAuth2Request(_ queryItems: [URLQueryItem], completion: @escaping (Result<RedditToken, Error>) -> Void) {
        let clientID = Bundle.main.infoDictionary?["CLIENT_ID"] as! String
        let clientPassword = "" // Intentionally blank, only for easier readability
        let loginEncodedData = "\(clientID):\(clientPassword)".data(using: .utf8)!.base64EncodedString()
        let url = URL(string: "https://www.reddit.com/api/v1/access_token")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
        let query = components.url!.query()!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = Data(query.utf8)
        request.allHTTPHeaderFields = ["Authorization": "Basic \(loginEncodedData)"]
        URLSession.shared.dataTask(with: request) { data, HTTPURLResponse, error in
            if let error = error {
                completion(.failure(error))
            }
            if (data != nil && data?.count != 0) {
                let token = try? JSONDecoder().decode(RedditToken.self, from: data!)
                if let token = token {
                    completion(.success(token))
                } else {
                    completion(.failure(OAuth2Error.invalidResponse))
                }
            } else {
                completion(.failure(OAuth2Error.noResponse))
            }
        }.resume()
    }
    
    func requestOAuth2Token(authCode: String, state authState: String) {
        guard authState == self.authState else {
            fatalError("Weird circumstance where we are finishing a different auth request than the one we started?! (AUTH1F)")
        }
        let queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: authCode),
            URLQueryItem(name: "redirect_uri", value: "infrareddit://token"),
        ]
        
        oAuth2Request(queryItems) { result in
            switch result {
            case .success(let token):
                // Save to CoreData
                break
            case .failure(let failure):
                // ???
                break
            }
            
        }
    }
    
    func refreshOAuth2Token(_ token: String) {
        let queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh"),
            URLQueryItem(name: "token", value: token),
            URLQueryItem(name: "redirect_uri", value: "infrareddit://token"),
        ]
        
        oAuth2Request(queryItems) { result in
            switch result {
            case .success(let token):
                // Save to CoreData
                break
            case .failure(let failure):
                // ???
                break
            }
            
        }

    }
}

enum OAuth2Error: Error {
    case noResponse
    case unauthorized
    case invalidResponse
}
