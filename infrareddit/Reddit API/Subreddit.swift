//
//  Subreddit.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/25/22.
//

import Foundation
final class Subreddit: Decodable {
    // TODO: Conform Subreddit to Decodable
    let activeAccounts: Int
    let description: String
    let displayName: String
    let headerImg: URL
    let isNSFW: Bool
    let subscribers: Int
    let allowedSubmissionType: Submission.SubmissionType
    let subredditType: SubredditType
    let title: String
    let relativeURL: String
    
    /// The following user properties are `false` if the user is not authenticated
    let userIsBanned: Bool
    let userIsContributer: Bool
    let userIsModerator: Bool
    let userIsSubscriber: Bool
    
    init(activeAccounts: Int, description: String, displayName: String, headerImg: URL, isNSFW: Bool, subscribers: Int, allowedSubmissionType: Submission.SubmissionType, subredditType: SubredditType, title: String, relativeURL: String, userIsBanned: Bool, userIsContributer: Bool, userIsModerator: Bool, userIsSubscriber: Bool) {
        self.activeAccounts = activeAccounts
        self.allowedSubmissionType = allowedSubmissionType
        self.description = description
        self.displayName = displayName
        self.headerImg = headerImg
        self.isNSFW = isNSFW
        self.relativeURL = relativeURL
        self.subscribers = subscribers
        self.subredditType = subredditType
        self.title = title
        self.userIsBanned = userIsBanned
        self.userIsContributer = userIsContributer
        self.userIsModerator = userIsModerator
        self.userIsSubscriber = userIsSubscriber
    }
    
    enum SubredditType: String, Decodable {
        case archived
        case goldRestricted = "gold_restricted"
        case `private`
        case `public`
        case restricted
    }
    
    enum RootKeys: CodingKey {
        case kind
        case data
    }
    
    enum CodingKeys: String, CodingKey {
        case activeAccounts = "accounts_active"
        case allowedSubmissionType = "submission_type"
        case description
        case displayName = "display_name_prefixed"
        case headerImage = "header_img"
        case isNSFW = "over18"
        case relativeURL = "url"
        case subredditType = "subreddit_type"
        case subscribers
        case title
        case userIsBanned = "user_is_banned"
        case userIsContributer = "user_is_contributor"
        case userIsModerator = "user_is_moderator"
        case userIsSubscriber = "user_is_subscriber"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self).nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        /// The `Decoder.container.decode` method uses the `forKey` parameter as a lookup in the `CodingKeys` enum to know what key to decode from the data
        activeAccounts          = try container.decode(Int.self, forKey: .activeAccounts)
        allowedSubmissionType   = try container.decode(Submission.SubmissionType.self, forKey: .allowedSubmissionType)
        description             = try container.decode(String.self, forKey: .description)
        displayName             = try container.decode(String.self, forKey: .displayName)
        let rawHeaderImg        = try container.decode(String.self, forKey: .headerImage)
        headerImg               = URL(string: rawHeaderImg)!
        isNSFW                  = try container.decode(Bool.self, forKey: .isNSFW)
        relativeURL             = try container.decode(String.self, forKey: .relativeURL)
        subredditType           = try container.decode(SubredditType.self, forKey: .subredditType)
        subscribers             = try container.decode(Int.self, forKey: .subscribers)
        title                   = try container.decode(String.self, forKey: .title)
        userIsBanned            = try container.decodeIfPresent(Bool.self, forKey: .userIsBanned) ?? false
        userIsContributer       = try container.decodeIfPresent(Bool.self, forKey: .userIsContributer) ?? false
        userIsModerator         = try container.decodeIfPresent(Bool.self, forKey: .userIsModerator) ?? false
        userIsSubscriber        = try container.decodeIfPresent(Bool.self, forKey: .userIsSubscriber) ?? false
        
    }
}
