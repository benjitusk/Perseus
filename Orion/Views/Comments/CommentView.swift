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
        VStack(alignment: .leading) {
                if let comment = commentOrMore.comment {
                    VStack {
                        CommentView(comment)
                        if let replies = comment.replies?.children {
                            ForEach(replies) { reply in
                                RecursiveCommentView(reply)
                            }
                        }
                    }
                    .padding(.leading)
                } else if let more = commentOrMore.more, !more.children.isEmpty {
                    Text("Load \(more.children.count) more comment\(more.children.count != 1 ? "s":"")")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .backgroundColor(Color(uiColor: UIColor.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                }
       
        .padding(.vertical, 5)
        
                
    }
}

struct RecursiveCommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTreeView(of: .sample)
        //        NavigationView {
        //            ZStack {
        //                Color.black.opacity(0.05).ignoresSafeArea()
        //                ScrollView {
        //                    CommentTreeView(of: .sample)
        //                }
        //            }
        //        }
        .shadow(radius: 2)
    }
}
