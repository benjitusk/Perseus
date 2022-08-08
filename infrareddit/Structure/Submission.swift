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
    let submissionType: SubmissionType
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
        case allAwards = "all_awardings"
        case allowLiveComments = "allow_live_comments"
        case approvedBy = "approved_by"
        case archived
        case authorHasPremium = "author_premium"
        case awardCount = "total_awards_received"
        case awarders
        case canGild = "can_gild"
        case category
        case clicked
        case commentCount = "num_comments"
        case contentCategories = "content_categories"
        case contestMode = "contest_mode"
        case created
        case createdAtUTC = "created_utc"
        case crosspostCount = "num_crosspost"
        case discussionType = "discussionType"
        case distinguished
        case domain
        case downvoteCount = "downs"
        case edited
        case fullName = "name"
        case gilded
        case gildings
        case hidden
        case id
        case isCreatedFromAdsUI = "is_created_from_ads_ui"
        case isCrosspostable = "is_crosspostable"
        case isMeta = "is_meta"
        case isNSFW = "over_18"
        case isOriginalContent = "is_original_content"
        case isRedditMediaDomain = "is_reddit_media_domain"
        case isRobotIndexable = "is_robot_indexable"
        case isSelf = "is_self"
        case isVideo = "is_video"
        case likes
        case locked
        case media
        case mediaEmbed = "media_embed"
        case mediaOnly = "media_only"
        case noFollow = "no_follow"
        case parentWhitelistStatus = "parent_whitelist_status"
        case permalink
        case pinned
        case preview
        case saved = "saved"
        case score
        case scoreHidden = "hide_score"
        case secureMedia = "secure_media"
        case secureMediaEmbed = "secure_media_embed"
        case selfText = "selftext"
        case selfTextHTML = "selftext_html"
        case sendReplies = "send_replies"
        case spoiler
        case stickied
        case suggestedSort = "suggested_sort"
        case thumbnail
        case thumbnailHeight = "thumbnail_height"
        case thumbnailWidth = "thumbnail_width"
        case title
        case topAwardedType = "top_awarded_type"
        case treatmentTags = "treatment_tags"
        case upvoteCount = "ups"
        case url
        case viewCount = "view_count"
        case visited
        case voteRatio = "upvote_ratio"
        case whitelistStatus = "whitelist_status"
    }
    
    enum RootKeys: CodingKey {
        case kind, data
    }
    
    enum SubmissionType: String, Decodable {
        /// A post that only contains text
        case text
        /// A post containing media or a link
        case link
    }
    
    init(title: String, selfText: String, author: Author, upVotes: Int, downVotes: Int, totalAwardCount: Int, isOriginalContent: Bool, thumbnailURL: URL?, createdAt: Date, isArchived: Bool, isNSFW: Bool, isPinned: Bool, isMediaOnly: Bool, isLocked: Bool, id: String, subredditID: String, commentCount: Int, permalink: String, isStickied: Bool, voteRatio: Double, subredditName: String, submissionType: SubmissionType) {
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
        self.submissionType = submissionType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self).nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        
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
        if let thumbnail = try container.decode(String?.self, forKey: .thumbnail),
           thumbnail.hasPrefix("http") {
            thumbnailURL = URL(string: thumbnail)!
        } else {
            thumbnailURL = nil
        }
        let createdAtTimestamp = try container.decode(Int.self, forKey: .createdAtUTC)
        if try container.decode(Bool.self, forKey: .isSelf) {
            submissionType = .text
        } else {
            submissionType = .link
        }
        
        
        commentCount = try container.decode(Int.self, forKey: .commentCount)
        createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtTimestamp))
        downVotes = try container.decode(Int.self, forKey: .downvoteCount)
        id = try container.decode(String.self, forKey: .fullName)
        isArchived = try container.decode(Bool.self, forKey: .archived)
        isLocked = try container.decode(Bool.self, forKey: .locked)
        isMediaOnly = try container.decode(Bool.self, forKey: .mediaOnly)
        isNSFW = try container.decode(Bool.self, forKey: .isNSFW)
        isOriginalContent = try container.decode(Bool.self, forKey: .isOriginalContent)
        isPinned = try container.decode(Bool.self, forKey: .pinned)
        isStickied = try container.decode(Bool.self, forKey: .stickied)
        permalink  = try container.decode(String.self, forKey: .permalink)
        preview = try? container.decode(RedditImageContainer.self, forKey: .preview)
        selfText = try container.decode(String.self, forKey: .selfText)
        subredditID = try container.decode(String.self, forKey: .subredditID)
        subredditName = try container.decode(String.self, forKey: .subredditName)
        title = try container.decode(String.self, forKey: .title)
        totalAwardCount = try container.decode(Int.self, forKey: .awardCount)
        upVotes = try container.decode(Int.self, forKey: .upvoteCount)
        voteRatio = try container.decode(Double.self, forKey: .voteRatio)
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
                                   subredditName: "AppDev",
                                   submissionType: .text
    )
    
    static var sampleJSONData = Data("""
{"kind":"t3","data":{"approved_at_utc":null,"subreddit":"funny","selftext":"","author_fullname":"t2_58a14ole","saved":false,"mod_reason_title":null,"gilded":0,"clicked":false,"title":"undoubtedly the best photo I took at my sister's wedding","link_flair_richtext":[],"subreddit_name_prefixed":"r/funny","hidden":false,"pwls":6,"link_flair_css_class":null,"downs":0,"thumbnail_height":140,"top_awarded_type":"ACTIVE","hide_score":false,"name":"t3_wim1n1","quarantine":false,"link_flair_text_color":"dark","upvote_ratio":0.91,"author_flair_background_color":null,"subreddit_type":"public","ups":74712,"total_awards_received":53,"media_embed":{},"thumbnail_width":140,"author_flair_template_id":null,"is_original_content":false,"user_reports":[],"secure_media":null,"is_reddit_media_domain":true,"is_meta":false,"category":null,"secure_media_embed":{},"link_flair_text":null,"can_mod_post":false,"score":74712,"approved_by":null,"is_created_from_ads_ui":false,"author_premium":false,"thumbnail":"https://b.thumbs.redditmedia.com/nZOwrhVymYnKonFYHlFlnTa-tihkAG4plyI0MvaAQAU.jpg","edited":false,"author_flair_css_class":null,"author_flair_richtext":[],"gildings":{"gid_1":14},"post_hint":"image","content_categories":null,"is_self":false,"mod_note":null,"created":1659895802,"link_flair_type":"text","wls":6,"removed_by_category":null,"banned_by":null,"author_flair_type":"text","domain":"i.redd.it","allow_live_comments":true,"selftext_html":null,"likes":null,"suggested_sort":null,"banned_at_utc":null,"url_overridden_by_dest":"https://i.redd.it/a6cenxuw0cg91.jpg","view_count":null,"archived":false,"no_follow":false,"is_crosspostable":false,"pinned":false,"over_18":false,"preview":{"images":[{"source":{"url":"https://preview.redd.it/a6cenxuw0cg91.jpg?auto=webp&amp;s=a9dae7b5d704da4b6c4147e1afbe0dd349fbc3df","width":749,"height":999},"resolutions":[{"url":"https://preview.redd.it/a6cenxuw0cg91.jpg?width=108&amp;crop=smart&amp;auto=webp&amp;s=9c347292aad163914c2567be5a83374857ce0be7","width":108,"height":144},{"url":"https://preview.redd.it/a6cenxuw0cg91.jpg?width=216&amp;crop=smart&amp;auto=webp&amp;s=a845e3193cdfa05dbfab4827e8044090affda98a","width":216,"height":288},{"url":"https://preview.redd.it/a6cenxuw0cg91.jpg?width=320&amp;crop=smart&amp;auto=webp&amp;s=5ad26330b0e79688f0df0a86a2063a21bbfbf37c","width":320,"height":426},{"url":"https://preview.redd.it/a6cenxuw0cg91.jpg?width=640&amp;crop=smart&amp;auto=webp&amp;s=3768948dd2210ecfc6e88760876444c7299af4f2","width":640,"height":853}],"variants":{},"id":"5FtrTOhTjY19sJX5CgX24oHBqNxWkhtopO6apQD5Vnk"}],"enabled":true},"all_awardings":[{"giver_coin_reward":null,"subreddit_id":null,"is_new":false,"days_of_drip_extension":null,"coin_price":100,"id":"gid_1","penny_donate":null,"award_sub_type":"GLOBAL","coin_reward":0,"icon_url":"https://www.redditstatic.com/gold/awards/icon/silver_512.png","days_of_premium":null,"tiers_by_required_awardings":null,"resized_icons":[{"url":"https://www.redditstatic.com/gold/awards/icon/silver_16.png","width":16,"height":16},{"url":"https://www.redditstatic.com/gold/awards/icon/silver_32.png","width":32,"height":32},{"url":"https://www.redditstatic.com/gold/awards/icon/silver_48.png","width":48,"height":48},{"url":"https://www.redditstatic.com/gold/awards/icon/silver_64.png","width":64,"height":64},{"url":"https://www.redditstatic.com/gold/awards/icon/silver_128.png","width":128,"height":128}],"icon_width":512,"static_icon_width":512,"start_date":null,"is_enabled":true,"awardings_required_to_grant_benefits":null,"description":"Shows the Silver Award... and that's it.","end_date":null,"sticky_duration_seconds":null,"subreddit_coin_reward":0,"count":14,"static_icon_height":512,"name":"Silver","resized_static_icons":[{"url":"https://www.redditstatic.com/gold/awards/icon/silver_16.png","width":16,"height":16},{"url":"https://www.redditstatic.com/gold/awards/icon/silver_32.png","width":32,"height":32},{"url":"https://www.redditstatic.com/gold/awards/icon/silver_48.png","width":48,"height":48},{"url":"https://www.redditstatic.com/gold/awards/icon/silver_64.png","width":64,"height":64},{"url":"https://www.redditstatic.com/gold/awards/icon/silver_128.png","width":128,"height":128}],"icon_format":null,"icon_height":512,"penny_price":null,"award_type":"global","static_icon_url":"https://www.redditstatic.com/gold/awards/icon/silver_512.png"},{"giver_coin_reward":null,"subreddit_id":null,"is_new":false,"days_of_drip_extension":null,"coin_price":50,"id":"award_02d9ab2c-162e-4c01-8438-317a016ed3d9","penny_donate":null,"award_sub_type":"GLOBAL","coin_reward":0,"icon_url":"https://i.redd.it/award_images/t5_q0gj4/p4yzxkaed5f61_oldtakemyenergy.png","days_of_premium":null,"tiers_by_required_awardings":null,"resized_icons":[{"url":"https://preview.redd.it/award_images/t5_q0gj4/p4yzxkaed5f61_oldtakemyenergy.png?width=16&amp;height=16&amp;auto=webp&amp;s=10034f3fdf8214c8377134bb60c5b832d4bbf588","width":16,"height":16},{"url":"https://preview.redd.it/award_images/t5_q0gj4/p4yzxkaed5f61_oldtakemyenergy.png?width=32&amp;height=32&amp;auto=webp&amp;s=100f785bf261fa9452a5d82ee0ef0793369dbfa5","width":32,"height":32},{"url":"https://preview.redd.it/award_images/t5_q0gj4/p4yzxkaed5f61_oldtakemyenergy.png?width=48&amp;height=48&amp;auto=webp&amp;s=b15d030fdfbbe4af4a5b34ab9dc90a174df40a23","width":48,"height":48},{"url":"https://preview.redd.it/award_images/t5_q0gj4/p4yzxkaed5f61_oldtakemyenergy.png?width=64&amp;height=64&amp;auto=webp&amp;s=601c75be6ee30dc4b47a5c65d64dea9a185502a1","width":64,"height":64},{"url":"https://preview.redd.it/award_images/t5_q0gj4/p4yzxkaed5f61_oldtakemyenergy.png?width=128&amp;height=128&amp;auto=webp&amp;s=540f36e65c0e2f1347fe32020e4a1565e3680437","width":128,"height":128}],"icon_width":2048,"static_icon_width":2048,"start_date":null,"is_enabled":true,"awardings_required_to_grant_benefits":null,"description":"I'm in this with you.","end_date":null,"sticky_duration_seconds":null,"subreddit_coin_reward":0,"count":1,"static_icon_height":2048,"name":"Take My Energy","resized_static_icons":[{"url":"https://preview.redd.it/award_images/t5_q0gj4/jtw7x06j68361_TakeMyEnergyElf.png?width=16&amp;height=16&amp;auto=webp&amp;s=045db73f47a9513c44823d132b4c393ab9241b6a","width":16,"height":16},{"url":"https://preview.redd.it/award_images/t5_q0gj4/jtw7x06j68361_TakeMyEnergyElf.png?width=32&amp;height=32&amp;auto=webp&amp;s=298a02e0edbb5b5e293087eeede63802cbe1d2c7","width":32,"height":32},{"url":"https://preview.redd.it/award_images/t5_q0gj4/jtw7x06j68361_TakeMyEnergyElf.png?width=48&amp;height=48&amp;auto=webp&amp;s=7d06d606eb23dbcd6dbe39ee0e60588c5eb89065","width":48,"height":48},{"url":"https://preview.redd.it/award_images/t5_q0gj4/jtw7x06j68361_TakeMyEnergyElf.png?width=64&amp;height=64&amp;auto=webp&amp;s=ecd9854b14104a36a210028c43420f0dababd96b","width":64,"height":64},{"url":"https://preview.redd.it/award_images/t5_q0gj4/jtw7x06j68361_TakeMyEnergyElf.png?width=128&amp;height=128&amp;auto=webp&amp;s=0d5d7b92c1d66aff435f2ad32e6330ca2b971f6d","width":128,"height":128}],"icon_format":"PNG","icon_height":2048,"penny_price":0,"award_type":"global","static_icon_url":"https://i.redd.it/award_images/t5_q0gj4/jtw7x06j68361_TakeMyEnergyElf.png"},{"giver_coin_reward":null,"subreddit_id":null,"is_new":false,"days_of_drip_extension":null,"coin_price":75,"id":"award_92cb6518-a71a-4217-9f8f-7ecbd7ab12ba","penny_donate":null,"award_sub_type":"PREMIUM","coin_reward":0,"icon_url":"https://www.redditstatic.com/gold/awards/icon/TakeMyPower_512.png","days_of_premium":null,"tiers_by_required_awardings":null,"resized_icons":[{"url":"https://www.redditstatic.com/gold/awards/icon/TakeMyPower_16.png","width":16,"height":16},{"url":"https://www.redditstatic.com/gold/awards/icon/TakeMyPower_32.png","width":32,"height":32},{"url":"https://www.redditstatic.com/gold/awards/icon/TakeMyPower_48.png","width":48,"height":48},{"url":"https://www.redditstatic.com/gold/awards/icon/TakeMyPower_64.png","width":64,"height":64},{"url":"https://www.redditstatic.com/gold/awards/icon/TakeMyPower_128.png","width":128,"height":128}],"icon_width":512,"static_icon_width":512,"start_date":null,"is_enabled":true,"awardings_required_to_grant_benefits":null,"description":"Add my power to yours.","end_date":null,"sticky_duration_seconds":null,"subreddit_coin_reward":0,"count":2,"static_icon_height":512,"name":"Take My Power","resized_static_icons":[{"url":"https://preview.redd.it/award_images/t5_q0gj4/qpi61q5o98361_TakeMyPowerElf.png?width=16&amp;height=16&amp;auto=webp&amp;s=14d5429e1f630eaba283d73cb4890c861859b645","width":16,"height":16},{"url":"https://preview.redd.it/award_images/t5_q0gj4/qpi61q5o98361_TakeMyPowerElf.png?width=32&amp;height=32&amp;auto=webp&amp;s=397444282c113a335f31da0c1d38a1e8cec75f05","width":32,"height":32},{"url":"https://preview.redd.it/award_images/t5_q0gj4/qpi61q5o98361_TakeMyPowerElf.png?width=48&amp;height=48&amp;auto=webp&amp;s=9897e3f134eb759aba6b7afecb5fb2c75bbf9dc9","width":48,"height":48},{"url":"https://preview.redd.it/award_images/t5_q0gj4/qpi61q5o98361_TakeMyPowerElf.png?width=64&amp;height=64&amp;auto=webp&amp;s=2de1c239b9226cfebdfbee28fba56bc534dc87b6","width":64,"height":64},{"url":"https://preview.redd.it/award_images/t5_q0gj4/qpi61q5o98361_TakeMyPowerElf.png?width=128&amp;height=128&amp;auto=webp&amp;s=7e08340ce7c4bc4b865820ed418734396b32b814","width":128,"height":128}],"icon_format":"APNG","icon_height":512,"penny_price":0,"award_type":"global","static_icon_url":"https://i.redd.it/award_images/t5_q0gj4/qpi61q5o98361_TakeMyPowerElf.png"},{"giver_coin_reward":null,"subreddit_id":null,"is_new":false,"days_of_drip_extension":null,"coin_price":30,"id":"award_b4ff447e-05a5-42dc-9002-63568807cfe6","penny_donate":null,"award_sub_type":"PREMIUM","coin_reward":0,"icon_url":"https://www.redditstatic.com/gold/awards/icon/Illuminati_512.png","days_of_premium":null,"tiers_by_required_awardings":null,"resized_icons":[{"url":"https://www.redditstatic.com/gold/awards/icon/Illuminati_16.png","width":16,"height":16},{"url":"https://www.redditstatic.com/gold/awards/icon/Illuminati_32.png","width":32,"height":32},{"url":"https://www.redditstatic.com/gold/awards/icon/Illuminati_48.png","width":48,"height":48},{"url":"https://www.redditstatic.com/gold/awards/icon/Illuminati_64.png","width":64,"height":64},{"url":"https://www.redditstatic.com/gold/awards/icon/Illuminati_128.png","width":128,"height":128}],"icon_width":2048,"static_icon_width":2048,"start_date":null,"is_enabled":true,"awardings_required_to_grant_benefits":null,"description":"A glowing commendation for all to see","end_date":null,"sticky_duration_seconds":null,"subreddit_coin_reward":0,"count":1,"static_icon_height":2048,"name":"All-Seeing Upvote","resized_static_icons":[{"url":"https://preview.redd.it/award_images/t5_q0gj4/am40b8b08l581_All-SeeingUpvote2.png?width=16&amp;height=16&amp;auto=webp&amp;s=978c93744e53b8c9305467a7be792e5c401eac6c","width":16,"height":16},{"url":"https://preview.redd.it/award_images/t5_q0gj4/am40b8b08l581_All-SeeingUpvote2.png?width=32&amp;height=32&amp;auto=webp&amp;s=d2ee343eef5048ad3add75d4a4d4e3922bb9565a","width":32,"height":32},{"url":"https://preview.redd.it/award_images/t5_q0gj4/am40b8b08l581_All-SeeingUpvote2.png?width=48&amp;height=48&amp;auto=webp&amp;s=7d216fd3a05c61d9fb75b27092844c546d958f14","width":48,"height":48},{"url":"https://preview.redd.it/award_images/t5_q0gj4/am40b8b08l581_All-SeeingUpvote2.png?width=64&amp;height=64&amp;auto=webp&amp;s=b76693f84fd19b04d0c0444a9812d812105e2d8f","width":64,"height":64},{"url":"https://preview.redd.it/award_images/t5_q0gj4/am40b8b08l581_All-SeeingUpvote2.png?width=128&amp;height=128&amp;auto=webp&amp;s=5353352ae9f443c353ef0b7725dabcfc1b3829a5","width":128,"height":128}],"icon_format":"APNG","icon_height":2048,"penny_price":null,"award_type":"global","static_icon_url":"https://i.redd.it/award_images/t5_q0gj4/am40b8b08l581_All-SeeingUpvote2.png"},{"giver_coin_reward":null,"subreddit_id":null,"is_new":false,"days_of_drip_extension":null,"coin_price":150,"id":"award_f44611f1-b89e-46dc-97fe-892280b13b82","penny_donate":null,"award_sub_type":"GLOBAL","coin_reward":0,"icon_url":"https://i.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png","days_of_premium":null,"tiers_by_required_awardings":null,"resized_icons":[{"url":"https://preview.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png?width=16&amp;height=16&amp;auto=webp&amp;s=a5662dfbdb402bf67866c050aa76c31c147c2f45","width":16,"height":16},{"url":"https://preview.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png?width=32&amp;height=32&amp;auto=webp&amp;s=a6882eb3f380e8e88009789f4d0072e17b8c59f1","width":32,"height":32},{"url":"https://preview.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png?width=48&amp;height=48&amp;auto=webp&amp;s=e50064b090879e8a0b55e433f6ee61d5cb5fbe1d","width":48,"height":48},{"url":"https://preview.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png?width=64&amp;height=64&amp;auto=webp&amp;s=8e5bb2e76683cb6b161830bcdd9642049d6adc11","width":64,"height":64},{"url":"https://preview.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png?width=128&amp;height=128&amp;auto=webp&amp;s=eda4a9246f95f42ee6940cc0ec65306fd20de878","width":128,"height":128}],"icon_width":2048,"static_icon_width":2048,"start_date":null,"is_enabled":true,"awardings_required_to_grant_benefits":null,"description":"Thank you stranger. Shows the award.","end_date":null,"sticky_duration_seconds":null,"subreddit_coin_reward":0,"count":15,"static_icon_height":2048,"name":"Helpful","resized_static_icons":[{"url":"https://preview.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png?width=16&amp;height=16&amp;auto=webp&amp;s=a5662dfbdb402bf67866c050aa76c31c147c2f45","width":16,"height":16},{"url":"https://preview.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png?width=32&amp;height=32&amp;auto=webp&amp;s=a6882eb3f380e8e88009789f4d0072e17b8c59f1","width":32,"height":32},{"url":"https://preview.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png?width=48&amp;height=48&amp;auto=webp&amp;s=e50064b090879e8a0b55e433f6ee61d5cb5fbe1d","width":48,"height":48},{"url":"https://preview.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png?width=64&amp;height=64&amp;auto=webp&amp;s=8e5bb2e76683cb6b161830bcdd9642049d6adc11","width":64,"height":64},{"url":"https://preview.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png?width=128&amp;height=128&amp;auto=webp&amp;s=eda4a9246f95f42ee6940cc0ec65306fd20de878","width":128,"height":128}],"icon_format":null,"icon_height":2048,"penny_price":null,"award_type":"global","static_icon_url":"https://i.redd.it/award_images/t5_22cerq/klvxk1wggfd41_Helpful.png"},{"giver_coin_reward":null,"subreddit_id":null,"is_new":false,"days_of_drip_extension":null,"coin_price":125,"id":"award_5f123e3d-4f48-42f4-9c11-e98b566d5897","penny_donate":null,"award_sub_type":"GLOBAL","coin_reward":0,"icon_url":"https://i.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png","days_of_premium":null,"tiers_by_required_awardings":null,"resized_icons":[{"url":"https://preview.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png?width=16&amp;height=16&amp;auto=webp&amp;s=92932f465d58e4c16b12b6eac4ca07d27e3d11c0","width":16,"height":16},{"url":"https://preview.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png?width=32&amp;height=32&amp;auto=webp&amp;s=d11484a208d68a318bf9d4fcf371171a1cb6a7ef","width":32,"height":32},{"url":"https://preview.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png?width=48&amp;height=48&amp;auto=webp&amp;s=febdf28b6f39f7da7eb1365325b85e0bb49a9f63","width":48,"height":48},{"url":"https://preview.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png?width=64&amp;height=64&amp;auto=webp&amp;s=b4406a2d88bf86fa3dc8a45aacf7e0c7bdccc4fb","width":64,"height":64},{"url":"https://preview.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png?width=128&amp;height=128&amp;auto=webp&amp;s=19555b13e3e196b62eeb9160d1ac1d1b372dcb0b","width":128,"height":128}],"icon_width":2048,"static_icon_width":2048,"start_date":null,"is_enabled":true,"awardings_required_to_grant_benefits":null,"description":"When you come across a feel-good thing.","end_date":null,"sticky_duration_seconds":null,"subreddit_coin_reward":0,"count":20,"static_icon_height":2048,"name":"Wholesome","resized_static_icons":[{"url":"https://preview.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png?width=16&amp;height=16&amp;auto=webp&amp;s=92932f465d58e4c16b12b6eac4ca07d27e3d11c0","width":16,"height":16},{"url":"https://preview.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png?width=32&amp;height=32&amp;auto=webp&amp;s=d11484a208d68a318bf9d4fcf371171a1cb6a7ef","width":32,"height":32},{"url":"https://preview.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png?width=48&amp;height=48&amp;auto=webp&amp;s=febdf28b6f39f7da7eb1365325b85e0bb49a9f63","width":48,"height":48},{"url":"https://preview.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png?width=64&amp;height=64&amp;auto=webp&amp;s=b4406a2d88bf86fa3dc8a45aacf7e0c7bdccc4fb","width":64,"height":64},{"url":"https://preview.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png?width=128&amp;height=128&amp;auto=webp&amp;s=19555b13e3e196b62eeb9160d1ac1d1b372dcb0b","width":128,"height":128}],"icon_format":null,"icon_height":2048,"penny_price":null,"award_type":"global","static_icon_url":"https://i.redd.it/award_images/t5_22cerq/5izbv4fn0md41_Wholesome.png"}],"awarders":[],"media_only":false,"can_gild":false,"spoiler":false,"locked":false,"author_flair_text":null,"treatment_tags":[],"visited":false,"removed_by":null,"num_reports":null,"distinguished":null,"subreddit_id":"t5_2qh33","author_is_blocked":false,"mod_reason_by":null,"removal_reason":null,"link_flair_background_color":"","id":"wim1n1","is_robot_indexable":true,"report_reasons":null,"author":"BabyGroot1337","discussion_type":null,"num_comments":1691,"send_replies":false,"whitelist_status":"all_ads","contest_mode":false,"mod_reports":[],"author_patreon_flair":false,"author_flair_text_color":null,"permalink":"/r/funny/comments/wim1n1/undoubtedly_the_best_photo_i_took_at_my_sisters/","parent_whitelist_status":"all_ads","stickied":false,"url":"https://i.redd.it/a6cenxuw0cg91.jpg","subreddit_subscribers":42210485,"created_utc":1659895802,"num_crossposts":6,"media":null,"is_video":false}}
""".utf8)
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

