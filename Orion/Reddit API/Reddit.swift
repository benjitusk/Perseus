//
//  Reddit.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import Foundation

typealias RedditResult<T> = Result<T, RedditError>

// MARK: Code Guidelines:
/// These guidelines will help keep the code in the same pattern and
/// ease the process of debugging. Please adhere to these guidelines
/// for the sake of your fellow developers. Thanks!

// Method Failure:
/// If a method fails for whatever reason and it returns an error, you
/// should print a specific error message *before* returning or calling
/// the completion function. This will help with tracking down where the
/// error messages in the console are coming from.
/// This print statement should look like the following:
/// `print("getSubredditByName failed: \(error.localizedDescription)")`
/// Add additional print messages as needed.

// Static methods
/// All methods in the Reddit struct *must* be static

// Public methods
/// All public methods should be wrappers for the Reddit API.
/// If a method requires user authentication, ensure the user
/// is logged in *before* calling the Reddit API. This check
/// should use the following format:
/// `guard CurrentUser.shared.userAccount != nil else {`
/// and should pass `RedditError.userNotLoggedIn` in the completion.

// Private methods
/// Any method that directly makes a HTTP request to Reddit should be private.
/// When possible, modify the `Reddit.makeRedditAPIRequest` method
/// to accomodate your needs. The goal of this is to reduce repetative code, and
/// of course, to ease debugging. It also ensures that all API requests are following
/// the same predictable pattern.

// (This comment is just to make sure the above comments are not included in the documentation for the Reddit struct)

/// This enum is a namespace for interacting with the Reddit API
enum Reddit {
    /// Cast a vote on a Reddit object, specified by ID
    /// - Parameters:
    ///   - vote: A direction to cast your vote
    ///   - id: The ID of what you're voting on
    ///   - completion: Callback, contains `RedditError?`
    /// - Note: *Authentication required*
    static func castVote(_ vote: VoteDirection, on id: String, completion: @escaping (_: RedditError?) -> Void) {
        guard CurrentUser.shared.userAccount != nil else {
            return completion(.userNotLoggedIn)
        }
        var queryParameters: [URLQueryItem] = []
        queryParameters.append(URLQueryItem(name: "id", value: id))
        queryParameters.append(URLQueryItem(name: "dir", value: String(vote.rawValue)))
        makeRedditAPIRequest(urlPath: "/api/vote", parameters: queryParameters, requestType: .POST) { result in
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let error):
                print("voteCast(on: \(id)) failed: \(error.localizedDescription)")
                completion(error)
            }
        }
    }
    
    /// Get a `StandardSubreddit` using the name of any subreddit
    /// - Parameters:
    ///   - name: The name of the subreddit to get
    ///   - completion: Callback, contains `RedditResult<StandardSubreddit>`
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
    
    static func getAuthenticatedUser(completion: @escaping (_: RedditResult<UserAccount>) -> Void) {
        makeRedditAPIRequest(urlPath: "/api/v1/me", overrideAuth: true) { result in
            switch result {
            case .success(let data):
                if let userAccount = try? JSONDecoder().decode(UserAccount.self, from: data) {
                    completion(.success(userAccount))
                    return
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
            if CurrentUser.shared.userAccount != nil {
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
        
        // If overrideAuth is nil, default to adding token if logged in
        // otherwise, if specified to be true,
        
        if let overrideAuth = overrideAuth {
            if overrideAuth {
                guard let token = CurrentUser.shared.token else {
                    // If the user is registered as logged in, but
                    // the token is nil, something weird happened.
                    // Cancel the action and return the relevent error
                    CurrentUser.shared.signOut()
                    completion(.failure(.userNotLoggedIn))
                    return
                }
                request.allHTTPHeaderFields = ["Authorization": "bearer \(token.accessToken)"]
            }
        } else {
            if let token = CurrentUser.shared.token {
                request.allHTTPHeaderFields = ["Authorization": "bearer \(token.accessToken)"]
            }
        }
        
        if debugMode {
            print("User token: " + (CurrentUser.shared.token?.accessToken ?? "nil"))
            print("API URL: " + url.debugDescription)
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
