import SwiftUI

struct LogInView: View {
    @State var telefono = 0
    @State var email = ""
    @State var contrasena = ""
    @State private var muestraBienvenida = false
    @State private var muestraHome = false

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Telefono:")
                            TextField("", value: $telefono, format: .number)
                        }
                        HStack {
                            Text("Correo:")
                            TextField("", text: $email)
                        }
                        HStack {
                            Text("Contraseña:")
                            SecureField("", text: $contrasena)
                        }
                    } header: {
                        Text("Ingresa tus datos:")
                    }
                }
                Button("Iniciar Sesión") {
                    muestraHome = true
                }
                .fullScreenCover(isPresented: $muestraHome, content: {
                    MainView()
                })
                .buttonStyle(Button1MedTracker())
            }
            .navigationTitle("Inicia Sesión")
            
        }
        
    }
}

struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}



