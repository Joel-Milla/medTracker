//
//  inicioSesion.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct inicioSesion: View {
    @State var telefono = 0
    @State var contrasena = ""
    
    var body: some View {
        VStack {
            Text("MedTracker")
                .font(.largeTitle)
                .padding()
            Text("Registro")
                .font(.largeTitle)
            Form{
                Section{
                    HStack{
                        Text("Telefono:")
                        TextField("", value: $telefono, format: .number)
                    }
                    HStack{
                        Text("Contraseña:")
                        SecureField("", text: $contrasena)
                    }
                } header:{
                Text("Ingresa tus datos:")
            }
            }
            
        }
    }
}

struct inicioSesion_Previews: PreviewProvider {
    static var previews: some View {
        inicioSesion()
    }
}
