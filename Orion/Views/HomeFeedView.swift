//
//  HomeFeedView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/31/22.
//

import SwiftUI

struct HomeFeedView: View {
    @State var searchText : String = "awesome"
    @State private var SortingMethod = 1
    var sections = ["Popular", "Home", "All"]
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.05).ignoresSafeArea()
                ScrollView {
                    LazyVStack {
                        Picker(selection: $SortingMethod,label: Text("Sections")) {
                            ForEach(0 ..< sections.count) {
                                Text(self.sections[$0])
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                            .padding(.top, 4)
                        Group {
                            if SortingMethod == 0 {
                                SubmissionListView(subreddit: SpecialSubreddit(displayName: "Hot", apiURL: "r/Popular"))
                            } else if SortingMethod == 1 {
                                SubmissionListView(subreddit: SpecialSubreddit(displayName: "Hot", apiURL: "r/awesome"))
                            } else if SortingMethod == 2 {
                                SubmissionListView(subreddit: SpecialSubreddit(displayName: "Hot", apiURL: "r/All"))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Hot")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarTitleMenu {
                    Text("Sort By:")
                    Button {} label: {
                        Label("Best", systemImage: "trophy")
                    }
                    Button {} label: {
                        Label("Hot", systemImage: "flame")
                    }
                    Button {} label: {
                        Label("Top", systemImage: "star")
                    }
                    Button {} label: {
                        Label("New", systemImage: "clock")
                    }
                }
            }
        }
        
    }
}

struct HomeFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
    }
}
