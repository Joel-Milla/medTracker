import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var authentication: AuthViewModel.CreateAccountViewModel
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre", text: $authentication.name)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                Group {
                    TextField("Email", text: $authentication.email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    SecureField("Contraseña", text: $authentication.password)
                        .textContentType(.newPassword)
                }
                .padding()
                .background(Color.secondary.opacity(0.15))
                .cornerRadius(10)
                Button(action: {
                    AuthService.writeEmail(authentication.email)
                    authentication.submit()
                }, label: {
                    switch authentication.state {
                    case .idle:
                        Text("Crear Cuenta")
                    case .isLoading:
                        ProgressView()
                    }
                })
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
            }
            .onSubmit(authentication.submit)
            // The alert and onReceive check when there is a registrationError and show it.
            .onReceive(authViewModel.$registrationErrorMessage) { errorMessage in
                if errorMessage != nil {
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Registration Error"),
                    message: Text(authViewModel.registrationErrorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationTitle("Registrarse")
            
        }
    }
}

struct registroUsuario_Previews: PreviewProvider {
    static var viewModels = AuthViewModel()
    static var previews: some View {
        RegisterView(authentication: viewModels.makeCreateAccountViewModel())
    }
}

