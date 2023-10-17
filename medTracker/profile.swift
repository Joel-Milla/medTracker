//
//  profile.swift
//  medTracker
//
//  Created by Alumno on 17/10/23.
//

import SwiftUI

struct profile: View {
    @State var fechaNac = Date()
    @State var dummy : String = ""
    @State var mostrar : Bool = false

    var body: some View {
        VStack {
            NavigationStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
                    .padding()
                Form {
                    Section {
                        HStack {
                            Text("Nombre: ")
                            TextField("nombre", text: $dummy)
                                .textFieldStyle(.roundedBorder)
                        }
                        Text("Apellido Paterno: ")
                        Text("Apellido Materno: ")
                        DatePicker("Fecha Nacimiento", selection: $fechaNac, displayedComponents: .date)
                        
                    } header: {
                        Text("Datos personales")
                    }
                    
                    Section {
                        HStack {
                            Text("Estatura: ")
                        }
                        Text("Sexo: ")
                    } header: {
                        Text("Datos fijos")
                    }
                    
                    Section {
                        HStack {
                            Text("Antecedentes: ")
                            
                        }
                    } header: {
                        Text("Datos variables")
                    }
                }
                .navigationTitle("Profile")
                .toolbar{
                    Button {
                        mostrar = true
                    } label: {
                        Text("Edit")
                    }
                }
            }
        }
    }
}

struct profile_Previews: PreviewProvider {
    static var previews: some View {
        profile()
    }
}
