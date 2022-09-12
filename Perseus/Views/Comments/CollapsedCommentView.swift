//
//  CollapsedCommentView.swift
//  perseus
//
//  Created by Benji Tusk on 9/11/22.
//

import SwiftUI

struct CollapsedCommentView: View {
    let comment: Comment
    var body: some View {
        HStack(spacing: 3) {
            Text(comment.author.username)
                .fontWeight(.semibold)
            Text("•")
                .foregroundColor(.gray)
            Text("\(comment.createdAt.timeAgoDisplay())")
                .foregroundColor(.gray)
            Spacer()
            Menu {
                Button(action: {
//                                    withAnimation {
//                                        isCollapsed.toggle()
//                                    }
                }, label: {
                    Text("Collapse")
                })
            } label: {
                Image(systemName: "ellipsis")
                    .padding(4)
                    .foregroundColor(.gray)
            }
        }
        .lineLimit(1)
    }
}

struct CollapsedCommentView_Previews: PreviewProvider {
    static var previews: some View {
        CollapsedCommentView(comment: .sample)
    }
}
