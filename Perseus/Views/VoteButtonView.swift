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
                Image(systemName: "arrowshape.left")
                    .rotationEffect(Angle(degrees: isUp ? 90 : 270))
            } else {
                Image(systemName: "arrowshape.left")
                    .rotationEffect(Angle(degrees: isUp ? 90 : 270))
            }
        }.font(.title2)
    }
}

struct VoteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NestedPreview()
    }
}
