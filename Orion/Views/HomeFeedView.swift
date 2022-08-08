//
//  HomeFeedView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/31/22.
//

import SwiftUI

struct HomeFeedView: View {
    var body: some View {
        NavigationView {
            Group {
                SubmissionListView(subreddit: SpecialSubreddit(displayName: "Hot", apiURL: "r/awesome"))
            }
            .navigationTitle("Hot")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct HomeFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
    }
}
