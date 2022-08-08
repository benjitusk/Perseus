//
//  SubmissionListModel.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/31/22.
//

import SwiftUI
class SubmissionListModel: ObservableObject {
    var subreddit: Subreddit
    var lastRenderedSubmissionID = ""
    var renderedSubmissions: Set<String> = []
    @Published var listing: Listing<Submission>? = nil
    
    
    func initialLoad() {
        self.subreddit.getPosts(by: .hot, before: nil, after: nil) { result in
            switch result {
            case .success(let listing):
                DispatchQueue.main.async {
                    self.listing = listing
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func loadMoreIfNeeded() {
        if renderedSubmissions.count % 20 == 0 {
            self.subreddit.getPosts(by: .hot, before: nil, after: lastRenderedSubmissionID) { result in
                switch result {
                case .success(let newListing):
                    DispatchQueue.main.async {
                        withAnimation {
                            self.listing?.children.append(contentsOf: newListing.children)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    init(subreddit: Subreddit) {
        self.subreddit = subreddit
        initialLoad()
    }
    
    init(displayName: String, customAPIPath: String) {
        self.subreddit = SpecialSubreddit(displayName: displayName, apiURL: customAPIPath)
        initialLoad()
    }
}
