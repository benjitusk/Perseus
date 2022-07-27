//
//  Submission.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/25/22.
//

import Foundation
class Submission: Identifiable {
    enum SubmissionType: String, Decodable {
        case link
        case text
        case any
    }
    let title, body, author: String
    let id = UUID()
    init(title: String, body: String, author: String) {
        self.title = title
        self.body = body
        self.author = author
    }
    static var sample = Submission(title: "Test title", body: "Test body", author: "Test author")
}
