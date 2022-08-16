//
//  SubmissionTileView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/27/22.
//

import SwiftUI
import MarkdownUI

struct SubmissionTileView: View {
    let submission: Submission
    
    var body: some View {
        VStack {
            SingleAxisGeometryReader(axis: .horizontal) { width in
                VStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 8) {
                            PostRowHeader(submission: submission)
                                .lineLimit(1)
                            Text(submission.title)
                                .fixedSize(horizontal: false, vertical: true)
                                .bold()
                        }
                    if let preview = submission.preview {
                            AsyncImage(url: URL(string: preview.images.first!.source.url)) { phase in
                                if let image = phase.image {
                                    HStack(alignment: .top) {
                                        Button {
                                            
                                        } label: {
                                            withAnimation {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .cornerRadius(9)
                                                    
                                            }
                                        }
                                    }
                                    .frame(maxHeight: 650, alignment: .top)
                                } else if let error = phase.error {
                                    Color.red
                                        .overlay(Text(error.localizedDescription))
                                } else {
                                    ProgressView()
                                        .padding()
                                }
                            }
                    } else if let text = submission.selfText {
                        Markdown(text)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(3)
                    }
                    HStack {
                        HStack {
                            Button(action: {submission.vote(.up)}) {
                                Image(systemName: "chevron.up.circle")
                            }
                            Text("\(submission.upVotes)").fontWeight(.semibold)
                            Button(action: {submission.vote(.down)}) {
                                Image(systemName: "chevron.down.circle")
                            }
                        }
                        .foregroundColor(.primary)
                        .font(.title2)
                        Spacer()
                        HStack(spacing: 15) {
                            Button(action: {}) {
                                HStack(spacing: 3) {
                                    Text("\(submission.commentCount)")
                                    Image(systemName: "bubble.left.and.bubble.right")
                                }
                            }
                            Button(action: {}) {
                                Image(systemName: "bookmark")
                            }
                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                            .foregroundColor(.gray)
                    }
                .padding(.top, 5)
                .padding(.bottom)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 5)
            }
        }
        .background(Color("bk"))
        .cornerRadius(10)
        .padding(9)
    }
}

struct SubmissionTileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeFeedView().preferredColorScheme(.light)
            HomeFeedView().preferredColorScheme(.dark)
        }
//        .padding()
    }
}
