//
//  PostRowHeader.swift
//  orion
//
//  Created by Alberto Delle Donne on 11/08/22.
//

import SwiftUI

struct PostRowHeader: View {
    let submission: Submission
    var body: some View {
        HStack(spacing: 4) {
            Text("r/\(submission.subredditName)")
                .fontWeight(.bold)
            Text("•")
            Image(systemName: "person")
            Text("u/\(submission.author.username)")
            Text("•")
            Image(systemName: "clock")
            Text("\(submission.createdAt.timeAgoDisplay())")
            Spacer()
        }.font(.caption)
    }
}

struct PostRowHeader_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
    }
}
