//
//  RecursiveCommentView.swift
//  orion
//
//  Created by Benji Tusk on 8/28/22.
//

import SwiftUI

struct RecursiveCommentView: View {
    let commentOrMore: CommentsAndMore
    let parentSubmissionID: String
    init(_ commentOrMore: CommentsAndMore, parentSubmissionID: String) {
        self.commentOrMore = commentOrMore
        self.parentSubmissionID = parentSubmissionID
        
    }
    var body: some View {
        VStack(alignment: .leading) {
            if let comment = commentOrMore.comment {
                CommentView(comment, parentSubmissionID: parentSubmissionID)
            } else if let more = commentOrMore.more, !more.children.isEmpty {
                MoreCommentsView(more, parentSubmissionID: parentSubmissionID)
            }
        }
        .shadow(radius: 2)
        .padding(.vertical, 5)
        
    }
}

struct RecursiveCommentView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            CommentTreeView(of: .sample)
                .shadow(radius: 2)
        }
    }
}
