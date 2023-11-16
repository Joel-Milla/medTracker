import SwiftUI

struct LogInView: View {
    @State var nombre = ""
    @State var telefono = 0
    @State var contrasena = ""
    @State private var muestraBienvenida = false

    var body: some View {
        NavigationView {
            VStack {
                Text("MedTracker")
                    .font(.largeTitle)
                    .padding()
                Text("Login")
                    .font(.largeTitle)
                Form {
                    Section {
                        HStack {
                            Text("Telefono:")
                            TextField("", value: $telefono, format: .number)
                        }
                        HStack {
                            Text("Contraseña:")
                            SecureField("", text: $contrasena)
                        }
                    } header: {
                        Text("Ingresa tus datos:")
                    }
                }
            }
            .navigationBarItems(leading: NavigationLink(
                            destination: WelcomeView(),
                            label: {
                                Image(systemName: "arrow.left")
                                Text("Regresar")
                            }
                        ))
            
        }
    }
}

struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}


