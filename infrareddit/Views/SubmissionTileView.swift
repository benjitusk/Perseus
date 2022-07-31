//
//  SubmissionTileView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/27/22.
//

import SwiftUI

struct SubmissionTileView: View {
    let submission: Submission
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(.init(submission.title))
                        .bold()
                    Spacer()
                }
                .padding(.bottom, 5)
                Text(submission.selfText)
//                    .padding()
            }
            .padding()
            .background(
                Color.white
            )
            .cornerRadius(10)
            .shadow(radius: 10)
            
            HStack {
                Text("/u/" + submission.authorName)
                Text("•")
                Text("/r/" + submission.subredditName)
                Spacer()
                Label("\(submission.upVotes)", systemImage: "arrow.up")
                Label("\(submission.downVotes)", systemImage: "arrow.down")
            }
            .foregroundColor(.gray)
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .background(
            Color.white
        )
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding(5)
        
    }
}

struct SubmissionView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            SubmissionTileView(submission: .sample)
            SubmissionTileView(submission: .sample)
            SubmissionTileView(submission: .sample)
        }
//        .padding()
    }
}
