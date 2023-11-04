//
//  profile.swift
//  medTracker
//
//  Created by Alumno on 17/10/23.
//

import SwiftUI

struct profile: View {
    var tipos = ["Masculino", "Femeninio", "Prefiero no decir"]

    @Environment(\.editMode) private var editMode
    
    @State private var user: Usuario =
    Usuario(telefono: "", nombre: "", apellidoPaterno: "", apellidoMaterno: "",
            sexo: "", antecedentes: "", estatura: 0.0)
    @State private var draftUser: Usuario = Usuario(telefono: "", nombre: "", apellidoPaterno: "", apellidoMaterno: "", sexo: "", antecedentes: "", estatura: 0.0)
    @State private var sexo : String = ""
    @State private var estatura : String = ""
    
    @State private var birthDate = Date()
    @State private var date : String = ""
    
    @State private var isEditing = false
    
    let defaults = UserDefaults.standard
    
    var body: some View {
        VStack() {
            NavigationStack {
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
                            DatePicker("Fecha Nacimiento", selection: $birthDate, displayedComponents: .date)
                        } else {
                            Text("Nombre: \(user.nombre)")
                            Text("Apellido Paterno: \(user.apellidoPaterno)")
                            Text("Apellido Materno: \(user.apellidoMaterno)")
                            Text("Telefono: \(user.telefono)")
                            Text("Fecha Nacimiento: \(date)")
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
                    Button(isEditing ? "Done" : "Edit") {
                        if isEditing {
                            // Editar se termino
                            draftUser.estatura = Double(estatura) ?? 0.0
                            draftUser.sexo = sexo
                            user = draftUser
                        } else {
                            // Se empieza a editar
                            draftUser = user
                        }
                        isEditing.toggle()
                    }
                }
                .onChange(of: birthDate) { newValue in
                    date = "\(birthDate.formatted(date: .long, time: .omitted))"
                    
                }
                .onAppear {
                    draftUser = user
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
