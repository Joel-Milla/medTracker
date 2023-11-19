import SwiftUI

struct RegisterView: View {
    @StateObject var authentication: AuthViewModel.CreateAccountViewModel

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
                Button("Crear Cuenta", action: authentication.submit)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .navigationTitle("Registrar")
            .onSubmit(authentication.submit)
        }
    }
}

struct registroUsuario_Previews: PreviewProvider {
    static var viewModels = AuthViewModel()
    static var previews: some View {
        RegisterView(authentication: viewModels.makeCreateAccountViewModel())
    }
}

