//
//  Misc Protocols.swift
//  perseus
//
//  Created by Benji Tusk on 9/12/22.
//

import Foundation

protocol RedditThing: Decodable, Identifiable, Equatable {
    associatedtype CodingKeys: RawRepresentable where CodingKeys.RawValue: StringProtocol
}

protocol Subreddit {
    var displayName: String { get }
    var apiURL: String { get }
}

protocol HasAuthor {
    var author: Author { get }
}
