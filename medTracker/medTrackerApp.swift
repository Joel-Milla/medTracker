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
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
