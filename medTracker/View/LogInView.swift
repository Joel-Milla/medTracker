import SwiftUI

struct LogInView: View {
    @EnvironmentObject var authentication: AuthViewModel
    
    var body: some View {
        NavigationStack {
            Form {
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
                
                Button("Sign In", action: {
                    authentication.signIn()
                })
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
            }
            .navigationTitle("Registrar")
        }
    }
}

struct loginView_Previews: PreviewProvider {
    static var temporary = AuthViewModel()
    static var previews: some View {
        LogInView()
    }
}



