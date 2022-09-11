//
//  TreeableView.swift
//  perseus
//
//  Created by Benji Tusk on 9/8/22.
//

import SwiftUI

struct TreeableView: View {
    let treeableThing: CommentTreeable
    let parentSubmission: Submission
    init(_ treeable: CommentTreeable, parentSubmission: Submission) {
        self.treeableThing = treeable
        self.parentSubmission = parentSubmission
    }
    var body: some View {
        if let comment = self.treeableThing as? Comment {
            RecursiveCommentView(comment, parentSubmission: parentSubmission)
        } else if let more = self.treeableThing as? MoreComments, !more.children.isEmpty {
            MoreCommentsView(more, parentSubmission: parentSubmission)
        }

    }
}

struct TreeableView_Previews: PreviewProvider {
    static var previews: some View {
        TreeableView(Comment.sample, parentSubmission: .sample)
    }
}
