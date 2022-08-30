//
//  MoreCommentsView.swift
//  orion
//
//  Created by Benji Tusk on 8/25/22.
//

import SwiftUI

struct MoreCommentsView: View {
    @ObservedObject var model: MoreCommentsModel
    let more: MoreComments
    let parentSubmissionID: String
    init(_ moreComments: MoreComments, parentSubmissionID: String) {
        self.more = moreComments
        self.parentSubmissionID = parentSubmissionID
        self.model = MoreCommentsModel(moreComments, from: parentSubmissionID)
    }
    var body: some View {
        VStack {
            if let children = model.children {
                ForEach(children, id: \.id) { child in
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
                .shadow(radius: 2)
            }
        }
        .padding(.vertical, 5)

    }
}

struct MoreCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTree_Previews.previews
    }
}
