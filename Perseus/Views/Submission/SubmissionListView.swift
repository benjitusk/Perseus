//
//  SubmissionListView.swift
//  perseus
//
//  Created by Benji Tusk on 7/31/22.
//

import SwiftUI

struct SubmissionListView: View {
    @StateObject var model: SubmissionListModel
    @StateObject var listingModel: ListingModel<Submission>
    init(subreddit: Subreddit) {
        let listingModel = ListingModel<Submission>(apiEndpoint: subreddit.apiURL)
        self._model = StateObject(wrappedValue: SubmissionListModel(subreddit: subreddit, listingModel: listingModel))
        self._listingModel = StateObject(wrappedValue: listingModel)
    }
    var body: some View {
        if let submissions = listingModel.children {
            ForEach(submissions) { submission in
                NavigationLink(destination: SubmissionView(submission)) {
                    SubmissionTileView(submission: submission)
                        .onAppear {
                            model.loadMoreIfNeeded(check: submission)
                        }
                }
                .buttonStyle(EmptyButtonStyle())
            }
        }
    }
}

struct SubmissionListingView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
            .environmentObject(CurrentUser.shared)
    }
}
