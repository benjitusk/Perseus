//
//  SubmissionView.swift
//  infrareddit
//
//  Created by Benji Tusk on 8/7/22.
//

import SwiftUI

struct SubmissionView: View {
    @StateObject var model: SubmissionModel
    init(_: Submission) {
        
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SubmissionView_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionView(.sample)
    }
}
