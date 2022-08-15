//
//  HomeFeedView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/31/22.
//

import SwiftUI

struct HomeFeedView: View {
    @State var searchText : String = "awesome"
    @State private var selectedSection: Sections = .home
    enum Sections: String {
        case popular, home, all
    }
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.05).ignoresSafeArea()
                ScrollView {
                    LazyVStack {
                        Picker(selection: $selectedSection, label: Text("Sections")) {
                            Text("Popular")
                                .tag(Sections.popular)
                            Text("Home")
                                .tag(Sections.home)
                            Text("All")
                                .tag(Sections.all)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .padding(.top, 4)
                        Group {
                            switch selectedSection {
                            case .popular:
                                SubmissionListView(subreddit: SpecialSubreddit(displayName: "Hot", apiURL: "r/Popular"))
                            case .home:
                                SubmissionListView(subreddit: SpecialSubreddit(displayName: "Hot", apiURL: "r/awesome"))
                            case .all:
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
