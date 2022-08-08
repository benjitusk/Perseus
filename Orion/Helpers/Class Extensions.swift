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

extension Data {
    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding:.utf8) else { return nil }

        return prettyPrintedString
    }
}

extension Date {
    /// [From StackOverflow](https://stackoverflow.com/a/44087489/13368672)
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
