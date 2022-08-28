//
//  MoreCommentsView.swift
//  orion
//
//  Created by Benji Tusk on 8/25/22.
//

import SwiftUI

struct MoreCommentsView: View {
//    @ObservedObject var listingModel: ListingModel<CommentsAndMore>
//    var model: CommentModel
    let more: MoreComments
    init(_ moreComments: MoreComments) {
        self.more = moreComments
//        let listingModel = ListingModel<CommentsAndMore>(apiEndpoint: "/api/morechildren")
//        model = CommentModel(listingModel: listingModel)
//        self.listingModel = listingModel
    }
    var body: some View {
        Text("Load \(more.children.count) more comment\(more.children.count != 1 ? "s":"")")
            .foregroundColor(.blue)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .backgroundColor(Color(uiColor: UIColor.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 9))
    }
}

struct MoreCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTree_Previews.previews
    }
}
