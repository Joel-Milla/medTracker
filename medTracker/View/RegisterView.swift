import SwiftUI

/**********************
 This view submits a request to firebase to create a new user. The view first gets the name, email, and password and then makes the request.
 **********************************/

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
                    authentication.submit() //Submits the request to firebase to create a new user.
                    authViewModel.email = authentication.email // set the email of the current user.
                }, label: {
                    // The switch check the status of the request and shows a loading animation if it is waiting a response from firebase.
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

