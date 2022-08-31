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
                Text("u/\(comment.author.username)")
                    .foregroundColor(.primary)
                Text("•")
                Text("\(comment.createdAt.timeAgoDisplay())")
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
                }
            }
            .foregroundColor(.gray)
            .fontWeight(.semibold)
            .lineLimit(1)
            
            if !isCollapsed {
                HStack {
                    Text(comment.body.toAttributedMarkdownString)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding(.bottom)
                if let replies = comment.replyListing, shouldShowChildren {
                    ForEach(replies.children) { reply in
                        RecursiveCommentView(reply.commentOrMore, parentSubmission: parentSubmission)
                    }
                }
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
