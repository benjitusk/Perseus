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
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(model.submission.title)
                        .multilineTextAlignment(.leading)
                        .font(.title)
                        .bold()
                }
                .padding()
                VStack(alignment: .leading) {
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
                            } else if let text =  model.submission.selfText{
                                Markdown(text)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Posted by **\(model.submission.author.username)** in **\(model.submission.subredditName)**")
                        HStack {
                            Image(systemName: "arrow.up")
                            Text("\(model.submission.upVotes)")
                            Image(systemName: "clock")
                            Text(model.submission.createdAt.timeAgoDisplay())
                        }
                    }.padding(.horizontal)
                        .padding(.top)
                        .foregroundColor(.gray)
                    HStack {
                        VoteButtonView(submission: $model.submission, isUp: true)
                        VoteButtonView(submission: $model.submission, isUp: false)
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.gray)
                }
            }
            Divider()
            
            CommentTreeView(of: model.submission)
            
        }
        .navigationTitle("r/\(model.submission.subredditName)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SubmissionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NestedPreview()
        }
    }
    
}
