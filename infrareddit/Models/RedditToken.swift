//
//  RedditToken.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import Foundation
struct RedditToken: Decodable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiry = "expires_in"
        case refreshToken = "refresh_token"
    }
    let accessToken: String
    let tokenType: String
    let expiry: Int
    let refreshToken: String
}
