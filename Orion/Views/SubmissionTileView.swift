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
                        VStack(alignment: .leading, spacing: 8) {
                                Text("r/**\(submission.subredditName)** • \(submission.author.username) • \(submission.createdAt.timeAgoDisplay())")
                                            .font(.caption)
                                        .foregroundColor(.gray)
                            Text(submission.title)
                                .fixedSize(horizontal: false, vertical: true)
                            .bold()
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 5)
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
                                                    .padding(5)
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
                    } else {
                        if !submission.selfText.isEmpty {
                            VStack {
                                Text(submission.selfText)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                                .lineLimit(3)
                            }
                        }
                    }
                }
            }

            
            Divider()
            VStack(spacing: 10) {
                HStack {
                    Button {
                    } label: {
                        Label("\(submission.upVotes)", systemImage: "arrow.up")
                    }
                    
                    Button {
                    } label: {
                        Image(systemName: "arrow.down")
                    }
                    Spacer()
                    Label("\(submission.commentCount)", systemImage: "text.bubble")
                       
                    Spacer()
                    Label("Share", systemImage: "square.and.arrow.up")
                        
                }
            }
            .foregroundColor(.gray)
            .padding(.top, 5)
            .padding(.bottom)
            .padding(.horizontal)
            
        }
        .background(Color("bk"))
        .cornerRadius(10)
        .padding(9)
        
        
        
    }
}

struct SubmissionTileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeFeedView().preferredColorScheme(.dark)
            HomeFeedView().preferredColorScheme(.light)
        }
//        .padding()
    }
}
