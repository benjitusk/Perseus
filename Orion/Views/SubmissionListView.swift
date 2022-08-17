//
//  SubmissionListView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/31/22.
//

import SwiftUI

struct SubmissionListView: View {
    @State var model: SubmissionListModel
    @State var listingModel: ListingModel<Submission>
    init(subreddit: Subreddit) {
        let listingModel = ListingModel<Submission>(apiEndpoint: "r/" + subreddit.displayName)
        self.model = SubmissionListModel(subreddit: subreddit, listingModel: listingModel)
        self.listingModel = listingModel
    }
    var body: some View {
        if let submissions = listingModel.children {
            ForEach(submissions) { submission in
                NavigationLink(destination: SubmissionView(submission)) {
                    SubmissionTileView(submission: submission)
                }
                .buttonStyle(EmptyButtonStyle())
            }
        }
        Button(action: model.loadMoreIfNeeded) {
            Text("Load More")
                .foregroundColor(.white)
                .padding()
                .backgroundColor(.accentColor)
                .cornerRadius(8)
        }
        .onChange(of: listingModel.children) { _ in
            print("ListingModel children changed!")
        }
    }
}

struct SubmissionListingView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
            .environmentObject(CurrentUser.shared)
    }
}
