//
//  AccountView.swift
//  infrareddit
//
//  Created by Benji Tusk on 7/31/22.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var currentUser: CurrentUser
    var body: some View {
        if currentUser.isLoggedIn {
            Button(action: currentUser.signOut ) {
                Text("Sign out")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                
            }
        } else {
            Button(action: currentUser.signInPrompt ) {
                Text("Sign in")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
