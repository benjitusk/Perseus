//
//  SubredditView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/25/22.
//

import SwiftUI

struct SubredditView: View {
    @StateObject var model = SubredditModel(subredditName: "swift")
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if let submissions = model.submissions {
                        ForEach(submissions) { submission in
                            SubmissionTileView(submission: submission)
                                .padding()
                        }
                    }
                    Button(action: model.load) {
                        Text("Load subreddit feed")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("r/" + (model.subreddit?.name.capitalized ?? ""))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SubredditView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(CurrentUser.shared)
    }
}
