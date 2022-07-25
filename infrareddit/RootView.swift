//
//  RootView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/24/22.
//

import SwiftUI
import CoreData

struct RootView: View {
    @State var isPresentingLoginSheet = false
    @EnvironmentObject var currentUser: CurrentUser
    var body: some View {
        VStack {
            Text("Root View")
            Text("This should be a feed from r/all")
            Button(action: {isPresentingLoginSheet = true}) {
                Text("Login")
            }
        }
        .padding()
        .sheet(isPresented: $isPresentingLoginSheet, onDismiss: {}) {
            Button(action: currentUser.signInPrompt) {
                Text("Sign in with Reddit")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(7)
            }
        }
        .environmentObject(currentUser)
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(CurrentUser())
    }
}
