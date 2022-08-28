//
//  CommentView.swift
//  orion
//
//  Created by Alberto Delle Donne on 12/08/22.
//

import SwiftUI

struct CommentView: View {
    let comment: Comment
    init(_ comment: Comment) {
        self.comment = comment
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
            if let replies = comment.replies {
                ForEach(replies.children) {
                    RecursiveCommentView($0)
                }
            }
        }
        .padding()
        .backgroundColor(Color(uiColor: UIColor.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 9))
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(.sample)
    }
}
