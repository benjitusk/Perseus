//
//  UI.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import SwiftUI

/// https://www.wooji-juice.com/blog/stupid-swiftui-tricks-single-axis-geometry-reader.html
struct SingleAxisGeometryReader<Content: View>: View {
    private struct SizeKey: PreferenceKey {
        static var defaultValue: CGFloat { 10 }
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }

    @State private var size: CGFloat = SizeKey.defaultValue

    var axis: Axis = .horizontal
    var alignment: Alignment = .center
    let content: (CGFloat)->Content

    var body: some View {
        content(size)
            .frame(maxWidth:  axis == .horizontal ? .infinity : nil,
                   maxHeight: axis == .vertical   ? .infinity : nil,
                   alignment: alignment)
            .background(GeometryReader {
                proxy in
                Color.clear.preference(key: SizeKey.self, value: axis == .horizontal ? proxy.size.width : proxy.size.height)
            })
            .onPreferenceChange(SizeKey.self) { size = $0 }
    }
}

/// https://stackoverflow.com/a/70948338/13368672
struct EmptyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct NestedPreview: View {
    @State var submission: Submission? = nil
    @State var error: Error? = nil
    var body: some View {
        VStack {
            if let submission = submission {
                SubmissionView(submission)
            } else {
                Text("Loading your submission...")
                ProgressView()
                    .onAppear {
                        Reddit.getRedditThingByID(get: Submission.self, for: "t3_9dlyi3") { result in
                            switch result {
                            case .success(let submission):
                                self.submission = submission
                            case .failure(let error):
                                self.error = error
                            }
                        }
                    }
            }
            if let error = self.error {
                Text(error.localizedDescription)
            }
        }
    }
}

struct BackgroundColor: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        content.background(color)
    }
}
extension View {
    func backgroundColor(_ color: Color) -> some View {
        modifier(BackgroundColor(color: color))
    }
}
