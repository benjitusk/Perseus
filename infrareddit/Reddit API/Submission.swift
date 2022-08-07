//
//  Submission.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/25/22.
//

import Foundation
final class Submission: RedditThing {
    
    let author: Author
    let commentCount: Int
    let createdAt: Date
    let downVotes: Int
    let id: String
    let isArchived: Bool
    let isLocked: Bool
    let isMediaOnly: Bool
    let isNSFW: Bool
    let isOriginalContent: Bool
    let isPinned: Bool
    let isStickied: Bool
    let permalink: String
    let preview: RedditImageContainer?
    let selfText: String
    let subredditID: String
    let subredditName: String
    let thumbnailURL: URL?
    let title: String
    let totalAwardCount: Int
    let upVotes: Int
    let voteRatio: Double
    enum CodingKeys: String, CodingKey {
        
        // Mod Data
        case reportCount = "num_reports"
        case removedBy = "removed_by"
        case bannedAtUTC = "banned_at_utc"
        case approvedAtUTC = "approved_at_utc"
        case bannedBy = "banned_by"
        case removedByCategory = "removed_by_category"
        case modNote = "mod_note"
        case modRemovalTitle = "mod_reason_title"
        case userReports = "user_reports"
        case canModPost = "can_mod_post"
        case modReasonBy = "mod_reason_by"
        case removalReason = "removal_reason"
        case reportReasons = "report_reasons"
        case modReports = "mod_reports"
        
        // Author Data
        case authorName = "author"
        case authorIsBlocked = "author_is_blocked"
        case authorID = "author_fullname"
        
        // Subreddit Data
        case quarantine
        case subredditPrefixedName = "subreddit_name_prefixed"
        case subredditName = "subreddit"
        case subredditType = "subreddit_type"
        case subredditID = "subreddit_id"
        case subredditSubscribers = "subreddit_subscribers"


        // Flair config
        
        // Author flairs
        case authorFlairBackgroundColor = "author_flair_background_color"
        case authorFlairCSSClass = "author_flair_css_class"
        case authorFlairRichText = "author_flair_richtext"
        case authorFlairTemplateID = "author_flair_template_id"
        case authorFlairText = "author_flair_text"
        case authorFlairTextColor = "author_flair_text_color"
        case authorFlairType = "author_flair_type"
        case authorPatreonFlair = "author_patreon_flair"
        
        // Link flairs
        case linkFlairBackgroundColor = "link_flair_background_color"
        case linkFlairCSSClass = "link_flair_css_class"
        case linkFlairRichText = "link_flair_richtext"
        case linkFlairTemplateID = "link_flair_template_id"
        case linkFlairText = "link_flair_text"
        case linkFlairTextColor = "link_flair_text_color"
        case linkFlairType = "link_flair_type"
        
        // Other fields
        case selfText = "selftext"
        case saved = "saved"
        case gilded
        case clicked
        case title
        case hidden
        case downvoteCount = "downs"
        case thumbnailHeight = "thumbnail_height"
        case topAwardedType = "top_awarded_type"
        case scoreHidden = "hide_score"
        case fullName = "name"
        case voteRatio = "upvote_ratio"
        case upvoteCount = "ups"
        case awardCount = "total_awards_received"
        case mediaEmbed = "media_embed"
        case thumbnailWidth = "thumbnail_width"
        case isOriginalContent = "is_original_content"
        case secureMedia = "secure_media"
        case isRedditMediaDomain = "is_reddit_media_domain"
        case preview
        case isMeta = "is_meta"
        case category
        case secureMediaEmbed = "secure_media_embed"
        case score
        case approvedBy = "approved_by"
        case isCreatedFromAdsUI = "is_created_from_ads_ui"
        case authorHasPremium = "author_premium"
        case thumbnail
        case edited
        case gildings
        case contentCategories = "content_categories"
        case isSelf = "is_self"
        case created
        case domain
        case allowLiveComments = "allow_live_comments"
        case selfTextHTML = "selftext_html"
        case likes
        case suggestedSort = "suggested_sort"
        case viewCount = "view_count"
        case archived
        case noFollow = "no_follow"
        case isCrosspostable = "is_crosspostable"
        case pinned
        case isNSFW = "over_18"
        case allAwards = "all_awardings"
        case awarders
        case mediaOnly = "media_only"
        case canGild = "can_gild"
        case spoiler
        case locked
        case treatmentTags = "treatment_tags"
        case visited
        case distinguished
        case id
        case isRobotIndexable = "is_robot_indexable"
        case discussionType = "discussionType"
        case commentCount = "num_comments"
        case sendReplies = "send_replies"
        case whitelistStatus = "whitelist_status"
        case contestMode = "contest_mode"
        case permalink
        case parentWhitelistStatus = "parent_whitelist_status"
        case stickied
        case url
        case createdAtUTC = "created_utc"
        case crosspostCount = "num_crosspost"
        case media
        case isVideo = "is_video"
    }
    enum RootKeys: CodingKey {
        case kind, data
    }
    
