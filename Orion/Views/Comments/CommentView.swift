//
//  CommentView.swift
//  orion
//
//  Created by Alberto Delle Donne on 12/08/22.
//

import SwiftUI

struct CommentView: View {
    let comment: Comment
    init(_ comment: Comment) {
        self.comment = comment
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(.sample)
    }
}
