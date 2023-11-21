import SwiftUI

/**********************
 This view sends the request to firebase to log in and show any errors as alerts.
 **********************************/
struct LogInView: View {
    @EnvironmentObject var authentication: AuthViewModel
    @State private var showErrorAlert = false
    
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
                
                Button(action: {
                    authentication.signIn() //Makes the request to firebase to check if it is correct.
                }, label: {
                    // The switch check the status of the request and shows a loading animation if it is waiting a response from firebase.
                    switch authentication.state {
                    case .idle:
                        Text("Sign In")
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
            // The alert and onReceive check when there is a signIn error and show it.
            .onReceive(authentication.$signInErrorMessage) { newValue in
                showErrorAlert = newValue != nil
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Password or email are invalid.")
            }
            .navigationTitle("Iniciar Sesión")
        }
    }
}

struct loginView_Previews: PreviewProvider {
    static var temporary = AuthViewModel()
    static var previews: some View {
        LogInView()
    }
}



