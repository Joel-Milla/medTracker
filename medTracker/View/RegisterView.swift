import SwiftUI

struct RegisterView: View {
    @State var nombre = ""
    @State var telefono = 0
    @State var estatura = 0.0
    @State var contrasena = ""
    @State var sexo = ""
    @State var aPaterno = ""
    @State var aMaterno = ""
    @State private var muestraBienvenida = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Nombre:")
                            TextField("", text: $nombre)
                        }
                        HStack {
                            Text("Apellido Paterno:")
                            TextField("", text: $aPaterno)
                        }
                        HStack {
                            Text("Apellido Materno:")
                            TextField("", text: $aMaterno)
                        }
                        HStack {
                            Text("Estatura:")
                            TextField("", value: $estatura, format: .number)
                        }
                        HStack {
                            Text("Sexo:")
                            TextField("", text: $sexo)
                        }
                    } header: {
                        Text("datos perosnales")
                    }
                    Section{
                        HStack {
                            Text("Telefono:")
                            TextField("", value: $telefono, format: .number)
                        }
                        HStack {
                            Text("Contraseña:")
                            SecureField("", text: $contrasena)
                        }
                    }header: {
                        Text("Datos de tu cuenta")
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
            .navigationTitle("Registro")
            
        }
    }
}

struct registroUsuario_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

