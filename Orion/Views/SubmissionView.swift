//
//  SubmissionView.swift
//  infrareddit
//
//  Created by Benji Tusk on 8/7/22.
//

import SwiftUI
import MarkdownUI

struct SubmissionView: View {
    @State var model: SubmissionModel
    init(_ submission: Submission) {
        self.model = SubmissionModel(submission)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Text("r/\(model.submission.subredditName)")
                        Text(" • ")
                        Text(model.submission.createdAt.timeAgoDisplay())
//                        Text(" • ")
//                        Text("u/\(model.submission.author.username)")
                        Spacer()
                    }
                    .foregroundColor(.gray)
                    Text(model.submission.title)
                        .multilineTextAlignment(.leading)
                        .font(.title)
                        .bold()
                }
                .padding()
                VStack {
                    SingleAxisGeometryReader(axis: .horizontal) { width in
                        VStack {
                            if let preview = model.submission.preview {
                                AsyncImage(url: URL(string: preview.images[0].source.url)) { phase in
                                    if let image = phase.image {
                                        HStack(alignment: .top) {
                                            withAnimation {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            }
                                        }
                                    } else if let error = phase.error {
                                        Color.red
                                            .overlay(Text(error.localizedDescription))
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .frame(maxHeight: 500, alignment: .center)
                                .clipped()
                            }else if let text =  model.submission.selfText{
                                Markdown(Document(text))
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    HStack {
                        VoteButtonView(submission: $model.submission, isUp: true)
                        VoteButtonView(submission: $model.submission, isUp: false)
                        Spacer()
                    }
                    .padding()
                }
                .background(
                    Color.white
                        .shadow(radius: 10)
                )
            }
            .background(
                Color.white
                    .cornerRadius(7)
                    .shadow(radius: 10)
            )
            
        }
    }
}

struct SubmissionView_Previews: PreviewProvider {
    static var previews: some View {
        NestedPreview()
    }
    
}
