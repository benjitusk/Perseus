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
        if let children = model.children {
            ForEach(children, id: \.id) { treeable in
                TreeableView(treeable)
            }
        } else {
            Button {
                model.load()
            } label: {
                HStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: UI.Comments.colorBarWidth)
                        .foregroundColor(more.depth > 0 ?
                                         UI.Comments.colors[(more.depth - 1) % UI.Comments.colors.count] :
                                            Color.clear
                        )
                        .padding(.vertical, UI.Comments.indentationFactor)
                    Text("Load \(more.children.count) more comment\(more.children.count != 1 ? "s":"")")
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding(.leading, UI.Comments.indentationFactor * CGFloat(more.depth))
                
                .foregroundColor(.blue)
                .padding(.trailing)
                .swipeActions {
                    Button(action: {print("Swiper no swiping!")}) {
                        Label("Print log", systemImage: "printer")
                    }
                }
                
            }
        }
        
    }
}

struct MoreCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTree_Previews.previews
    }
}
