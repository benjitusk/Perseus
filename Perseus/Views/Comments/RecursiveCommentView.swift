//
//  RecursiveCommentView.swift
//  perseus
//
//  Created by Benji Tusk on 8/28/22.
//

import SwiftUI

struct RecursiveCommentView: View {
    let commentTreeThing: CommentTreeable
    let parentSubmission: Submission
    init(_ cTT: CommentTreeable, parentSubmission: Submission) {
        self.commentTreeThing = cTT
        self.parentSubmission = parentSubmission
    }
    var body: some View {
        VStack(alignment: .leading) {
            if let comment = commentTreeThing as? Comment {
                CommentView(comment, parentSubmission: parentSubmission)
            } else if let more = commentTreeThing as? MoreComments, !more.children.isEmpty {
                MoreCommentsView(more, parentSubmission: parentSubmission)
            }
        }
        
    }
}

struct RecursiveCommentView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                ForEach(Comment.sampleTree) { comment in
                    RecursiveCommentView(comment.commentOrMore, parentSubmission: .sample)
                }
            }
            .padding(.vertical)
            .padding(.leading)
        }
    }
}
