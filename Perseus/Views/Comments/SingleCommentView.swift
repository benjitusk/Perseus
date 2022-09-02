//
//  SingleCommentView.swift
//  perseus
//
//  Created by Benji Tusk on 8/30/22.
//

import SwiftUI

struct SingleCommentView: View {
    let comment: Comment
    init(_ comment: Comment) {
        self.comment = comment
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("u/\(comment.author.username)")
                    .foregroundColor(.primary)
                Text("•")
                Text("\(comment.createdAt.timeAgoDisplay())")
                Spacer()
            }
            .foregroundColor(.gray)
            .fontWeight(.semibold)
            .lineLimit(1)
            
            HStack {
                Text(comment.body.toAttributedMarkdownString)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
        }
        .padding(.vertical)
        .padding(.leading)
        .padding(.trailing, 2.7)
        .padding(.vertical, 5)
        .clipShape(RoundedRectangle(cornerRadius: UI.kCornerRadius))
        .background {
            Color(uiColor: UIColor.systemGray5)
                .clipShape(RoundedRectangle(cornerRadius: UI.kCornerRadius))
                .shadow(color:CommentView.colors[comment.depth % CommentView.colors.count], radius: 2)
        }

    }
}

struct SingleCommentView_Previews: PreviewProvider {
    static var previews: some View {
        SingleCommentView(.sample)
    }
}
