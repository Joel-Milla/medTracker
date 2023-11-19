//
//  medTrackerApp.swift
//  medTracker
//
//  Created by Alumno on 16/10/23.
//

import SwiftUI
import Firebase

@main
struct medTrackerApp: App {
    // Initialize the configuration of the database
    init() {
        FirebaseApp.configure()
    }
    @StateObject var authentication = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authentication.isAuthenticated {
                MainView()
                    .environmentObject(authentication)
            } else {
                WelcomeView()
                    .environmentObject(authentication)
            }
        }
    }
}
