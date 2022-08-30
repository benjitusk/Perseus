//
//  CommentTreeView.swift
//  perseus
//
//  Created by Benji Tusk on 8/21/22.
//

import SwiftUI

struct CommentTreeView: View {
    @ObservedObject var listingModel: ListingModel<CommentsAndMore>
    @ObservedObject var model: CommentModel
    let parentSubmissionID: String
    init(of submission: Submission) {
        self.parentSubmissionID = submission.fullID
        let listingModel = ListingModel<CommentsAndMore>(apiEndpoint: "r/" + submission.subredditName + "/comments/" + submission.id)
        self.model = CommentModel(listingModel: listingModel)
        self.listingModel = listingModel
        model.load()
    }
    var body: some View {
        VStack(alignment: .leading) {
            if let commentsAndMore = listingModel.children {
                ForEach(commentsAndMore) { commentOrMore in
                    RecursiveCommentView(commentOrMore.commentOrMore, parentSubmissionID: parentSubmissionID)
                }
            } else {
                ProgressView()
            }
        }
        .padding(.vertical)
        .padding(.leading)

    }
}

struct CommentTree_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            CommentTreeView(of: .sample)
        }
    }
}
