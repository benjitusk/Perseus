//
//  CommentTreeView.swift
//  orion
//
//  Created by Benji Tusk on 8/21/22.
//

import SwiftUI

struct CommentTreeView: View {
    @ObservedObject var listingModel: ListingModel<Comment>
    @ObservedObject var model: CommentTreeModel
    init(of submission: Submission) {
        let listingModel = ListingModel<Comment>(apiEndpoint: "r/" + submission.subredditName + "/comments/" + submission.fullID)
        self.model = CommentTreeModel(submission: submission, listingModel: listingModel)
        self.listingModel = listingModel
    }
    var body: some View {
        if let comments = model.comments {
            ForEach(comments) { comment in
                CommentView(comment)
            }
        } else {
            ProgressView()
        }
    }
}

struct CommentTree_Previews: PreviewProvider {
    static var previews: some View {
        CommentTreeView(of: .sample)
    }
}

class CommentTreeModel: ObservableObject {
    var listingModel: ListingModel<Comment>
    var submisison: Submission
    @Published var comments: [Comment]?
    init(submission: Submission, listingModel: ListingModel<Comment>) {
        self.submisison = submission
        self.listingModel = listingModel
        load()
    }
    
    func load() {
        
    }
    
}
