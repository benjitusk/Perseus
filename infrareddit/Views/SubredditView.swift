//
//  SubredditView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/25/22.
//

import SwiftUI

struct SubredditView: View {
    @StateObject var model = SubredditModel(subredditName: "all")
    var body: some View {
        ScrollView {
            VStack {
                if let submissions = model.submissions {
                    ForEach(submissions) { submission in
                        SubmissionView(submission: submission)
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
    }
}

struct SubredditView_Previews: PreviewProvider {
    static var previews: some View {
        SubredditView()
    }
}
