//
//  MoreCommentsView.swift
//  orion
//
//  Created by Benji Tusk on 8/25/22.
//

import SwiftUI

struct MoreCommentsView: View {
    @ObservedObject var listingModel: ListingModel<CommentsAndMore>
    var model: CommentModel
    let more: MoreComments
    let parentSubmissionID: String
    init(_ moreComments: MoreComments, parentSubmissionID: String) {
        self.more = moreComments
        self.parentSubmissionID = parentSubmissionID
        var queryParameters: [URLQueryItem] = []
        queryParameters.append(URLQueryItem(name: "link_id", value: parentSubmissionID))
        queryParameters.append(URLQueryItem(name: "id", value: more.id))
        let listingModel = ListingModel<CommentsAndMore>(apiEndpoint: "/api/morechildren", queryParameters: queryParameters)
        model = CommentModel(listingModel: listingModel)
        self.listingModel = listingModel
    }
    var body: some View {
        if let children = model.listingModel.children {
            ForEach(children) { child in
                RecursiveCommentView(child, parentSubmissionID: parentSubmissionID)
            }
        } else {
            Button {
                model.load()
            } label: {
                HStack {
                    Text("Load \(more.children.count) more comment\(more.children.count != 1 ? "s":"")")
                    Spacer()
                }
                .foregroundColor(.blue)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .backgroundColor(Color(uiColor: UIColor.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: UI.kCornerRadius))
            }
        }
    }
}

struct MoreCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTree_Previews.previews
    }
}
