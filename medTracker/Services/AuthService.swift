//
//  AuthService.swift
//  medTracker
//
//  Created by Alumno on 18/11/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

/**********************
 This class contains helper functions to authenticate the user (the log in view and register a new user)
 **********************************/
@MainActor
class AuthService: ObservableObject {
    @Published var isAuthenticated = false
    
    let auth = Auth.auth()
    private var listener: AuthStateDidChangeListenerHandle?
    
    /**********************
     Important initialization methods
     **********************************/
    init() {
        listener = auth.addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
        }
    }
    
    /**********************
     Helper functions
     **********************************/
    
    // Function to create an account based on a name, email, and password.
    func createAccount(name: String, email: String, password: String, role: String) async throws {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            try await result.user.updateProfile(\.displayName, to: name)
            HelperFunctions.write(email, inPath: "email.JSON")
            // Save the role in Firestore
            let db = Firestore.firestore()
            //try await db.collection("users").document(result.user.uid).setData([
            try await db.collection("Roles").document(email).setData([
                "role": role,
                "id": result.user.uid
            ])
        } catch {
            throw error
        }
        
    }
    
    // Function that tries to sign in.
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    // Function to sign out.
    func signOut() throws {
        try auth.signOut()
    }
}

// Function to update the profile
private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}
