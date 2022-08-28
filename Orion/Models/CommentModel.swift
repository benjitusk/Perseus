//
//  CommentModel.swift
//  orion
//
//  Created by Benji Tusk on 8/22/22.
//

import Foundation

class CommentModel: ObservableObject {
    var listingModel: ListingModel<CommentsAndMore>
    init(listingModel: ListingModel<CommentsAndMore>) {
        self.listingModel = listingModel
        load()
    }
    
    private func load() {
        listingModel.load(the: .next, 70) { error in
            if error != nil {
                print("\(self).load failed: \(error!.localizedDescription)")
            }
        }
    }

}
