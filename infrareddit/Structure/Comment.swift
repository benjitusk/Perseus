//
//  Comment.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/25/22.
//

import Foundation
class Comment: RedditThing {
    /// The time of creation
    var createdAt: Date
    /// Number of upvotes (includes own)
    var upVotes: Int
    /// Number of downvotes (includes own)
    var downVotes: Int
    /// `true` if thing is liked by the user, `false` if thing is disliked, `nil` if the user has not voted or is not logged in.
    var liked: Bool?
    /// This item's identifier, e.g. "8xwlg"
    var id: String
    /// Fullname of thing, e.g. "t1\_c3v7f8u"
    var name: String
    /// The kind is a String identifier that denotes the object's type.
    var kind: String
    /// A custom data structure used to hold valuable information. This object's format will follow the data structure respective of its kind.
    var data: AnyObject
    /// Who approved this comment. `nil` if not approved or current user is not a mod
    var approvedBy: String?
    /// The account name of the poster
    var author: String // This should be of type User
    init(createdAt: Date, upVotes: Int, downVotes: Int, liked: Bool? = nil, id: String, name: String, kind: String, data: AnyObject, approvedBy: String? = nil, author: String) {
        self.createdAt = createdAt
        self.upVotes = upVotes
        self.downVotes = downVotes
        self.liked = liked
        self.id = id
        self.name = name
        self.kind = kind
        self.data = data
        self.approvedBy = approvedBy
        self.author = author
    }
    enum CodingKeys: String, CodingKey {
        case createdAt
    }
    
    required init(from decoder: Decoder) throws {
        throw "Not implemented yet :)"
    }
}
