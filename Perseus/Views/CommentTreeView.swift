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
        // Get top level comments
        if let children = listingModel.children?.filter({$0.treeable.depth == 0}) {
            if children.count > 0 {
                ForEach(children, id: \.id) { commentOrMore in
                    let treeable = commentOrMore.treeable
                    TreeableView(treeable, parentSubmission: parentSubmission)
                        .padding(.leading, CGFloat(treeable.depth) * 10)
                        .listRowInsets(.init())
                }
            }
        } else {
            ProgressView()
                .onAppear {
                    model.initialLoad()
                }
        }
    }
}

struct CommentTree_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CommentTreeView(of: .sample)
        }
        .listStyle(.plain)
    }
}
