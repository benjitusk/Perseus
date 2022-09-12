//
//  CommentView.swift
//  perseus
//
//  Created by Alberto Delle Donne on 12/08/22.
//

import SwiftUI

struct CommentView: View {
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
                VStack(alignment: .trailing, spacing: 7) {
                    VStack(alignment: .leading) {
                        HStack(spacing: 3) {
                            if comment.authorIsOP {
                                Image(systemName: "crown")
                                    .foregroundColor(.accentColor)
                            } else if comment.distinguished == .moderator {
                                Image(systemName: "shield.lefthalf.filled")
                                    .foregroundColor(.green)
                            } else if comment.distinguished == .admin {
                                Image(systemName: "checkerboard.shield")
                                    .foregroundColor(.red)
                            }
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
                                    .padding(4)
                                    .foregroundColor(.gray)
                            }
                        }.lineLimit(1)
                        if !isCollapsed {
                            Text(comment.body.toAttributedMarkdownString)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            if let replies = comment.replyListing {
                                Text("\(replies.children.count + 1) comment\(replies.children.count + 1 != 1 ? "s":"") collapsed.")
                                    .italic()
                                    .foregroundColor(.gray)
                            } else {
                                Text("1 comment collapsed.")
                                    .italic()
                                    .foregroundColor(.gray)
                            }
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
            }.padding(.vertical)
        }
        .padding(.trailing)
        .backgroundColor(.init(uiColor: .systemBackground))
        .contextMenu {
            Button {
                withAnimation {
                    isCollapsed.toggle()
                }
            } label: {
                if isCollapsed {
                    Label("Expand", systemImage: "mount")
                } else {
                    Label("Collapse", systemImage: "eject")
                }
            }
            Button {} label: {
                Label("Upvote", systemImage: "arrow.up")
            }
            Button {} label: {
                Label("Downvote", systemImage: "arrow.down")
            }
            Button {} label: {
                Label("u/\(comment.author.username)", systemImage: "person.crop.circle")
            }
            Button {} label: {
                Label("Block \(comment.author.username)", systemImage: "nosign")
            }
            Button {} label: {
                Label("Report", systemImage: "bell")
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTree_Previews.previews
    }
}
