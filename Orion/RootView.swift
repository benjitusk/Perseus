//
//  RootView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import SwiftUI
import CoreData

struct RootView: View {
    @EnvironmentObject var currentUser: CurrentUser
    var body: some View {
        TabView {
            HomeFeedView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            DiscoveryView()
                .tabItem {
                    Label("Discovery", systemImage: "rectangle.3.group")
                }
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
            
        }

        .environmentObject(currentUser)
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(CurrentUser.shared)
    }
}
