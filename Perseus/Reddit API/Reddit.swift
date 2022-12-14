//
//  Reddit.swift
//  perseus
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
                    print("getSubredditByName(\(name)) failed: Decoding error")
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
    
    /// Get  a `Listing<RedditThing>` from a custom API path
    /// - Parameters:
    ///   - apiPath: The path to request the listing from, using Reddit's API
    ///   - before: Used for pagination, get items before the one with this ID
    ///   - after: Used for pagination, get items after the one with this ID
    ///   - depth: The maximum depth of nested comments, used for comments ONLY
    ///   - completion: Callback, contains `RedditResult<Listing<RedditThing>>`
    static func getCustomListing<RedditData: RedditThing>(type: RedditData.Type, from apiPath: String, with options: [URLQueryItem]? = nil, before: String?, after: String?, count: Int = 20, depth: Int? = nil, debugMode: Bool = false, completion: @escaping(_: RedditResult<Listing<RedditData>>) -> Void) {
        var queryParameters = options ?? []
        if let after = after {
            queryParameters.append(URLQueryItem(name: "after", value: after))
        } else if let before = before {
            queryParameters.append(URLQueryItem(name: "before", value: before))
        }
        if type.self == Comment.self {
            if let depth = depth {
                queryParameters.append(URLQueryItem(name: "depth", value: String(depth)))
            }
        }
        queryParameters.append(URLQueryItem(name: "limit", value: String(count)))
        makeRedditAPIRequest(urlPath: apiPath, parameters: queryParameters, debugMode: debugMode) { result in
            switch result {
            case .success(var data):
                // If it's a comment, the return data contains 2 listings, one with the submission, and one with the comments.
                // We need to only look at the 2nd element in the array:
                if RedditData.self == CommentsAndMore.self {
                    guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                          dict.count >= 2 else {
                        print("The response from \(apiPath) did not contain a comment listing.")
                        completion(.failure(.invalidResponse))
                        return
                    }
                    guard let processedData = try? JSONSerialization.data(withJSONObject: dict[1]) else {
                        print("Could not reserialize [String: Any] -> JSON")
                        completion(.failure(.invalidResponse))
                        return
                    }
                    data = processedData
                }
                
                if let listing = try? JSONDecoder().decode(Listing<RedditData>.self, from: data) {
                    completion(.success(listing))
                    return
                } else {
                    print("getCustomListing(type: \(type), from: \(apiPath)) failed: Decoding error")
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                print("getCustomListing(type: \(type), from: \(apiPath)) failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    static func getMoreComments(from submissionID: String, using moreComments: MoreComments, completion: @escaping(_: RedditResult<[CommentTreeable]>) ->  Void) {
        var loadMore: MoreComments? = nil
        var queryParameters: [URLQueryItem] = []
        queryParameters.append(URLQueryItem(name: "link_id", value: submissionID))
        queryParameters.append(URLQueryItem(name: "id", value: moreComments.id))
        queryParameters.append(URLQueryItem(name: "children", value: {
            var children = ""
            for (index, child) in moreComments.children.enumerated() {
                children += child
                if index > 50 {
                    loadMore = MoreComments(children: Array(moreComments.children.dropFirst(50)),
                                                fullID: moreComments.fullID,
                                                id: moreComments.id,
                                                depth: moreComments.depth,
                                                parentID: moreComments.parentID)
                    return children
                }
                if child != moreComments.children.last! {
                    children += ","
                }
            }
            return children
        }()))

        makeRedditAPIRequest(urlPath: "/api/morechildren", parameters: queryParameters, debugMode: true) { result in
            switch result {
            case .success(let data):
                guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return completion(.failure(.invalidResponse))
                }
                guard let json = dict["json"] as? [String: Any],
                      let nestedData = json["data"] as? [String: Any],
                      let commentsJSON = nestedData["things"] as? [Any] else {
                    return completion(.failure(.invalidResponse))
                }
                guard let commentData = try? JSONSerialization.data(withJSONObject: commentsJSON) else {
                    print("Could not re-serialize JSON comment structure to Foundation.Data")
                    return completion(.failure(.unknownError))
                }
                guard let comments = try? JSONDecoder().decode([CommentsAndMore].self, from: commentData) else {
                    print("getMoreComments(from: \(submissionID), using \(moreComments)) failed: Decoding error")
                    return completion(.failure(.decodingError))
                }
                var treeableData: [CommentTreeable] = []
                for comment in comments {
                    treeableData.append(comment.treeable)
                }
                if let loadMore = loadMore {
                    treeableData.append(loadMore)
                }
                return completion(.success(treeableData))
                
            case .failure(let error):
                print("getMoreComments(from: \(submissionID), using\(moreComments))")
                return completion(.failure(error))
            }
        }
        
    }
    /// Get a `RedditThing` by it's ID
    /// - Parameters:
    ///   - type: The type of `RedditThing` you are trying to get
    ///   - id: The ID of the `RedditThing` you want
    ///   - completion: Callback, contains `RedditResult<type>`
    static func getRedditThingByID<RedditData: RedditThing>(get type: RedditData.Type, for id: String, completion: @escaping (_: RedditResult<RedditData>) -> Void) {
        makeRedditAPIRequest(urlPath: "/api/info", parameters: [URLQueryItem(name: "id", value: id)]) { result in
            switch result {
            case .success(let data):
                if let listing = try? JSONDecoder().decode(Listing<RedditData>.self, from: data) {
                    if let firstElement = listing.children.first {
                        completion(.success(firstElement))
                    } else {
                        print("getRedditThingByID(type: \(type), id: \(id)) failed: No results found")
                        completion(.failure(.notFound))
                    }
                } else {
                    print("getRedditThingByID(type: \(type), id: \(id)) failed: Decoding error")
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                print("getRedditThingByID(type: \(type), id: \(id)) failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    /// Get relevant data for the authenticated user
    /// - Parameter completion: Callback, contains `RedditResult<UserAccount>`
    /// - Note: *Requires Authentication*
    static func getAuthenticatedUser(completion: @escaping (_: RedditResult<UserAccount>) -> Void) {
        makeRedditAPIRequest(urlPath: "/api/v1/me", overrideAuth: true) { result in
            switch result {
            case .success(let data):
                if let userAccount = try? JSONDecoder().decode(UserAccount.self, from: data) {
                    completion(.success(userAccount))
                    return
                } else {
                    print("getAuthenticatedUser failed: Decoding error")
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                print("getAuthenticatedUser failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    /// Directly interact with the Reddit API.
    /// All API requests must internally use this method.
    /// - Parameters:
    ///   - urlPath: The API endpoint to hit
    ///   - parameters: Data passed with the request, in the URL if the method is GET or DELETE, and in the body if it's PATCH, PUT, or POST
    ///   - requestType: The HTTP request type to use
    ///   - debugMode: Prints out debug data about the API call when enabled
    ///   - overrideAuth: If true, force using the authentication, if false, ignore the token, if nil, include the token if the user is logged in
    ///   - completion: Callback, contains `RedditResult<Data>`
    private static func makeRedditAPIRequest(urlPath: String, parameters: [URLQueryItem] = [], requestType: RequestType = .GET, debugMode: Bool = false, overrideAuth: Bool? = nil, completion: @escaping (_: RedditResult<Data>) -> Void) {
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
        url.append(queryItems: [
            URLQueryItem(name: "api_type", value: "json"),
            URLQueryItem(name: "raw_json", value: "1"),
        ])
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        
        // If overrideAuth is nil, default to adding token if logged in,
        // and not adding it if the user is not logged in.
        // If specified to be true, force using the token,
        // and fail if the user is not logged in.
        // If specified to be false, do not include the token,
        // even if the user is logged in
        
        if let overrideAuth = overrideAuth {
            if overrideAuth {
                guard let token = CurrentUser.shared.token else {
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
            printDebugInformation()
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Check for why the request failed, and return the appropriate error.
                // Until I get to that point, we're just going to log the error to the console
                // and fail the request with RedditError.unknownError
                print("API request to Reddit failed: \(error.localizedDescription). Failing the request as unknownError.")
                completion(.failure(.unknownError))
            }
            guard let response = response as? HTTPURLResponse else {
                print("Could not get status of response.")
                completion(.failure(.invalidResponse))
                return
            }
            switch response.statusCode {
            case 200...299:
                break
            case 400:
                completion(.failure(.badRequest))
                return
            case 403:
                completion(.failure(.forbidden))
                return
            case 404:
                completion(.failure(.notFound))
                return
            default:
                print("Received a HTTP response code \(response.statusCode) from the following request:")
                printDebugInformation()
            }
            
            if let data = data, data.count > 0 {
                completion(.success(data))
            } else {
                print("API request to Reddit failed: No data was returned.")
                completion(.failure(.noResponse))
            }
        }.resume()
        
        func printDebugInformation() {
            print("***** API REQUEST *****")
            print("* User is authenticated: \((CurrentUser.shared.userAccount != nil).description)")
            print("* User token: " + (CurrentUser.shared.token?.accessToken ?? "nil"))
            print("* Authentication Override: \(overrideAuth?.description ?? "not set.")")
            print("* HTTP Method: \(request.httpMethod ?? "WARNING: HTTP METHOD IS nil, DEFAULTING TO 'GET'")")
            print("* Request body: \(String(data: (request.httpBody ?? "Empty".data(using: .utf8))!, encoding: .utf8)!)")
            print("* URL: \(request.url!.description)")
            print("***********************\n")

        }
        
    }
    
    enum VoteDirection: Int {
        case up = 1
        case unset = 0
        case down = -1
    }
    
    enum Distinguish: String, Codable {
        case moderator, admin, special
    }
    
    private enum RequestType: String {
        case GET
        case POST
        case PUT
        case PATCH
        case DELETE
    }
}
