//
//  Listing.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/27/22.
//

import Foundation
/// This is strictly a DATA STRUCTURE. Do not use the Reddit namespace here
final class Listing<RedditData: RedditThing>: Decodable {
    var after: String
    var dist: Int
    var children: [RedditData]
    var before: String
    var totalLoaded: Int
        
    enum RootKeys: CodingKey {
        case kind, data
    }
    
    enum CodingKeys: String, CodingKey {
        case after
        case before
        case children
        case dist
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let container = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.after = try container.decodeIfPresent(String.self, forKey: .after) ?? ""
        self.before = try container.decodeIfPresent(String.self, forKey: .before) ?? ""
        self.children = try container.decode([RedditData].self, forKey: .children)
        self.dist = try container.decode(Int.self, forKey: .dist)
        self.totalLoaded = children.count
    }
}
