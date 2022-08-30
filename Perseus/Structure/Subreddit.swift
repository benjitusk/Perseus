//
//  Subreddit.swift
//  perseus
//
//  Created by Benji Tusk on 7/25/22.
//

import Foundation

class SpecialSubreddit: Subreddit {
    var displayName: String
    var apiURL: String
    
    init(displayName: String, apiURL: String) {
        self.displayName = displayName
        self.apiURL = apiURL
    }

}

final class StandardSubreddit: Subreddit, RedditThing {
    static func == (lhs: StandardSubreddit, rhs: StandardSubreddit) -> Bool {
        return lhs.id == rhs.id
    }
    
    let displayName: String
    let activeAccounts: Int
    let description: String
    let headerImg: URL
    let isNSFW: Bool
    let subscribers: Int
    let allowedSubmissionType: Submission.SubmissionType
    let subredditType: SubredditType
    let title: String
    let relativeURL: String
    let id: String
    let apiURL: String
    // The following user properties are `false` if the user is not authenticated
    let userIsBanned: Bool
    let userIsContributor: Bool
    let userIsModerator: Bool
    let userIsSubscriber: Bool
    
    enum SubredditType: String, Decodable {
        case archived
        case goldRestricted = "gold_restricted"
        case `private`
        case `public`
        case restricted
    }
    
    enum SortingMethod {
        case hot
        case rising
    }

    
    enum RootKeys: CodingKey {
        case kind, data
    }
    
    enum CodingKeys: String, CodingKey {
        // Keys related to the user
        /// The user is banned from this subreddit
        /// This means they cannot post or comment
        case userIsBanned = "user_is_banned"
        /// The user is muted on this subreddit
        /// This means they cannot send modmail
        case userIsMuted = "user_is_muted"
        /// The user marked this subreddit as favorite
        case userHasFavorited = "user_has_favorited"
        /// The user is subscribed to this subreddit
        case userIsSubscriber = "user_is_subscriber"
        /// The user is a subreddit moderator
        case userIsModerator = "user_is_moderator"
        /// The user is a subreddit contributor
        /// This means they are allowed to post if the subreddit is restricted
        case userIsContributor = "user_is_contributor"

        // Keys related to flairs
        /// The subreddit flair is enabled
        case userSrFlairEnabled = "user_sr_flair_enabled"
        /// The subreddit flair is enabled by the user
        case userSrThemeEnabled = "user_sr_theme_enabled"
        /// The background color for the user's flair
        case userFlairBackgroundColor = "user_flair_background_color"
        /// The user can flair in the subreddit
        case userCanFlairInSr = "user_can_flair_in_sr"
        /// The user flair text
        case userFlairText = "user_flair_text"
        /// The user flair CSS class
        case userFlairCSSClass = "user_flair_css_class"
        /// The user flair foreground text color
        case userFlairTextColor = "user_flair_text_color"
        /// The richtext for the user flair
        case userFlairRichtext = "user_flair_richtext"
        /// The template ID for the user flair
        case userFlairTemplateID = "user_flair_template_id"
        /// The subreddit enables the user flair
        case userFlairEnabledInSr = "user_flair_enabled_in_sr"
        /// The position of the user flair
        case userFlairPosition = "user_flair_position"
        /// The user flair type
        case userFlairType = "user_flair_type"
        /// Missing documentation
        case canAssignLinkFlair = "can_assign_link_flair"
        /// The position of the link flair
        case linkFlairPosition = "link_flair_position"
        /// Link flair is enabled
        case linkFlairEnabled = "link_flair_enabled"

        case submitTextHTML = "submit_text_html"
        /// The shown name of the subreddit
        /// Example: help
        case displayName = "display_name"
        case headerImage = "header_img"
        /// A small about text for the subreddit
        /// Example: `"For all your questions about Reddit!"`
        case title
        case primaryColor = "primary_color"
        case activeUserCount = "active_user_count"
        /// The `RedditThing` id of the object
        /// This is generated by taking the `RedditThing` fullname prefix and adding the ID to it
        /// Example: `"t5_2qh4a"`
        case name
        /// The display name prefixed with r/
        /// Example: r/help
        case displayNamePrefixed = "display_name_prefixed"
        
        case quarantine
        case accountsActive = "accounts_active"
        case publicTraffic = "public_traffic"
        case subscribers
        case publicDescription = "public_description"
        case communityIcon = "community_icon"
        case bannerBackgroundImage = "banner_background_image"
        case submitText = "submit_text"
        case descriptionHTML = "description_html"
        case submissionType = "submission_type"
        case publicDescriptionHTML = "public_description_html"
        case subredditType = "subreddit_type"
        case isNSFW = "over18"
        case headerTitle = "header_title"
        /// The description of the subreddit
        case welcomeDescription = "description"
        /// The relative link to this subreddit
        /// Example: /r/help/
        case url
        /// The URL to the banner image
        case bannerImg = "banner_img"
        
