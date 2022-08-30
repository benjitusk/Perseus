//
//  RecursiveCommentView.swift
//  orion
//
//  Created by Benji Tusk on 8/28/22.
//

import SwiftUI

struct RecursiveCommentView: View {
    let commentTreeThing: CommentTreeable
    let parentSubmissionID: String
    init(_ cTT: CommentTreeable, parentSubmissionID: String) {
        self.commentTreeThing = cTT
        self.parentSubmissionID = parentSubmissionID
        
    }
    var body: some View {
        VStack(alignment: .leading) {
            if let comment = commentTreeThing as? Comment {
                CommentView(comment, parentSubmissionID: parentSubmissionID)
            } else if let more = commentTreeThing as? MoreComments, !more.children.isEmpty {
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
