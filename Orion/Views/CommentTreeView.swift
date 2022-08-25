//
//  CommentTreeView.swift
//  orion
//
//  Created by Benji Tusk on 8/21/22.
//

import SwiftUI

struct CommentTreeView: View {
    @ObservedObject var listingModel: ListingModel<CommentsAndMore>
    @ObservedObject var model: CommentTreeModel
    init(of submission: Submission) {
        let listingModel = ListingModel<CommentsAndMore>(apiEndpoint: "r/" + submission.subredditName + "/comments/" + submission.id)
        self.model = CommentTreeModel(submission: submission, listingModel: listingModel)
        self.listingModel = listingModel
    }
    var body: some View {
        VStack(alignment: .leading) {
            if let commentsAndMore = listingModel.children {
                ForEach(commentsAndMore) { commentOrMore in
                    RecursiveCommentView(commentOrMore)
                }
            } else {
                ProgressView()
            }
        }
        .padding()
    }
}

struct CommentTree_Previews: PreviewProvider {
    static var previews: some View {
        CommentTreeView(of: .sample)
    }
}
