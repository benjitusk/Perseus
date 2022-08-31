//
//  CommentTreeView.swift
//  perseus
//
//  Created by Benji Tusk on 8/21/22.
//

import SwiftUI

struct CommentTreeView: View {
    @StateObject var listingModel: ListingModel<CommentsAndMore>
    @StateObject var model: CommentModel
    let parentSubmission: Submission
    init(of submission: Submission) {
        self.parentSubmission = submission
        let listingModel = ListingModel<CommentsAndMore>(apiEndpoint: "r/" + submission.subredditName + "/comments/" + submission.id)
        self._model = StateObject(wrappedValue: CommentModel(listingModel: listingModel))
        self._listingModel = StateObject(wrappedValue: listingModel)
    }
    var body: some View {
        VStack(alignment: .leading) {
            if let commentsAndMore = listingModel.children {
                ForEach(commentsAndMore) { commentOrMore in
                    RecursiveCommentView(commentOrMore.commentOrMore, parentSubmission: parentSubmission)
                }
            } else {
                ProgressView()
            }
        }
        .padding(.vertical)
        .padding(.leading)
        .onAppear {
            self.model.initialLoad()
        }
    }
}

struct CommentTree_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            CommentTreeView(of: .sample)
        }
    }
}
