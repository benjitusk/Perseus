//
//  MoreCommentsView.swift
//  perseus
//
//  Created by Benji Tusk on 8/25/22.
//

import SwiftUI

struct MoreCommentsView: View {
    @StateObject var model: MoreCommentsModel
    let more: MoreComments
    let parentSubmission: Submission
    init(_ moreComments: MoreComments, parentSubmission: Submission) {
        self.more = moreComments
        self.parentSubmission = parentSubmission
        /// Does this line look weird? Check [this out](https://www.swiftui-lab.com/random-lessons#data-10) to see why I did it
        self._model = StateObject(wrappedValue: MoreCommentsModel(moreComments, from: parentSubmission.fullID))
    }
    var body: some View {
        VStack {
            if let children = model.children {
                ForEach(children, id: \.id) { child in
                    RecursiveCommentView(child, parentSubmission: parentSubmission)
                }
            } else {
                Button {
                    model.load()
                } label: {
                    HStack {
                        Text("Load \(more.children.count) more comment\(more.children.count != 1 ? "s":"")")
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .foregroundColor(.blue)
                    .padding(.trailing)
                }
                Divider()
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
