//
//  SubmissionListModel.swift
//  perseus
//
//  Created by Benji Tusk on 7/31/22.
//

import SwiftUI
class SubmissionListModel: ObservableObject {
    var subreddit: Subreddit
    var listingModel: ListingModel<Submission>

    init(subreddit: Subreddit, listingModel: ListingModel<Submission>) {
        self.subreddit = subreddit
        self.listingModel = listingModel
        load()
        
    }
    
    init(displayName: String, customAPIPath: String) {
        self.subreddit = SpecialSubreddit(displayName: displayName, apiURL: customAPIPath)
        listingModel = ListingModel(apiEndpoint: customAPIPath)
        load()
    }
    
    func loadMoreIfNeeded(check submission: Submission) {
        if submission.id == listingModel.children?.last?.id {
            withAnimation {
                load()
            }
        }
    }
    
    private func load() {
        listingModel.load(the: .next, 15) { error in
            if error != nil {
                print("\(self).load failed: \(error!.localizedDescription)")
            }
        }
    }
}
