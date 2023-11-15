import SwiftUI

struct RegisterView: View {
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
                Text("Registro")
                    .font(.largeTitle)
                Form {
                    Section {
                        HStack {
                            Text("Nombre:")
                            TextField("", text: $nombre)
                        }
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

struct registroUsuario_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

