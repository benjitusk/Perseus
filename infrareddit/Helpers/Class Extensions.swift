//
//  Class Extensions.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import Foundation
extension URL {
    subscript(queryParam: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}

extension String: LocalizedError {
    /// https://stackoverflow.com/a/40629365/13368672
    public var errorDescription: String? { return self }
}
