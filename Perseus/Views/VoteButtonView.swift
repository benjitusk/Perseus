//
//  VoteButtonView.swift
//  perseus
//
//  Created by Benji Tusk on 8/8/22.
//

import SwiftUI

struct VoteButtonView: View {
    @Binding var submission: Submission
    let isUp: Bool
    var body: some View {
        Button(action: {}) {
            if submission.voteStatus ?? false {
                Rectangle()
                    .fill(isUp ? Color.orange : Color.blue)
                    .overlay(
                        Image(systemName: isUp ? "arrow.up" : "arrow.down")
                            .foregroundColor(.white)
                    )
                    .frame(width: 38, height: 38)
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isUp ? Color.orange : Color.blue, lineWidth: 2)
                    .overlay(
                        Image(systemName: isUp ? "arrow.up" : "arrow.down")
                            .foregroundColor(isUp ? Color.orange : Color.blue)
                    )
                    .frame(width: 38, height: 38)
            }
        }
    }
}

struct VoteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NestedPreview()
    }
}
