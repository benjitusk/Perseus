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
        VStack {
            SubredditView()
            Text("This should be a feed from r/all")
            if !currentUser.isLoggedIn {
                Button(action: currentUser.signInPrompt) {
                    Text("Login")
                }
            } else {
                Text("You're already logged in!")
            }
        }
        .padding()

        .environmentObject(currentUser)
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(CurrentUser.shared)
    }
}
