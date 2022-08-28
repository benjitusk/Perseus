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
        VStack {
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
    }
}

//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView(.sample)
//    }
//}

struct RecursiveCommentView: View {
    let commentOrMore: CommentsAndMore
    init(_ commentOrMore: CommentsAndMore) {
        self.commentOrMore = commentOrMore
        
    }
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                if let comment = commentOrMore.comment {
                    CommentView(comment)
                } else if let more = commentOrMore.more, !more.children.isEmpty {
                    MoreCommentsView(more)
                }
            }
            Spacer()
        }
        .padding(.leading)
        .padding(.vertical)
        .backgroundColor(.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
