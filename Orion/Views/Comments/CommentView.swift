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
        HStack {
            Markdown(comment.body)
            Spacer()
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
        VStack(alignment: .leading) {
            HStack {
                Rectangle()
                    .frame(width: 1)
                if let comment = commentOrMore.comment {
                    VStack {
                        CommentView(comment)
                        if let replies = comment.replies?.children {
                            ForEach(replies) { reply in
                                RecursiveCommentView(reply)
                            }
                        }
                    }
                } else if let more = commentOrMore.more, !more.children.isEmpty {
                    Text("Load \(more.children.count) more comment\(more.children.count != 1 ? "s":"")")
                }
            }
        }
        .padding(.leading)
        .padding(.vertical)
                .backgroundColor(.white)
                .cornerRadius(8)
                .shadow(radius: 2)
                .border(.red)
    }
}

struct RecursiveCommentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
        //        NavigationView {
        //            ZStack {
        //                Color.black.opacity(0.05).ignoresSafeArea()
        //                ScrollView {
        //                    CommentTreeView(of: .sample)
        //                }
        //            }
        //        }
    }
}
