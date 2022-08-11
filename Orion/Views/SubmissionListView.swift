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
    @State private var SortingMethod = 0
    var sections = ["Hot", "Rising"]
    var body: some View {
        ZStack {
            Color.black.opacity(0.05).ignoresSafeArea()
            ScrollView {
                LazyVStack {
                    Picker(selection: $SortingMethod,label: Text("Sections")) {
                        ForEach(0 ..< sections.count) {
                            Text(self.sections[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .padding(.top, 4)
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
    func currentSection()-> String {
            switch SortingMethod {
                case 0:
                    return "FIRST SECTION"
                case 1:
                    return "SECOND SECTION"
                case 2:
                    return "THIRD SECTION"
                default:
                    return "DEFAULT SECTION"
            }
        }
}

struct SubmissionListingView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
            .environmentObject(CurrentUser.shared)
    }
}
