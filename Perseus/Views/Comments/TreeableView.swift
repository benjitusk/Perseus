//
//  TreeableView.swift
//  perseus
//
//  Created by Benji Tusk on 9/8/22.
//

import SwiftUI

struct TreeableView: View {
    @EnvironmentObject var parentSubmission: Submission
    let treeableThing: CommentTreeable
    init(_ treeable: CommentTreeable) {
        self.treeableThing = treeable
    }
    var body: some View {
        if let comment = self.treeableThing as? Comment {
            RecursiveCommentView(comment)
        } else if let more = self.treeableThing as? MoreComments, !more.children.isEmpty {
            MoreCommentsView(more, parentSubmission: parentSubmission)
        }

    }
}

struct TreeableView_Previews: PreviewProvider {
    static var previews: some View {
        TreeableView(Comment.sample)
            .environmentObject(Submission.sample)
    }
}
