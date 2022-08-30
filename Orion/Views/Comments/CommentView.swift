//
//  CommentView.swift
//  orion
//
//  Created by Alberto Delle Donne on 12/08/22.
//

import SwiftUI

struct CommentView: View {
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
            if let replies = comment.replyListing {
                ForEach(replies.children) { reply in
                    RecursiveCommentView(reply.commentOrMore, parentSubmissionID: parentSubmissionID)
                }
            }
        }
        .padding(.vertical)
        .padding(.leading)
        .backgroundColor(Color(uiColor: UIColor.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: UI.kCornerRadius))
        .padding(.trailing, 2.7)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTree_Previews.previews
    }
}
