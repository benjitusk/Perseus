//
//  infraredditApp.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import SwiftUI

@main
struct infraredditApp: App {
    let persistenceController = PersistenceController.shared
    @ObservedObject var currentUser = CurrentUser()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(currentUser)
                .onOpenURL() { url in
                    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                        print("Could not disassemble the url")
                        return
                    }
                    switch components.host {
                    case "token":
                        guard let state = url["state"],
                              let code = url["code"]
                        else {
                            print("Suspected token auth, but no state and code found.")
                            return
                        }
                        currentUser.requestOAuth2Token(authCode: code, state: state)
                        break
                    case nil:
                        print("No URL path defined")
                    default:
                        print("Unknown URL path: \(components.host!)")
                        
                    }
                    
                }
        }
    }
}
