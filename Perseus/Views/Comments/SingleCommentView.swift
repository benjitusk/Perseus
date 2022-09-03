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
        HStack {
            Rectangle()
                .frame(width: 2)
                .foregroundColor(CommentView.colors[comment.depth % CommentView.colors.count])
            VStack(alignment: .trailing, spacing: 7) {
                VStack(alignment: .leading) {
                    HStack(spacing: 3) {
                        Text(comment.author.username)
                            .fontWeight(.semibold)
                        Text("•")
                            .foregroundColor(.gray)
                        Text("\(comment.createdAt.timeAgoDisplay())")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                   
                        Text(comment.body.toAttributedMarkdownString)
                            .fixedSize(horizontal: false, vertical: true)
                    
                }
                HStack {
                    Image(systemName: "arrowshape.left")
                        .rotationEffect(Angle(degrees: 90))
                    Text("134")
                    Image(systemName: "arrowshape.left")
                        .rotationEffect(Angle(degrees: 270))
                }
            }
        }.padding(.trailing)
    }
}

struct SingleCommentView_Previews: PreviewProvider {
    static var previews: some View {
        SingleCommentView(.sample)
    }
}
