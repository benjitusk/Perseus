//
//  Comment.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/25/22.
//

import Foundation
final class Comment: RedditThing {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
    
    let author: Author
    let createdAt: Date
    let score: Int
    let scoreIsHidden: Bool
    let isArchived: Bool
    let isEdited: Bool
    let authorIsOP: Bool
    let isLocked: Bool
    let isDistinguished: Bool
    let depth: Int
    let permalink: URL
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case awards = "all_awardings"
        case approvedAt = "approved_at_utc"
        case approvedBy = "approved_by"
        case isArchived = "archived"
        case associatedAward = "associated_award"
        case authorFlairBackgroundColor = "author_flair_background_color"
        case authorFlairCSSClass = "author_flair_css_class"
        case authorFlairRichtext = "author_flair_richtext"
        case authorFlairTemplateID = "author_flair_template_id"
        case authorFlairTextColor = "author_flair_text_color"
        case authorFlairText = "author_flair_text"
        case authorFlairType = "author_flair_type"
        case authorID = "author_fullname"
        case authorIsBlocked = "author_is_blocked"
        case authorHasPatreonFlair = "author_patreon_flair"
        case authorHasPremium = "author_premium"
        case authorUsername = "author"
        case awarders
        case bannedAt = "banned_at_utc"
        case bannedBy = "banned_by"
        case htmlBody = "body_html"
        case body
        case canGild = "can_gild"
        case canModPost = "can_mod_post"
        case isCollapsedBecauseCrowdControl = "collapsed_because_crowd_control"
        case collapsedReasonCode = "collapsed_reason_code"
        case collapsedReason = "collapsed_reason"
        case isCollapsed = "collapsed"
        case commentType = "comment_type"
        case controversiality
        case createdAt = "created_utc"
        case depth
        case distinguished
        case downs
        case isEdited = "edited"
        case gilded
        case gildings
        case id
        case authorIsOP = "is_submitter"
        case voteStatus = "likes"
        case submissionID = "link_id"
        case isLocked = "locked"
        case modNote = "mod_note"
        case modReasonBy = "mod_reason_by"
        case modReasonTitle = "mod_reason_title"
        case modReports = "mod_reports"
        case name
        case noFollow = "no_follow"
        case reportCount = "num_reports"
        case parentID = "parent_id"
        case permalink
        case removalReason = "removal_reason"
        case replies
        case reportReasons = "report_reasons"
        case saved
        case scoreIsHidden = "score_hidden"
        case score
        case sendReplies = "send_replies"
        case isStickied = "stickied"
        case subredditID = "subreddit_id"
        case prefixedSubredditName = "subreddit_name_prefixed"
        case subredditType = "subreddit_type"
        case subreddit
        case topAwardedType = "top_awarded_type"
        case totalAwards = "total_awards_received"
        case treatmentTags = "treatment_tags"
        case unrepliableReason = "unrepliable_reason"
        case upvotes = "ups"
        case reports = "user_reports"

    }
    enum RootKeys: CodingKey {
        case kind, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self).nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        if let authorID = try container.decodeIfPresent(String.self, forKey: .authorID) {
            let authorUsername = try container.decode(String.self, forKey: .authorUsername)
            let authorIsBlocked = try container.decode(Bool.self, forKey: .authorIsBlocked)
            let authorHasPatreonFlair = try container.decode(Bool.self, forKey: .authorHasPatreonFlair)
            let authorHasPremium = try container.decode(Bool.self, forKey: .authorHasPremium)
            author = Author(username: authorUsername,
                            id: authorID,
                            isBlocked: authorIsBlocked,
                            patreonFlair: authorHasPatreonFlair,
                            hasPremium: authorHasPremium)
        } else {
            author = Author.deletedUser
        }
        let createdAtTimestamp = try container.decode(Int.self, forKey: .createdAt)
        createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtTimestamp))
        score = try container.decode(Int.self, forKey: .score)
        scoreIsHidden = try container.decode(Bool.self, forKey: .scoreIsHidden)
        isArchived = try container.decode(Bool.self, forKey: .isArchived)
        isEdited = try container.decode(Bool.self, forKey: .isEdited)
        authorIsOP = try container.decode(Bool.self, forKey: .authorIsOP)
        isLocked = try container.decode(Bool.self, forKey: .isLocked)
        isDistinguished = try container.decode(Bool.self, forKey: .distinguished)
        depth = try container.decode(Int.self, forKey: .depth)
        let permalinkSuffix = try container.decode(String.self, forKey: .permalink)
        permalink = URL(string: "https://www.reddit.com" + permalinkSuffix)!
        id = try container.decode(String.self, forKey: .name)
    }
    
    func vote(_ vote: Reddit.VoteDirection) {
        Reddit.castVote(vote, on: self.id, completion: {_ in})
    }
    
    static var sample = try! JSONDecoder().decode(
        Comment.self, from: Data(contentsOf:
                                        Bundle.main.url(forResource: "Comment", withExtension: "json")!
                                   )
    )

}
