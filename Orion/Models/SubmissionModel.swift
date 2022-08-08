//
//  SubmissionModel.swift
//  infrareddit
//
//  Created by Benji Tusk on 8/7/22.
//

import Foundation
class SubmissionModel: ObservableObject {
    let submission: Submission
    init(_ submission: Submission) {
        self.submission = submission
    }
}
