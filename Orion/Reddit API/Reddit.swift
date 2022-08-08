//
//  Reddit.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import Foundation

typealias RedditResult<T> = Result<T, RedditError>

struct Reddit {
    static func getSubredditByName(_ name: String, completion: @escaping (_: RedditResult<StandardSubreddit>) -> Void) {
        makeRedditAPIRequest(urlPath: "/r/\(name)/about") { result in
            switch result {
            case .success(let subredditData):
                if let subreddit = try? JSONDecoder().decode(StandardSubreddit.self, from: subredditData) {
                    completion(.success(subreddit))
                    return
                } else {
                    print("Could not decode the data properly :)")
                    completion(.failure(.decodingError))
                    return
                }
                
            case .failure(let error):
                print("getSubredditByName(\(name)) failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
        }
    }
    
    static func getCustomSubmissionsListing(for apiPath: String, before: String?, after: String?, completion: @escaping (_: RedditResult<Listing<Submission>>) -> Void) {
        var queryParameters: [URLQueryItem] = []
        if after != nil {
            queryParameters.append(URLQueryItem(name: "after", value: after))
        } else {
            queryParameters.append(URLQueryItem(name: "before", value: before))
        }
        queryParameters.append(URLQueryItem(name: "limit", value: "20"))
        makeRedditAPIRequest(urlPath: apiPath, parameters: queryParameters, debugMode: true) { result in
            switch result {
            case .success(let data):
                if let listing = try? JSONDecoder().decode(Listing<Submission>.self, from: data) {
                    completion(.success(listing))
                    return
                } else {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                print("An error occured while performing your custom API call: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    static func getRedditThingByID<RedditData: RedditThing>(get type: RedditData.Type, for id: String, completion: @escaping (_: RedditResult<RedditData>) -> Void) {
        makeRedditAPIRequest(urlPath: "/api/info", parameters: [URLQueryItem(name: "id", value: id)]) { result in
            switch result {
            case .success(let data):
                if let listing = try? JSONDecoder().decode(Listing<RedditData>.self, from: data) {
                    if let firstElement = listing.children.first {
                        completion(.success(firstElement))
                    } else {
                        completion(.failure(.noResponse))
                    }
                } else {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getSubredditListing(subreddit: Subreddit, before: String?, after: String?, completion: @escaping (_: Result<Listing<Submission>, RedditError>) -> Void) {
        var queryParameters: [URLQueryItem] = []
        if after != nil {
            queryParameters.append(URLQueryItem(name: "after", value: after))
        } else {
            queryParameters.append(URLQueryItem(name: "before", value: before))
        }
        queryParameters.append(URLQueryItem(name: "limit", value: "1"))
        var urlPath = ""
        if let subreddit = subreddit as? StandardSubreddit {
            urlPath = "r/\(subreddit.displayName)"
        } else if let subreddit = subreddit as? SpecialSubreddit {
            urlPath = subreddit.apiURL
        }
        makeRedditAPIRequest(urlPath: urlPath, parameters: queryParameters, debugMode: true, overrideAuth: false) { result in
            switch result {
            case .success(let submissionsData):
                if let listing = try? JSONDecoder().decode(Listing<Submission>.self, from: submissionsData) {
                    completion(.success(listing))
                    return
                } else {
                    print("Error decoding listing for subreddit \(subreddit.displayName)")
                    completion(.failure(.decodingError))
                    return
                }
            case .failure(let error):
                print("getSubredditListing(subreddit: \(subreddit.displayName), before: \(before ?? "nil"), after: \(after ?? "nil") failed:\n\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    private static func makeRedditAPIRequest(urlPath: String, parameters: [URLQueryItem] = [], debugMode: Bool = false, overrideAuth: Bool? = nil, completion: @escaping (_: RedditResult<Data>) -> Void) {
        var apiPath = urlPath
        var redditDomain = ".reddit.com"

        if let overrideAuth = overrideAuth {
            if overrideAuth {
                redditDomain = "oauth" + redditDomain
            } else {
                redditDomain = "api" + redditDomain
            }
        } else {
            if CurrentUser.shared.isLoggedIn {
                redditDomain = "oauth" + redditDomain
            } else {
                redditDomain = "api" + redditDomain
            }
        }
        
        
        var url = URL(string: "https://\(redditDomain)")!
        if !apiPath.hasPrefix("/") {
            apiPath = "/" + apiPath
        }
        url.append(path: apiPath)
        url.append(queryItems: parameters)
        url.append(queryItems: [URLQueryItem(name: "raw_json", value: "1")])
        var request = URLRequest(url: url)
        
        if debugMode {
            // If the user is logged in, include the OAuth2 Token with the request
            print("User token: \(CurrentUser.shared.token?.accessToken ?? "nil")")
        }
        
        // If overrideAuth is nil, default to adding token if logged in
        // otherwise, if specified to be true,
        
        if let overrideAuth = overrideAuth {
            if overrideAuth {
                guard let token = CurrentUser.shared.token else {
                    // If the user is registered as logged in, but
                    // the token is nil, something weird happened.
                    // Cancel the action and return the relevent error
                    CurrentUser.shared.isLoggedIn = false
                    completion(.failure(.userNotLoggedIn))
                    return
                }
                request.allHTTPHeaderFields = ["Authorization": "bearer \(token.accessToken)"]
            }
        } else {
            if CurrentUser.shared.isLoggedIn {
                guard let token = CurrentUser.shared.token else {
                    CurrentUser.shared.isLoggedIn = false
                    completion(.failure(.userNotLoggedIn))
                    return
                }
                request.allHTTPHeaderFields = ["Authorization": "bearer \(token.accessToken)"]
            }
        }
        
        if debugMode {
            print(url.debugDescription)
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

protocol RedditThing: Decodable, Identifiable {
//    var id: String { get }
//    var name: String { get }
//    var kind: String { get }
//    var data: AnyObject { get }
    associatedtype CodingKeys: RawRepresentable where CodingKeys.RawValue: StringProtocol
}

protocol Subreddit {
    
    var displayName: String { get }
    
    func getPosts(by sortingMethod: StandardSubreddit.SortingMethod, before: String?, after: String?, completion: @escaping (_: RedditResult<Listing<Submission>>) -> Void)
}
