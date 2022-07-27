//
//  Reddit.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import Foundation

struct Reddit {
    static func getSubredditByName(_ name: String, completion: @escaping (_: Result<Subreddit, RedditError>) -> Void) {
        makeRedditAPIRequest(urlPath: "/r/\(name)/about") { result in
            switch result {
            case .success(let subredditData):
                if let subreddit = try? JSONDecoder().decode(Subreddit.self, from: subredditData) {
                    completion(.success(subreddit))
                    return
                } else {
                    print("Could not decode the data properly :)")
                    completion(.failure(.invalidResponse))
                }
            case .failure(let error):
                print("getSubredditByName(\(name)) failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
        }
    }
    
    private static func makeRedditAPIRequest(urlPath: String, completion: @escaping (_: Result<Data, RedditError>) -> Void) {
        var apiPath = urlPath
        var redditDomain = ".reddit.com"
        if CurrentUser.shared.isLoggedIn {
            redditDomain = "oauth" + redditDomain
        } else {
            redditDomain = "api" + redditDomain
        }
        
        
        var url = URL(string: "https://\(redditDomain)")!
        if !apiPath.hasPrefix("/") {
            apiPath = "/" + apiPath
        }
        url.append(path: apiPath)
        var request = URLRequest(url: url)
        
        // If the user is logged in, include the OAuth2 Token with the request
        print("User token: \(CurrentUser.shared.token?.accessToken ?? "nil")")
        if CurrentUser.shared.isLoggedIn {
            guard let token = CurrentUser.shared.token else {
                // If the user is registered as logged in, but
                // the token is nil, something weird happened.
                // Cancel the action and return the relevent error
                CurrentUser.shared.isLoggedIn = false
                completion(.failure(.userNotLoggedIn))
                return
            }
            request.allHTTPHeaderFields = ["Authorization": "bearer \(token)"]
        }
        URLSession.shared.dataTask(with: request) { data, HTTPURLResponse, error in
            if let error = error {
                // Check for why the request failed, and return the appropriate error.
                // Until I get to that point, we're just going to log the error to the console
                // and fail the request with RedditError.unknownError
                print("API request to Reddit failed: \(error.localizedDescription). Failing the request as unknownError.")
                completion(.failure(.unknownError))
            }
            if let data = data, data.count > 0 {
                completion(.success(data))
            } else {
                completion(.failure(.noResponse))
            }
        }.resume()

        
        
    }
}

protocol RedditThing {
    var id: String { get }
    var name: String { get }
    var kind: String { get }
    var data: AnyObject { get }
}

protocol Votable: RedditThing {
    var upVotes: Int { get set }
    var downVotes: Int { get set }
    var liked: Bool? { get set} // true = upvote; false = downvote; nil = no vote/no auth
}

protocol Created: RedditThing {
    var createdAt: Date { get }
}



