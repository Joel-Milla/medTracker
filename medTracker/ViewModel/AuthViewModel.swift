//
//  AuthViewModel.swift
//  medTracker
//
//  Created by Alumno on 18/11/23.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = "" {
        didSet {
            escribirJSON(email, path: "email.JSON")
        }
    }
    @Published var password = ""

    @Published var isAuthenticated = false

    @Published var signInErrorMessage: String?
    @Published var registrationErrorMessage: String?
    
    private let authService = AuthService()
    
    func rutaArchivos(_ path: String) -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent(path)
        return pathArchivo
    }
    
    func escribirJSON(_ value: String, path: String) {
        if let codificado = try? JSONEncoder().encode(value) {
            try? codificado.write(to: rutaArchivos(path))
        }
    }

    init() {
        authService.$isAuthenticated.assign(to: &$isAuthenticated)
    }
    
    func signIn() {
        Task {
            do {
                try await authService.signIn(email: email, password: password)
            } catch {
                signInErrorMessage = error.localizedDescription
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try authService.signOut()
                email = ""
                password = ""
                signInErrorMessage = nil
                registrationErrorMessage = nil
                let eliminar = ["email.JSON", "Registers.JSON", "Symptoms.JSON"]
                for path in eliminar {
                    escribirJSON("", path: path)
                }

            } catch {
                signInErrorMessage = error.localizedDescription
            }
        }
    }
    
    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(action: authService.signIn(email:password:))
    }

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
