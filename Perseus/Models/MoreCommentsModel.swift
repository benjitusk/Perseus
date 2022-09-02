//
//  MoreCommentsModel.swift
//  perseus
//
//  Created by Benji Tusk on 8/29/22.
//

import Foundation
class MoreCommentsModel: ObservableObject {
    let moreComments: MoreComments
    let submissionID: String
    @Published var children: [CommentTreeable]?
    init(_ more: MoreComments, from submissionID: String) {
        self.moreComments = more
        self.submissionID = submissionID
    }
    
    func load() {
        Reddit.getMoreComments(from: submissionID, using: moreComments) { result in
            switch result {
            case .success(let commentsAndMore):
                DispatchQueue.main.async {
                    if self.children == nil {
                        self.children = []
                    }
                    guard !commentsAndMore.isEmpty else { return }
                                        
                    let commentsByParentID = Dictionary(grouping: commentsAndMore, by: {$0.parentID})
                    
                    guard let rootComments = commentsByParentID[self.moreComments.parentID] else {
                        return
                    }
                    
                    func buildCommentTree(_ commentOrMore: CommentTreeable?) {
                        guard let comment = commentOrMore as? Comment else {
                            // If it's a loadMore, it has no children anyways
                            return
                        }
                        
                        guard let commentChildren = commentsByParentID[comment.id] else { return }
                        if comment.replyListing == nil {
                            comment.replyListing = Listing<CommentsAndMore>()
                        }
                        comment.replyListing?.children.append(contentsOf: commentChildren.map{CommentsAndMore(commentOrMore: $0)})
                        for child in commentChildren {
                            buildCommentTree(child)
                        }
                    }

                    // For each TopLevelComment
                    for rootComment in rootComments {
                        buildCommentTree(rootComment)
                    }
                    
                    self.children?.append(contentsOf: rootComments)
                }
            case .failure(let error):
                print("Could not get more comments for comment id \(self.moreComments.fullID) because \(error)")
            }
        }
        
        
    }
}
