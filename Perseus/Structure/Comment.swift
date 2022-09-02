//
//  Comment.swift
//  perseus
//
//  Created by Benji Tusk on 7/25/22.
//

import Foundation

protocol CommentTreeable {
    var id: String { get }
    var depth: Int { get }
    var parentID: String { get }
    var isCollapsed: Bool { get set }
}

class CommentsAndMore: RedditThing {
    
    static func == (lhs: CommentsAndMore, rhs: CommentsAndMore) -> Bool {
        return lhs.id == rhs.id
    }

    let id: String
//    let more: MoreComments?
//    let comment: Comment?
    let commentOrMore: CommentTreeable
    
    init(commentOrMore: any CommentTreeable) {
        self.id = commentOrMore.id
        self.commentOrMore = commentOrMore
    }
    
    required init(from decoder: Decoder) throws {
        // Try to init a Comment. If that fails,
        // try to init a MoreComments.
        // If neither of those work, throw an error
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let kind = try rootContainer.decode(Kind.self, forKey: .kind)
        switch kind {
        case .comment:
            let commentOrMore = try rootContainer.decode(Comment.self, forKey: .data)
            id = commentOrMore.id
            self.commentOrMore = commentOrMore
        case .more:
            let commentOrMore = try rootContainer.decode(MoreComments.self, forKey: .data)
            id = commentOrMore.id
            self.commentOrMore = commentOrMore
        }
        
    }
    
    enum RootKeys: String, CodingKey {
        case kind, data
    }

    
    enum CodingKeys: String, CodingKey {
        case id
    }
    enum Kind: String, Decodable {
        case comment = "t1"
        case more
    }
    
}

final class MoreComments: RedditThing, CommentTreeable {
    static func == (lhs: MoreComments, rhs: MoreComments) -> Bool {
        return lhs.id == rhs.id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        children = try container.decode([String].self, forKey: .children)
        fullID = try container.decode(String.self, forKey: .name)
        depth = try container.decode(Int.self, forKey: .depth)
        parentID = try container.decode(String.self, forKey: .parentID)
        isCollapsed = false
    }

    let children: [String]
    let depth: Int
    let fullID: String
    let id: String
    var isCollapsed: Bool
    let parentID: String

    init(children: [String], fullID: String, id: String, depth: Int, parentID: String) {
        self.children = children
        self.fullID = fullID
        self.id = id
        self.depth = depth
        self.parentID = parentID
        self.isCollapsed = false
    }
    
    enum CodingKeys: String, CodingKey {
        case children
        case name
        case id
        case depth
        case parentID = "parent_id"
    }
}

final class Comment: RedditThing, CommentTreeable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }

    let author: Author
    let authorIsOP: Bool
    let body: String
    let createdAt: Date
    let depth: Int
    let distinguished: Reddit.Distinguish?
    let editedAt: Date?
    let id: String
    let isArchived: Bool
    var isCollapsed: Bool
    let isLocked: Bool
    let parentID: String
    let permalink: URL
    var replyListing: Listing<CommentsAndMore>?
    let score: Int
    let scoreIsHidden: Bool
    let prefixedSubredditName: String
    let subredditName: String
    
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
        case editedAt = "edited"
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
        case subredditName = "subreddit"
        case topAwardedType = "top_awarded_type"
        case totalAwards = "total_awards_received"
        case treatmentTags = "treatment_tags"
        case unrepliableReason = "unrepliable_reason"
        case upvotes = "ups"
        case reports = "user_reports"

    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
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
            body = try container.decode(String.self, forKey: .body)
            createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtTimestamp))
            score = try container.decode(Int.self, forKey: .score)
            scoreIsHidden = try container.decode(Bool.self, forKey: .scoreIsHidden)
            isArchived = try container.decode(Bool.self, forKey: .isArchived)
            editedAt = try? container.decode(Date.self, forKey: .editedAt)
            authorIsOP = try container.decode(Bool.self, forKey: .authorIsOP)
            isLocked = try container.decode(Bool.self, forKey: .isLocked)
            distinguished = try container.decodeIfPresent(Reddit.Distinguish.self, forKey: .distinguished)
            depth = try container.decode(Int.self, forKey: .depth)
            let permalinkSuffix = try container.decode(String.self, forKey: .permalink)
            permalink = URL(string: "https://www.reddit.com" + permalinkSuffix)!
            id = try container.decode(String.self, forKey: .name)
            parentID = try container.decode(String.self, forKey: .parentID)
            prefixedSubredditName = try container.decode(String.self, forKey: .prefixedSubredditName)
            isCollapsed = try container.decode(Bool.self, forKey: .isCollapsed)
            subredditName = try container.decode(String.self, forKey: .subredditName)
            // This will be true if there are no replies (denoted by an empty string in the JSON smh)
            if ((try? container.decodeIfPresent(String.self, forKey: .replies) != nil) != nil) {
                self.replyListing = nil
            } else if let replies = try? container.decodeIfPresent(Listing<CommentsAndMore>.self, forKey: .replies) {
                self.replyListing = replies
            } else {
                // catchall
                self.replyListing = nil
            }
        } catch {
            print("An error occurred while decoding a Comment:")
            print((error as NSError))
            throw error
        }
        
    }
    
    func vote(_ vote: Reddit.VoteDirection) {
        Reddit.castVote(vote, on: self.id, completion: {_ in})
    }
    
    static var sample = try! JSONDecoder().decode(
        Comment.self, from: Data(contentsOf:
                                        Bundle.main.url(forResource: "Comment", withExtension: "json")!
                                   )
    )
    
    static var sampleTree = try! JSONDecoder().decode(
        Listing<CommentsAndMore>.self, from: Data(contentsOf:
                                            Bundle.main.url(forResource: "CommentListing", withExtension: "json")!
                                         )
    ).children
    
}
