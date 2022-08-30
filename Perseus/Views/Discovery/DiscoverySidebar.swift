//
//  DiscoverySidebar.swift
//  perseus
//
//  Created by Alberto Delle Donne on 15/08/22.
//

import SwiftUI

enum Panel: Hashable {
    /// The value for the ``DiscoveryView``.
    case discovery
}

struct DiscoverySidebar: View {
    @Binding var selection: Panel?
    var body: some View {
        NavigationStack {
            List(selection: $selection) {
                NavigationLink(value: Panel.discovery) {
                    Label("Discovery", systemImage: "rectangle.3.group")
                }
                
                
                
            }.navigationTitle("Subreddits")
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    struct Preview: View {
        @State private var selection: Panel? = Panel.discovery
        var body: some View {
            DiscoverySidebar(selection: $selection)
        }
    }
    
    static var previews: some View {
        NavigationSplitView {
            Preview()
        } detail: {
           Text("Detail!")
        }
    }
}