        case restrictPosting = "restrict_posting"
        case freeFormReports = "free_form_reports"
        case wikiEnabled = "wiki_enabled"
        case allowGalleries = "allow_galleries"
        case iconSize = "icon_size"
        case iconImg = "icon_img"
        case hideAds = "hide_ads"
        case predictionLeaderboardEntryType = "prediction_leaderboard_entry_type"
        case emojisEnabled = "emojis_enabled"
        case advertiserCategory = "advertiser_category"
        case commentScoreHideMins = "comment_score_hide_mins"
        case allowPredictions = "allow_predictions"
        case originalContentTagEnabled = "original_content_tag_enabled"
        case communityReviewed = "community_reviewed"
        case spoilersEnabled = "spoilers_enabled"
        case commentContributionSettings = "comment_contribution_settings"
        case allowTalks = "allow_talks"
        case headerSize = "header_size"
        case allOriginalContent = "all_original_content"
        case hasMenuWidget = "has_menu_widget"
        case isEnrolledInNewModmail = "is_enrolled_in_new_modmail"
        case keyColor = "key_color"
        case canAssignUserFlair = "can_assign_user_flair"
        case created, wls
        case showMediaPreview = "show_media_preview"
        case allowedMediaInComments = "allowed_media_in_comments"
        case allowVideogifs = "allow_videogifs"
        case shouldArchivePosts = "should_archive_posts"
        case allowPolls = "allow_polls"
        case collapseDeletedComments = "collapse_deleted_comments"
        case emojisCustomSize = "emojis_custom_size"
        case allowVideos = "allow_videos"
        case isCrosspostableSubreddit = "is_crosspostable_subreddit"
        case notificationLevel = "notification_level"
        case shouldShowMediaInCommentsSetting = "should_show_media_in_comments_setting"
        case accountsActiveIsFuzzed = "accounts_active_is_fuzzed"
        case allowPredictionContributors = "allow_prediction_contributors"
        case submitTextLabel = "submit_text_label"
        case allowChatPostCreation = "allow_chat_post_creation"
        case allowDiscovery = "allow_discovery"
        case acceptFollowers = "accept_followers"
        case disableContributorRequests = "disable_contributor_requests"
        case suggestedCommentSort = "suggested_comment_sort"
        case bannerBackgroundColor = "banner_background_color"
        case showMedia = "show_media"
        /// The id of this object
        case id
        case isChatPostFeatureEnabled = "is_chat_post_feature_enabled"
        case submitLinkLabel = "submit_link_label"
        case restrictCommenting = "restrict_commenting"
        case allowImages = "allow_images"
        case lang
        case whitelistStatus = "whitelist_status"
        case createdUTC = "created_utc"
        case bannerSize = "banner_size"
        case mobileBannerImage = "mobile_banner_image"
        case allowPredictionsTournament = "allow_predictions_tournament"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self).nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        /// The `Decoder.container.decode` method uses the `forKey` parameter as a lookup in the `CodingKeys` enum to know what key to decode from the data
        activeAccounts          = try container.decode(Int.self, forKey: .accountsActive)
        allowedSubmissionType   = try container.decode(Submission.SubmissionType.self, forKey: .submissionType)
        description             = try container.decode(String.self, forKey: .welcomeDescription)
        let rawHeaderImg        = try container.decode(String.self, forKey: .headerImage)
        headerImg               = URL(string: rawHeaderImg)!
        isNSFW                  = try container.decode(Bool.self, forKey: .isNSFW)
        relativeURL             = try container.decode(String.self, forKey: .url)
        subredditType           = try container.decode(SubredditType.self, forKey: .subredditType)
        subscribers             = try container.decode(Int.self, forKey: .subscribers)
        title                   = try container.decode(String.self, forKey: .title)
        userIsBanned            = try container.decodeIfPresent(Bool.self, forKey: .userIsBanned) ?? false
        userIsContributor       = try container.decodeIfPresent(Bool.self, forKey: .userIsContributor) ?? false
        userIsModerator         = try container.decodeIfPresent(Bool.self, forKey: .userIsModerator) ?? false
        userIsSubscriber        = try container.decodeIfPresent(Bool.self, forKey: .userIsSubscriber) ?? false
        displayName             = try container.decode(String.self, forKey: .displayName)
        id                      = try container.decode(String.self, forKey: .name)
        apiURL                  = "r/" + displayName
    }
}