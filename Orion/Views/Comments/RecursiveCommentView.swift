//
//  RecursiveCommentView.swift
//  orion
//
//  Created by Benji Tusk on 8/28/22.
//

import SwiftUI

struct RecursiveCommentView: View {
    let commentOrMore: CommentsAndMore
    init(_ commentOrMore: CommentsAndMore) {
        self.commentOrMore = commentOrMore
        
    }
    var body: some View {
        VStack(alignment: .leading) {
            if let comment = commentOrMore.comment {
                CommentView(comment, parentSubmissionID: parentSubmissionID)
            } else if let more = commentOrMore.more, !more.children.isEmpty {
                MoreCommentsView(more)
            }
        }
        .padding(.vertical, 5)
        
        
    }
}

struct RecursiveCommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTreeView(of: .sample)
        .shadow(radius: 2)
    }
}
