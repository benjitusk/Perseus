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
    static var shared = CurrentUser()
    /// The Current User should have the follwing properties:
    /// `isLoggedIn: Bool`
    /// `authCode: String`
    /// `authState: String`
    /// `username: String`
    
    var authCode: String?
    var authState: String?
    var username: String?
    var token: RedditToken?
    @Published var userAccount: UserAccount?
    private init() {
        // Check Keychain for an oauth token.
        // If it exists, make a call to the Reddit API to confirm the
        // credentials are valid
        
        self.userAccount = nil
        loadTokenFromKeychain()
        guard let token = self.token else {
            // Don't show signInPrompt on init, it's not nice
            // self.signInPrompt()
            return
        }
        
        if token.expiry < Int(Date.now.timeIntervalSince1970) {
            Task.detached {
                await self.refreshOAuth2Token(token)
            }
        }
        
//        Reddit.getAuthenticatedUser() { result in
//            switch result {
//            case .success(let account):
//                self.userAccount = account
//            case .failure(let error):
//                print("Couldn't get authenticated user: \(error.localizedDescription)")
//            }
//        }
    }
    
    func loadTokenFromKeychain() {
        self.token = KeychainHelper.shared.read(service: "oauth-token", account: "reddit.com", type: RedditToken.self)
    }
    
    func signInPrompt() {
        let clientID = Bundle.main.infoDictionary?["CLIENT_ID"] as! String
        let responseType = "code"
        let state = UUID().uuidString
        let redirectURI = "orion://token"
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
        // This value should be set in <projectroot>/Orion/Config.xcconfig
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
                    completion(.failure(RedditError.invalidResponse))
                }
            } else {
                completion(.failure(RedditError.noResponse))
            }
        }.resume()
    }
    
    func requestOAuth2Token(authCode: String, state authState: String) {
        guard authState == self.authState else {
            return
//            fatalError("Weird circumstance where we are finishing a different auth request than the one we started?! (AUTH1F)")
        }
        let queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: authCode),
            URLQueryItem(name: "redirect_uri", value: "orion://token"),
        ]
        
        oAuth2Request(queryItems) { result in
            switch result {
            case .success(let token):
                self.signIn(with: token)
                print("OAuth Token: \(token)")
            case .failure(let failure):
                print("An error occured while refreshing the OAuth token: \(failure.localizedDescription)")
                self.signOut()
            }
            
        }
    }
    
    func refreshOAuth2Token(_ token: RedditToken) async {
        print("refreshing token")
        let queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "token", value: token.refreshToken),
        ]
        
        oAuth2Request(queryItems) { result in
            switch result {
            case .success(let token):
                self.signIn(with: token)
                break
            case .failure(let failure):
                // Sign out the user
                self.signOut()
                print("An error occured while refreshing the OAuth token: \(failure.localizedDescription)")
                break
            }
            
        }

    }
    
    func signOut() {
        self.token = nil
        DispatchQueue.main.async {
            self.userAccount = nil
        }
        KeychainHelper.shared.delete(service: "oauth-token", account: "reddit.com")
    }
    
    func signIn(with token: RedditToken) {
        self.token = token
        self.token?.expiry = Int(Date.now.timeIntervalSince1970) + token.expiry
        KeychainHelper.shared.save(self.token, service: "oauth-token", account: "reddit.com")
        Reddit.getAuthenticatedUser() { result in
            switch result {
            case .success(let account):
                DispatchQueue.main.async {
                    self.userAccount = account
                }
            case .failure(let error):
                print("Couldn't get authenticated user: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.userAccount = nil
                }
            }
        }
    }
}
