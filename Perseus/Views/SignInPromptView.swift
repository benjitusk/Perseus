//
//  SignInPromptView.swift
//  perseus
//
//  Created by Benji Tusk on 8/9/22.
//

import SwiftUI

struct SignInPromptView: View {
    @EnvironmentObject var currentUser: CurrentUser
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 175))
                .padding()
            Text("Many features require to be signed in.")
                .font(.headline)
            Text("To continue with this action, please sign in with your reddit account.")
            Spacer()
            Button(action: currentUser.signInPrompt) {
                Text("Log in with Reddit")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .padding(.horizontal)
                    .padding(.horizontal)
                    .backgroundColor(.accentColor)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct SignInPromptView_Previews: PreviewProvider {
    static var previews: some View {
        SignInPromptView()
            .environmentObject(CurrentUser.shared)
    }
}
