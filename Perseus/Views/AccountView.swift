//
//  AccountView.swift
//  perseus
//
//  Created by Benji Tusk on 7/31/22.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var currentUser: CurrentUser
    var body: some View {
        VStack {
            if let account = currentUser.userAccount {
                Text(account.username)
                    .font(.largeTitle)
                Button(action: currentUser.signOut ) {
                    Text("Sign out")
                        .foregroundColor(.white)
                        .padding()
                        .backgroundColor(.blue)
                        .cornerRadius(8)
                    
                }
            } else {
                SignInPromptView()
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(CurrentUser.shared)
    }
}
