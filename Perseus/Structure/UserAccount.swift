//
//  UserAccount.swift
//  perseus
//
//  Created by Benji Tusk on 8/9/22.
//

import Foundation
class UserAccount: ObservableObject, Decodable {
    let inboxCount: Int
    let username: String
    let id: String
    let coins: Int
    let karma: Int
    
    enum CodingKeys: String, CodingKey {
        case username = "name"
        case inboxCount = "inbox_count"
        case id
        case coins
        case karma = "total_karma"
    }
}
