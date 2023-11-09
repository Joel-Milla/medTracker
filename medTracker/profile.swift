//
//  profile.swift
//  medTracker
//
//  Created by Alumno on 17/10/23.
//

import SwiftUI

struct profile: View {
    var tipos = ["Masculino", "Femeninio", "Prefiero no decir"]
    
    @State private var user: Usuario = Usuario(telefono: "", nombre: "", apellidoPaterno: "", apellidoMaterno: "", sexo: "", antecedentes: "", estatura: 0.0)
    @State private var draftUser: Usuario = Usuario(telefono: "", nombre: "", apellidoPaterno: "", apellidoMaterno: "", sexo: "", antecedentes: "", estatura: 0.0)
    @State private var sexo : String = ""
    @State private var estatura : String = ""
    
    @State private var isEditing = false
    
    let defaults = UserDefaults.standard
    
    var body: some View {
        VStack() {
            NavigationStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                    .clipped()
                Form {
                    Section {
                        if isEditing {
                            HStack {
                                Text("Nombre(s)")
                                TextField("Joel Alejandro", text: $draftUser.nombre)
                            }
                            HStack {
                                Text("Apellido Paterno")
                                TextField("Milla", text: $draftUser.apellidoPaterno)}
                            HStack {
                                Text("Apellido Materno")
                                TextField("Lopez", text: $draftUser.apellidoMaterno)}
                            HStack {
                                Text("Telefono")
                                TextField("+81 2611 1857", text: $draftUser.telefono)}
                        } else {
                            Text("Nombre: \(user.nombre)")
                            Text("Apellido Paterno: \(user.apellidoPaterno)")
                            Text("Apellido Materno: \(user.apellidoMaterno)")
                            Text("Telefono: \(user.telefono)")
                        }
                    } header: {
                        Text("Datos personales")
                    }
                    
                    Section {
                        if isEditing {
                            HStack {
                                Text("Estatura")
                                TextField("1.80", text: $estatura)
                                    .keyboardType(.decimalPad)
                            }
                            Picker(selection: $sexo) {
                                ForEach(tipos, id: \.self) { tipo in
                                    Text(tipo)
                                }
                            } label: {
                                Text("Sexo")
                            }
                            
                        } else {
                            Text("Estatura: \(String(format: "%.1f", user.estatura))")
                            Text("Sexo: \(user.sexo)")
                        }
                    } header: {
                        Text("Datos fijos")
                    }
                    
                    Section {
                        if isEditing {
                            Text("Antecedentes:")
                            TextEditor(text: $draftUser.antecedentes)
                        } else {
                            Text("Antecedentes:")
                            Text("\(user.antecedentes)")
                                .lineLimit(10)
                        }
                    } header: {
                        Text("Historial Clinico")
                    }
                }
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if isEditing {
                            Button("Cancel") {
                                // Borrar informacion de draft user
                                draftUser = user
                                isEditing = false
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if isEditing {
                            Button("Done") {
                                // Guardar informacion en user y sandbox
                                draftUser.estatura = Double(estatura) ?? 0.0
                                draftUser.sexo = sexo
                                user = draftUser
                                saveUser()
                                isEditing = false
                            }
                        } else {
                            Button("Edit") {
                                // Modo normal
                                draftUser = user
                                isEditing = true
                            }
                        }
                    }
                }
                .onAppear {
                    draftUser = user
                }
                .onAppear {
                    loadUser()
                }
            }
        }
    }
    
    /* Guardar informacion y obtenerla */
    func saveUser() {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "savedUser")
        }
    }
    
    func loadUser() {
        if let savedUserData = UserDefaults.standard.object(forKey: "savedUser") as? Data {
            if let loadedUser = try? JSONDecoder().decode(Usuario.self, from: savedUserData) {
                user = loadedUser
            }
        }
    }
    
}


struct profile_Previews: PreviewProvider {
    static var previews: some View {
        profile()
    }
}
