//
//  SubmissionListView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/31/22.
//

import SwiftUI

struct SubmissionListView: View {
    @ObservedObject var model: SubmissionListModel
    init(subreddit: Subreddit) {
        self.model = SubmissionListModel(subreddit: subreddit)
    }
    var body: some View {
        ZStack {
            Color.black.opacity(0.05).ignoresSafeArea()
            ScrollView {
                LazyVStack {
                    if let listing = model.listing {
                        ForEach(listing.children) { submission in
                            NavigationLink(destination: SubmissionView(submission)) {
                                SubmissionTileView(submission: submission)
                            }
                            .buttonStyle(EmptyButtonStyle())
                            .onAppear {
                                model.lastRenderedSubmissionID = submission.id
                                model.renderedSubmissions.insert(submission.id)
                                model.loadMoreIfNeeded()
                            }
                            .onDisappear {
                                print("unrendered submission on r/\(submission.subredditName)")
                            }
                            
                        }
                    }
                }
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
