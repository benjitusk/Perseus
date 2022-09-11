//
//  ListingModel.swift
//  perseus
//
//  Created by Benji Tusk on 8/16/22.
//

import SwiftUI
/// This class is responsible for consuming `Listings` and making Reddit requests to load content
class ListingModel<RedditData: RedditThing>: ObservableObject {
    private let apiEndpoint: String
    private let queryParameters: [URLQueryItem]?
    private var before: String = ""
    private var after: String = ""
    private var count: Int = 0 // Might not need this, we could just use children.count
    @Published var children: [RedditData]? = nil
    
    init(apiEndpoint: String, queryParameters: [URLQueryItem]? = nil) {
        self.apiEndpoint = apiEndpoint
        self.queryParameters = queryParameters
    }
    
    func load(the direction: LoadDirection, _ count: Int, depth: Int = 10, debugMode: Bool = false, completion: @escaping (_: RedditError?) -> Void) {
       // This works by internally requesting a listing containing
        // the next content, and appending or inserting the new element
        Reddit.getCustomListing(type: RedditData.self, from: apiEndpoint, with: queryParameters, before: before, after: after, count: count, depth: depth, debugMode: debugMode) { result in
            switch result {
            case .success(let listing):
                DispatchQueue.main.async {
                    if self.children == nil {
                        self.children = []
                    }
                    switch direction {
                    case .next:
                        self.after = listing.after
                        self.children!.append(contentsOf: listing.children)
                    case .previous:
                        self.before = listing.before
                        self.children!.insert(contentsOf: listing.children, at: 0)
                    }
                }
                completion(nil)
            case .failure(let error):
                print("Couldn't load content for a ListingModel: \(error.localizedDescription)")
                completion(error)
            }
        }
    }
    
    enum LoadDirection: String {
        case next, previous
    }
}
