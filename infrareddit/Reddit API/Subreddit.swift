//
//  Subreddit.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/25/22.
//

import Foundation
final class Subreddit: RedditThing {
    // TODO: Conform Subreddit to Decodable
    let activeAccounts: Int
    let description: String
    /// The display name of the subreddit, /r/{displayName}
    let name: String
    let headerImg: URL
    let isNSFW: Bool
    let subscribers: Int
    let allowedSubmissionType: Submission.SubmissionType
    let subredditType: SubredditType
    let title: String
    let relativeURL: String
    
    // The following user properties are `false` if the user is not authenticated
    let userIsBanned: Bool
    let userIsContributor: Bool
    let userIsModerator: Bool
    let userIsSubscriber: Bool
    
    func getPosts(by sortingMethod: Subreddit.SortingMethod, completion: @escaping (_: RedditResult<[Submission]>) -> Void) {
        Reddit.getSubredditListing(subreddit: self, before: nil, after: nil) { result in
            switch result {
            case .success(let submissions):
                completion(.success(submissions))
            case .failure(let error):
                print("There was an error fetching your data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    
    init(activeAccounts: Int, description: String, displayName: String, headerImg: URL, isNSFW: Bool, subscribers: Int, allowedSubmissionType: Submission.SubmissionType, subredditType: SubredditType, title: String, relativeURL: String, userIsBanned: Bool, userIsContributor: Bool, userIsModerator: Bool, userIsSubscriber: Bool) {
        self.activeAccounts = activeAccounts
        self.allowedSubmissionType = allowedSubmissionType
        self.description = description
        self.name = displayName
        self.headerImg = headerImg
        self.isNSFW = isNSFW
        self.relativeURL = relativeURL
        self.subscribers = subscribers
        self.subredditType = subredditType
        self.title = title
        self.userIsBanned = userIsBanned
        self.userIsContributor = userIsContributor
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
    
    enum SortingMethod {
        case hot
        case rising
    }
    
    enum RootKeys: CodingKey {
        case kind, data
    }
    
    enum CodingKeys: String, CodingKey {
        case userFlairBackgroundColor = "user_flair_background_color"
        case submitTextHTML = "submit_text_html"
        case restrictPosting = "restrict_posting"
        case userIsBanned = "user_is_banned"
        case freeFormReports = "free_form_reports"
        case wikiEnabled = "wiki_enabled"
        case userIsMuted = "user_is_muted"
        case userCanFlairInSr = "user_can_flair_in_sr"
        case displayName = "display_name"
        case headerImage = "header_img"
        case title
        case allowGalleries = "allow_galleries"
        case iconSize = "icon_size"
        case primaryColor = "primary_color"
        case activeUserCount = "active_user_count"
        case iconImg = "icon_img"
        case displayNamePrefixed = "display_name_prefixed"
        case accountsActive = "accounts_active"
        case publicTraffic = "public_traffic"
        case subscribers
        case userFlairRichtext = "user_flair_richtext"
        case name, quarantine
        case hideAds = "hide_ads"
        case predictionLeaderboardEntryType = "prediction_leaderboard_entry_type"
        case emojisEnabled = "emojis_enabled"
        case advertiserCategory = "advertiser_category"
        case publicDescription = "public_description"
        case commentScoreHideMins = "comment_score_hide_mins"
        case allowPredictions = "allow_predictions"
        case userHasFavorited = "user_has_favorited"
        case userFlairTemplateID = "user_flair_template_id"
        case communityIcon = "community_icon"
        case bannerBackgroundImage = "banner_background_image"
        case originalContentTagEnabled = "original_content_tag_enabled"
        case communityReviewed = "community_reviewed"
        case submitText = "submit_text"
        case descriptionHTML = "description_html"
        case spoilersEnabled = "spoilers_enabled"
        case commentContributionSettings = "comment_contribution_settings"
        case allowTalks = "allow_talks"
        case headerSize = "header_size"
        case userFlairPosition = "user_flair_position"
        case allOriginalContent = "all_original_content"
        case hasMenuWidget = "has_menu_widget"
        case isEnrolledInNewModmail = "is_enrolled_in_new_modmail"
        case keyColor = "key_color"
        case canAssignUserFlair = "can_assign_user_flair"
        case created, wls
        case showMediaPreview = "show_media_preview"
        case submissionType = "submission_type"
        case userIsSubscriber = "user_is_subscriber"
        case allowedMediaInComments = "allowed_media_in_comments"
        case allowVideogifs = "allow_videogifs"
        case shouldArchivePosts = "should_archive_posts"
        case userFlairType = "user_flair_type"
        case allowPolls = "allow_polls"
        case collapseDeletedComments = "collapse_deleted_comments"
        case emojisCustomSize = "emojis_custom_size"
        case publicDescriptionHTML = "public_description_html"
        case allowVideos = "allow_videos"
        case isCrosspostableSubreddit = "is_crosspostable_subreddit"
        case notificationLevel = "notification_level"
        case shouldShowMediaInCommentsSetting = "should_show_media_in_comments_setting"
        case canAssignLinkFlair = "can_assign_link_flair"
        case accountsActiveIsFuzzed = "accounts_active_is_fuzzed"
        case allowPredictionContributors = "allow_prediction_contributors"
        case submitTextLabel = "submit_text_label"
        case linkFlairPosition = "link_flair_position"
        case userSrFlairEnabled = "user_sr_flair_enabled"
        case userFlairEnabledInSr = "user_flair_enabled_in_sr"
        case allowChatPostCreation = "allow_chat_post_creation"
        case allowDiscovery = "allow_discovery"
        case acceptFollowers = "accept_followers"
        case userSrThemeEnabled = "user_sr_theme_enabled"
        case linkFlairEnabled = "link_flair_enabled"
        case disableContributorRequests = "disable_contributor_requests"
        case subredditType = "subreddit_type"
        case suggestedCommentSort = "suggested_comment_sort"
        case bannerImg = "banner_img"
        case userFlairText = "user_flair_text"
        case bannerBackgroundColor = "banner_background_color"
        case showMedia = "show_media"
        case id
        case userIsModerator = "user_is_moderator"
        case isNSFW = "over18"
        case headerTitle = "header_title"
        case welcomeDescription = "description"
        case isChatPostFeatureEnabled = "is_chat_post_feature_enabled"
        case submitLinkLabel = "submit_link_label"
        case userFlairTextColor = "user_flair_text_color"
        case restrictCommenting = "restrict_commenting"
        case userFlairCSSClass = "user_flair_css_class"
        case allowImages = "allow_images"
        case lang
        case whitelistStatus = "whitelist_status"
        case url
        case createdUTC = "created_utc"
        case bannerSize = "banner_size"
        case mobileBannerImage = "mobile_banner_image"
        case userIsContributor = "user_is_contributor"
        case allowPredictionsTournament = "allow_predictions_tournament"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self).nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        /// The `Decoder.container.decode` method uses the `forKey` parameter as a lookup in the `CodingKeys` enum to know what key to decode from the data
        activeAccounts          = try container.decode(Int.self, forKey: .accountsActive)
        allowedSubmissionType   = try container.decode(Submission.SubmissionType.self, forKey: .submissionType)
        description             = try container.decode(String.self, forKey: .welcomeDescription)
        name                    = try container.decode(String.self, forKey: .displayName)
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
    }
    static var sample = Subreddit(activeAccounts: 36_420,
                                  description: "[Rules](https://www.reddit.com/r/pics/wiki/index)\n\n1. No screenshots or pics where the only focus is a screen. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_1_-_no_screenshots)\n\n2. No pictures with added or superimposed digital text. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_2_-_no_digital_elements)\n\n3. No porn or gore. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_3_-_no_porn.2Fgore)\n\n4. No personal information, direct links to any social media, subreddit-related meta-drama, witch-hunts or missing/found posts. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_4_-_no_doxing.2Fwitch_hunts)\n\n5. All titles must follow title rules. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/titles)\n\n6. Submissions are only allowed from one of the approved image hosts. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_6_-_only_allowed_image_hosts) \n\n7. No gifs or videos. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_7_-_no_gifs)\n\n8. Comments must be civil. Any racism, bigotry, or any other kind of hate speech is strictly prohibited and will result in a ban. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_8_-_civility)\n\n9.  No submissions featuring before-and-after depictions of personal health progress or achievement. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_9_-_no_progress_pics)\n\n10. No false claims of ownership (FCoO) or flooding. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_10_-_no_fcoo.2Fflooding)\n\n11. Reposts of images on the front page, or within the set limit of /r/pics/top, will be removed. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_11_-_repost_limitations)\n\n12. Normal users are allowed only one self-promotional link per post. [more&gt;&gt;](https://www.reddit.com/r/pics/wiki/index#wiki_rule_12_-_limited_self-promotion)\n\n---\n\n[Additional/Temporary Rules](https://www.reddit.com/r/pics/wiki/index#wiki_additional.2Ftemporary_rules)\n\n* Serial reposters may be filtered or banned. \n\n* We prefer that new users post original content and not common pictures from the internet.\n\n* All posts by new users require mod approval in order to weed out spammers. \n\n* Please mark spoilers for current movies/games/books with spoiler tags. \n\n---\n\nIf you want a picture that belongs to you to be removed from /r/pics then please file a copyright notice [here](https://reddit.zendesk.com/hc/en-us/requests/new?ticket_form_id=73465).\n\n---\n\nClick [here](https://www.reddit.com/r/pics/wiki/links) to find more specialized picture subreddits",
                                  displayName: "pics",
                                  headerImg: URL(string: "https://b.thumbs.redditmedia.com/1zT3FeN8pCAFIooNVuyuZ0ObU0x1ro4wPfArGHl3KjM.png")!,
                                  isNSFW: false,
                                  subscribers: 29_213_242,
                                  allowedSubmissionType: .link,
                                  subredditType: .public,
                                  title: "Reddit Pics",
                                  relativeURL: "/r/pics",
                                  userIsBanned: false,
                                  userIsContributor: false,
                                  userIsModerator: false,
                                  userIsSubscriber: false)
}
