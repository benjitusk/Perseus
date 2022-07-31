//
//  SubredditModel.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/25/22.
//

import SwiftUI
class SubredditModel: ObservableObject {
    var subreddit: Subreddit?
    @Published var submissions: [Submission]? // This will eventually be an array of RedditContent, a protocol that posts and comments will conform to
    init(subredditName: String) {
        Reddit.getSubredditByName(subredditName) { result in
            switch result {
            case .success(let subreddit):
                self.subreddit = subreddit
                self.load()
//                print("Subreddit fetched successfully. Subreddit description:\n\(subreddit.description)")
            case .failure(let failure):
                print("Could not get subreddit: \(failure.localizedDescription)")
            }
        }
    }
    
    func load() {
        self.subreddit?.getPosts(by: .hot) { result in
            switch result {
            case .success(let submissions):
                DispatchQueue.main.async {
                    self.submissions = submissions
                }
            case .failure(let error):
                print("An error occurred while fetching posts: \(error)")
            }
        }
    }
    
    func keychainDebug() {
        debugPrint(KeychainHelper.shared.read(service: "oauth-token", account: "reddit.com", type: RedditToken.self))
    }
}
