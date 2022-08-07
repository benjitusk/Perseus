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
            VStack(spacing: 10) {
                HStack {
                    Text("r/**\(submission.subredditName)**")
                    Spacer()
                    Label("\(submission.upVotes)", systemImage: "arrow.up")
                }
                HStack {
                    Text("u/**\(submission.author.username)**")
                    Spacer()
                    Label("\(submission.commentCount)", systemImage: "text.bubble")
                }

            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.top)
            .padding(.horizontal)
            
            SingleAxisGeometryReader(axis: .horizontal) { width in
                VStack {
                    HStack {
                        Text(.init(submission.title))
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
            
        }
        .background(
            Color(UIColor.systemBackground)
        )
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding(5)
        
    }
}

struct SubmissionView_Previews: PreviewProvider {
    static var previews: some View {
            HomeFeedView()
//        .padding()
    }
}
