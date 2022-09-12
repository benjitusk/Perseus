//
//  RecursiveCommentView.swift
//  perseus
//
//  Created by Benji Tusk on 8/28/22.
//

import SwiftUI

struct RecursiveCommentView: View {
    let comment: Comment
    @StateObject private var model = RecursiveCommentModel()
    @State private var isCollapsed = false
    init(_ comment: Comment) {
        self.comment = comment
        self.isCollapsed = comment.isCollapsed
    }
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: UI.Comments.colorBarWidth)
                .foregroundColor(comment.depth > 0 ?
                                 UI.Comments.colors[(comment.depth - 1) % UI.Comments.colors.count] :
                                    Color.clear
                )
                .padding(.vertical, UI.Comments.indentationFactor)
            if !isCollapsed {
                CommentView(comment)
            } else {
                CollapsedCommentView(comment: comment)
            }
        }
        .padding(.leading, UI.Comments.indentationFactor * CGFloat(comment.depth))
        .onTapGesture {
            withAnimation {
                isCollapsed.toggle()
            }
        }
        .swipeActions {
            Button {
                print("Not yet implemented")
            } label: {
                if isCollapsed {
                    Label("Expand", systemImage: "arrow.up.and.down")
                } else {
                    Label("Collapse", systemImage: "arrow.up.to.line.compact")
                }
            }
        }

        if !isCollapsed {
            ForEach(comment.replyListing?.children ?? []) {
                TreeableView($0.treeable)
            }
        }
    }
    
    private func setIsCollapsed(_ newState: Bool) {
        self.isCollapsed = newState
    }
}

fileprivate class RecursiveCommentModel: ObservableObject {
    @Published var isCollapsed = true
    func setCollapseState() {
        self.isCollapsed = true
    }
}

struct RecursiveCommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTree_Previews.previews
    }
}
