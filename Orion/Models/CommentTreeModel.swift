//
//  CommentTreeModel.swift
//  orion
//
//  Created by Benji Tusk on 8/22/22.
//

import Foundation

class CommentTreeModel: ObservableObject {
    var listingModel: ListingModel<CommentsAndMore>
    var submisison: Submission
    init(submission: Submission, listingModel: ListingModel<CommentsAndMore>) {
        self.submisison = submission
        self.listingModel = listingModel
        load()
    }
    
    private func load() {
        listingModel.load(the: .next, 15) { error in
            if error != nil {
                print("\(self).load failed: \(error!.localizedDescription)")
            }
        }
    }

}
