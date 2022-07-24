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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
