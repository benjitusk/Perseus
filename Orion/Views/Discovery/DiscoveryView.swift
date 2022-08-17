//
//  DiscoveryView.swift
//  orion
//
//  Created by Alberto Delle Donne on 15/08/22.
//

import SwiftUI

struct DiscoveryView: View {
    @State var searchText : String = ""
    let horizontalPadding: CGFloat = 10
    @State private var selection: Panel? = Panel.discovery
    var body: some View {
        NavigationSplitView {
            DiscoverySidebar(selection: $selection)
        } detail: {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Browse").font(.title2).fontWeight(.bold)
                        DiscoveryGrid(subreddit: SpecialSubreddit(displayName: "Images", apiURL: "r/Popular"))
                            .padding(.top, -7)
                    }.padding(.horizontal)
                }
                .navigationTitle("Search")
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
        }
    }
}

struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryView()
    }
}
