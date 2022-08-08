//
//  RedditToken.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import Foundation
struct RedditToken: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiry = "expires_in"
        case refreshToken = "refresh_token"
    }
    let accessToken: String
    let tokenType: String
    var expiry: Int
    let refreshToken: String
}
