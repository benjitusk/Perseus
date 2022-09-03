//
//  CommentView.swift
//  perseus
//
//  Created by Alberto Delle Donne on 12/08/22.
//

import SwiftUI

struct CommentView: View {
    static let colors: [Color] = [.red, .orange, .yellow, .green, .teal, .blue, .indigo, .purple]
    let comment: Comment
    let parentSubmission: Submission
    @State var isCollapsed = false
    let shouldShowChildren: Bool
    init(_ comment: Comment, parentSubmission: Submission, renderChildren: Bool = true) {
        self.comment = comment
        self.parentSubmission = parentSubmission
        self.isCollapsed = comment.isCollapsed
        self.shouldShowChildren = renderChildren
    }
    var body: some View {
        VStack(alignment: .leading) {
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
                            Menu {
                                Button(action: {
                                    withAnimation {
                                        isCollapsed.toggle()
                                    }
                                }, label: {
                                    Text("Collapse")
                                })
                            } label: {
                                Image(systemName: "ellipsis")
                                    .padding()
                                    .foregroundColor(.gray)
                            }
                        }.lineLimit(1)
                        if !isCollapsed {
                            Text(comment.body.toAttributedMarkdownString)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    HStack {
                        Image(systemName: "arrowshape.left")
                            .rotationEffect(Angle(degrees: 90))
                        Text("\(comment.score)")
                        Image(systemName: "arrowshape.left")
                            .rotationEffect(Angle(degrees: 270))
                    }
                }
            }.padding(.trailing)
            Divider()
            if let replies = comment.replyListing, shouldShowChildren {
                ForEach(replies.children) { reply in
                    RecursiveCommentView(reply.commentOrMore, parentSubmission: parentSubmission)
                        .padding(.leading)
                }
            }
        }
        .contextMenu {
            Text("Cool")
//            CommentView(self.comment, parentSubmission: self.parentSubmission)
        } preview: {
            Text(comment.body.toAttributedMarkdownString)
                .fixedSize(horizontal: true, vertical: false)

                .padding()
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        RecursiveCommentView_Previews.previews
    }
}