    enum SubmissionType: String, Decodable {
        case link
        case text
        case any
    }
    
    init(title: String, selfText: String, author: Author, upVotes: Int, downVotes: Int, totalAwardCount: Int, isOriginalContent: Bool, thumbnailURL: URL?, createdAt: Date, isArchived: Bool, isNSFW: Bool, isPinned: Bool, isMediaOnly: Bool, isLocked: Bool, id: String, subredditID: String, commentCount: Int, permalink: String, isStickied: Bool, voteRatio: Double, subredditName: String) {
        self.title = title
        self.selfText = selfText
        self.author = author
        self.upVotes = upVotes
        self.downVotes = downVotes
        self.totalAwardCount = totalAwardCount
        self.isOriginalContent = isOriginalContent
        self.thumbnailURL = thumbnailURL
        self.createdAt = createdAt
        self.isArchived = isArchived
        self.isNSFW = isNSFW
        self.isPinned = isPinned
        self.isMediaOnly = isMediaOnly
        self.isLocked = isLocked
        self.id = id
        self.subredditID = subredditID
        self.commentCount = commentCount
        self.permalink = permalink
        self.isStickied = isStickied
        self.voteRatio = voteRatio
        self.subredditName = subredditName
        self.preview = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self).nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        title = try container.decode(String.self, forKey: .title)
        selfText = try container.decode(String.self, forKey: .selfText)
        
        // Author data
        if let authorID = try container.decodeIfPresent(String.self, forKey: .authorID) {
            let authorUsername = try container.decode(String.self, forKey: .authorName)
            let authorIsBlocked = try container.decode(Bool.self, forKey: .authorIsBlocked)
            let authorHasPatreonFlair = try container.decode(Bool.self, forKey: .authorPatreonFlair)
            let authorHasPremium = try container.decode(Bool.self, forKey: .authorHasPremium)
            author = Author(username: authorUsername,
                            id: authorID,
                            isBlocked: authorIsBlocked,
                            patreonFlair: authorHasPatreonFlair,
                            hasPremium: authorHasPremium)
        } else {
            author = Author.deletedUser
        }
        
        upVotes = try container.decode(Int.self, forKey: .upvoteCount)
        downVotes = try container.decode(Int.self, forKey: .downvoteCount)
        totalAwardCount = try container.decode(Int.self, forKey: .awardCount)
        isOriginalContent = try container.decode(Bool.self, forKey: .isOriginalContent)
        if let thumbnail = try container.decode(String?.self, forKey: .thumbnail),
           thumbnail.hasPrefix("http") {
            thumbnailURL = URL(string: thumbnail)!
        } else {
            thumbnailURL = nil
        }
        let createdAtTimestamp = try container.decode(Int.self, forKey: .createdAtUTC)
        createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtTimestamp))
        isArchived = try container.decode(Bool.self, forKey: .archived)
        isNSFW = try container.decode(Bool.self, forKey: .isNSFW)
        isPinned = try container.decode(Bool.self, forKey: .pinned)
        isMediaOnly = try container.decode(Bool.self, forKey: .mediaOnly)
        isLocked = try container.decode(Bool.self, forKey: .locked)
        id = try container.decode(String.self, forKey: .fullName)
        subredditID = try container.decode(String.self, forKey: .subredditID)
        commentCount = try container.decode(Int.self, forKey: .commentCount)
        permalink  = try container.decode(String.self, forKey: .permalink)
        isStickied = try container.decode(Bool.self, forKey: .stickied)
        voteRatio = try container.decode(Double.self, forKey: .voteRatio)
        subredditName = try container.decode(String.self, forKey: .subredditName)
        preview = try? container.decode(RedditImageContainer.self, forKey: .preview)
    }
    
    static var sample = Submission(title: "Test submission!",
                                   selfText: "This is a test submission used for aiding in the development of InfraReddit, a Reddit client for iOS. I really hope development goes smoothly! I'll keep you updated as I go. Wish me luck!!",
                                   author: .sample,
                                   upVotes: 84_928,
                                   downVotes: 290,
                                   totalAwardCount: 19,
                                   isOriginalContent: true,
                                   thumbnailURL: nil,
                                   createdAt: Date.now,
                                   isArchived: false,
                                   isNSFW: false,
                                   isPinned: false,
                                   isMediaOnly: false,
                                   isLocked: false,
                                   id: "INVALID_ID",
                                   subredditID: "INVALID_ID",
                                   commentCount: 7_389,
                                   permalink: "link to nowhere",
                                   isStickied: false,
                                   voteRatio: 0.98,
                                   subredditName: "AppDev"
    )
}

struct RedditImageContainer: Decodable {
    struct Image: Decodable {
        struct ImageSource: Decodable {
            let url: String
            let width: Int
            let height: Int
        }
        let source: ImageSource
        let resolutions: [ImageSource]
    }
    let images: [RedditImageContainer.Image]
    let enabled: Bool
}

