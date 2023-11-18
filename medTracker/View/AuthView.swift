//
//  AuthView.swift
//  medTracker
//
//  Created by Alumno on 17/11/23.
//

import SwiftUI

struct AuthView: View {
    @StateObject var authentication = AuthViewModel()

    var body: some View {
        if authentication.isAuthenticated {
            MainView(authentication: authentication)
        } else {
            WelcomeView(authentication: authentication)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
