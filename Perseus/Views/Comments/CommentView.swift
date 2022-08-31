//
//  CommentView.swift
//  perseus
//
//  Created by Alberto Delle Donne on 12/08/22.
//

import SwiftUI

struct CommentView: View {
    static let colors: [Color] = [.red, .orange, .yellow, .green, .teal, .blue, .indigo, .purple]
    let comment: Comment
    let parentSubmissionID: String
    init(_ comment: Comment, parentSubmissionID: String) {
        self.comment = comment
        self.parentSubmissionID = parentSubmissionID
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("u/\(comment.author.username)")
                Text("•")
                    .foregroundColor(.gray)
                Text("\(comment.createdAt.timeAgoDisplay())")
                    .foregroundColor(.gray)
            }.fontWeight(.semibold)
                .lineLimit(1)
            HStack {
                Text(comment.body.toAttributedMarkdownString)
                Spacer()
            }
            .foregroundColor(.gray)
            .fontWeight(.semibold)
            .lineLimit(1)
            
            if !isCollapsed {
                HStack {
                    Text(comment.body.toAttributedMarkdownString)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding(.bottom)
                if let replies = comment.replyListing, shouldShowChildren {
                    ForEach(replies.children) { reply in
                        RecursiveCommentView(reply.commentOrMore, parentSubmission: parentSubmission)
                    }
                }
            }
        }
        .padding(.vertical)
        .padding(.leading)
        .backgroundColor(Color(uiColor: UIColor.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: UI.kCornerRadius))
        .padding(.trailing, 2.7)
        .shadow(color:CommentView.colors[comment.depth % CommentView.colors.count], radius: 2)
        .padding(.vertical, 5)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTree_Previews.previews
    }
}
