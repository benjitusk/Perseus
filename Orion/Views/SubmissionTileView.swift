//
//  SubmissionTileView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/27/22.
//

import SwiftUI

struct SubmissionTileView: View {

    let submission: Submission
    var body: some View {
        VStack {
            
            SingleAxisGeometryReader(axis: .horizontal) { width in
                VStack {
                    HStack {
                        Text(submission.title)
                            .fixedSize(horizontal: false, vertical: true)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    if let preview = submission.preview {
                            AsyncImage(url: URL(string: preview.images.first!.source.url)) { phase in
                                if let image = phase.image {
                                    HStack(alignment: .top) {
                                        withAnimation {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }
                                    }
                                    .frame(maxHeight: 650, alignment: .top)
                                } else if let error = phase.error {
                                    Color.red
                                        .overlay(Text(error.localizedDescription))
                                } else {
                                    Color.blue
                                }
                            }
                    } else {
                        if !submission.selfText.isEmpty {
                            Text(submission.selfText)
                                .padding(.horizontal)
                                .padding(.bottom)
                                .lineLimit(3)
                        }
                    }
                }
            }

            .background(
                Color.white
            )
            .cornerRadius(10)
            .shadow(radius: 10)
            VStack(spacing: 10) {
                HStack {
                    Text("r/**\(submission.subredditName)**")
                    Spacer()
                    Label("\(submission.upVotes)", systemImage: "arrow.up")
                    Label("\(submission.commentCount)", systemImage: "text.bubble")
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.vertical, 5)
            .padding(.horizontal)
            
        }
        .background(
            Color(UIColor.systemBackground)
        )
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding(5)
        
    }
}

struct SubmissionTileView_Previews: PreviewProvider {
    static var previews: some View {
            HomeFeedView()
//        .padding()
    }
}
