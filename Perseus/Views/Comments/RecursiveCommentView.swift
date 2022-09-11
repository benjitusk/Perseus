//
//  RecursiveCommentView.swift
//  perseus
//
//  Created by Benji Tusk on 8/28/22.
//

import SwiftUI

struct RecursiveCommentView: View {
    let comment: Comment
    let parentSubmission: Submission
    init(_ comment: Comment, parentSubmission: Submission) {
        self.comment = comment
        self.parentSubmission = parentSubmission
    }
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: UI.Comments.colorBarWidth)
                .foregroundColor(comment.depth > 0 ?
                                 UI.Comments.colors[(comment.depth - 1) % UI.Comments.colors.count] :
                                    Color.clear
                )
                .padding(.vertical, UI.Comments.indentationFactor)
            CommentView(comment, parentSubmission: parentSubmission)
        }
        .padding(.leading, UI.Comments.indentationFactor * CGFloat(comment.depth))
        ForEach(comment.replyListing?.children ?? []) {
            TreeableView($0.treeable, parentSubmission: parentSubmission)
        }
        
    }
}

struct RecursiveCommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTree_Previews.previews
    }
}
