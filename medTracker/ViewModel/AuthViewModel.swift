//
//  AuthViewModel.swift
//  medTracker
//
//  Created by Alumno on 18/11/23.
//

import Foundation

/**********************
 This class contains all the data that  helps to authenticate the user. From sign in to creating a new account.
 **********************************/

@MainActor
class AuthViewModel: ObservableObject {
    /**********************
     Personal data of the user
     **********************************/
    @Published var email = "" {
        didSet {
            //escribirJSON(email, path: "email.JSON")
            HelperFunctions.write(email, inPath: "email.JSON")
        }
    }
    @Published var password = ""
    
    /**********************
     Variables related to firebase
     **********************************/
    private let authService = AuthService()
    @Published var signInErrorMessage: String?
    @Published var registrationErrorMessage: String?
    @Published var state: State = .idle // Variable to know the state of the request of firebase
    
    /**********************
     Extra variables
     **********************************/
    @Published var isAuthenticated = false // to know if the user is authenticated or not
    
    /**********************
     Important initialization method
     **********************************/
    init() {
        // To know the current state of the user.
        authService.$isAuthenticated.assign(to: &$isAuthenticated)
    }
    
    enum State {
        case idle
        case isLoading
    }
    
    /**********************
     Helper functions
     **********************************/
    
    // The function sends a request to firebase to confirm the email and password entered.
    func signIn() {
        Task {
            state = .isLoading
            do {
                try await authService.signIn(email: email, password: password)
            } catch {
                signInErrorMessage = error.localizedDescription
            }
            state = .idle
        }
    }
    
    // Function to sign out and reset all the data
    func signOut() {
        Task {
            do {
                try authService.signOut() // Reset the state of the authService
                
                // The next lines of code delete all the information of the current user
                email = ""
                password = ""
                signInErrorMessage = nil
                registrationErrorMessage = nil
                let eliminar = ["email.JSON", "Registers.JSON", "Symptoms.JSON"]
                for path in eliminar {
                    HelperFunctions.write("", inPath: path)
                }
                
            } catch {
                signInErrorMessage = error.localizedDescription
            }
        }
    }
    
    // returns a closure of a form to sign in
    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(action: authService.signIn(email:password:))
    }
    
    // returns a closure of a form to create an account
    func makeCreateAccountViewModel() -> CreateAccountViewModel {
        let viewModel = CreateAccountViewModel(initialValue: (name: "", email: "", password: ""), action: authService.createAccount)
        viewModel.$error
            .compactMap { $0 }
            .map { $0.localizedDescription }
            .assign(to: &$registrationErrorMessage)
        return viewModel
    }
}

extension AuthViewModel {
    class SignInViewModel: FormViewModel<(email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (email: "", password: ""), action: action)
        }
    }
    
    class CreateAccountViewModel: FormViewModel<(name: String, email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (name: "", email: "", password: ""), action: action)
        }
    }
}
