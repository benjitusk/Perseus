//
//  DiscoveryGrid.swift
//  perseus
//
//  Created by Alberto Delle Donne on 15/08/22.
//

import SwiftUI

struct DiscoveryGrid: View {
    let spacing: CGFloat = 10
    let columns = Array(repeating: GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 10, alignment: .center), count: 2)
    @State var model: SubmissionListModel
    @State var listingModel: ListingModel<Submission>
    init(subreddit: Subreddit) {
        let listingModel = ListingModel<Submission>(apiEndpoint: "r/" + subreddit.displayName)
        self.model = SubmissionListModel(subreddit: subreddit, listingModel: listingModel)
        self.listingModel = listingModel
    }
   
    
    var body: some View {
       
        LazyVGrid(columns: columns, spacing: spacing ) {
            if let submissions = listingModel.children {
                ForEach(submissions) { submission in
                    if let preview = submission.preview {
                        AsyncImage(url: URL(string: preview.images.first!.source.url)) { phase in
                            if let image = phase.image {
                                withAnimation {
                                    image
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(9)
                                        .overlay(alignment: .bottomLeading) {
                                            Text("r\(submission.subredditName)")
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                                .padding(7)
                                        }
                                        
                                }
                                
                            } else {
                                Rectangle()
                                    .cornerRadius(10)
                                    .foregroundColor(.blue)
                                    .frame(width: UIScreen.main.bounds.width * 0.45, height: 300)
                                    .overlay(alignment: .center) {
                                        ProgressView()
                                            .foregroundColor(.white)
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DiscoveryGrid_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryView()
    }
}
