//
//  Author.swift
//  perseus
//
//  Created by Benji Tusk on 8/7/22.
//

import Foundation
class Author {
    let username: String
    let id: String
    let isBlocked: Bool
    let patreonFlair: Bool
    let hasPremium: Bool
    
    init(username: String, id: String, isBlocked: Bool, patreonFlair: Bool, hasPremium: Bool) {
        self.username = username
        self.id = id
        self.isBlocked = isBlocked
        self.patreonFlair = patreonFlair
        self.hasPremium = hasPremium
    }
    
    static var deletedUser = Author(username: "[deleted]", id: "", isBlocked: false, patreonFlair: false, hasPremium: false)
    static var sample = Author(username: "spez", id: "t2_1w72", isBlocked: false, patreonFlair: false, hasPremium: true)
}
