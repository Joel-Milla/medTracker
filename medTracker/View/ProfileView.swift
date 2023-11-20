//
//  profile.swift
//  medTracker
//
//  Created by Alumno on 17/10/23.
//

import SwiftUI

/**********************
 This view shows the profile data of the user and allows the user to edit it.
 **********************************/
struct ProfileView: View {
    var tipos = ["Masculino", "Femeninio", "Prefiero no decir"]
    
    @State var user: UserModel
    @State private var draftUser: User = User(telefono: "", nombre: "", apellidoPaterno: "", apellidoMaterno: "", sexo: "", antecedentes: "", estatura: 0.0)
    @State private var sexo : String = ""
    @State private var estatura : String = ""
    
    @State private var isEditing = false
    @EnvironmentObject var authentication: AuthViewModel
    let email = Repository.getEmail()
    
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
                    Button("Sign Out", action: {
                        authentication.signOut()
                    }).foregroundStyle(Color.red)

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
                            Text("Nombre: \(user.user.nombre)")
                            Text("Apellido Paterno: \(user.user.apellidoPaterno)")
                            Text("Apellido Materno: \(user.user.apellidoMaterno)")
                            Text("Telefono: \(user.user.telefono)")
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
                            Text("Estatura: \(String(format: "%.1f", user.user.estatura))")
                            Text("Sexo: \(user.user.sexo)")
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
                            Text("\(user.user.antecedentes)")
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
                                draftUser = user.user
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
                                user.user = draftUser
                                user.saveUser()
                                isEditing = false
                            }
                        } else {
                            Button("Edit") {
                                // Modo normal
                                draftUser = user.user
                                isEditing = true
                            }
                        }
                    }
                }
                .onAppear {
                    //draftUser = user
                }
            }
        }
    }
}


struct profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: UserModel())
    }
}
