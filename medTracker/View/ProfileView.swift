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
    @ObservedObject var user: UserModel
    @EnvironmentObject var authentication: AuthViewModel
    @State private var draftUser: UserModel = UserModel()
    
    @State private var isEditing = false
    
    var sexo = ["Masculino", "Femenino", "Prefiero no decir"]
    @State var estatura = ""
    @State private var selectedSexo = "Masculino" // Default value
    
    @State private var error:Bool = false
    @State private var errorMessage: String = ""
    @State private var keyboardHeight: CGFloat = 33
    
    typealias CreateAction = (User) async throws -> Void
    let createAction: CreateAction
    
    var body: some View {
        ZStack {
            VStack {
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
                                    TextField("Joel Alejandro", text: $draftUser.user.nombre)
                                }
                                HStack {
                                    Text("Apellido Paterno")
                                    TextField("Milla", text: $draftUser.user.apellidoPaterno)}
                                HStack {
                                    Text("Apellido Materno")
                                    TextField("Lopez", text: $draftUser.user.apellidoMaterno)}
                                HStack {
                                    Text("Telefono")
                                    TextField("+81 2611 1857", text: $draftUser.user.telefono)}
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
                                    TextField("1.80", text: $draftUser.user.estatura)
                                        .keyboardType(.decimalPad)
                                }
                                DatePicker("Fecha de Nacimiento",
                                           selection: $draftUser.user.fechaNacimiento,
                                           displayedComponents: .date)
                                
                                Picker("Sexo", selection: $selectedSexo) {
                                    ForEach(sexo, id: \.self) { sexo in
                                        Text(sexo).tag(sexo)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .onAppear {
                                    self.selectedSexo = draftUser.user.sexo
                                }
                                .onChange(of: selectedSexo) { newValue in
                                    draftUser.user.sexo = newValue
                                }
                            } else {
                                Text("Estatura: \(user.user.estatura)")
                                HStack {
                                    Text("Fecha de nacimiento:")
                                    Spacer()
                                    Text(user.user.formattedDateOfBirth)
                                }
                                
                                HStack {
                                    Text("Sexo:")
                                    Spacer()
                                    Text(draftUser.user.sexo)
                                }
                            }
                        } header: {
                            Text("Datos fijos")
                        }
                        
                        Section {
                            if isEditing {
                                Text("Antecedentes:")
                                TextEditor(text: $draftUser.user.formattedAntecedentes)
                            } else {
                                Text("Antecedentes:")
                                ScrollView {
                                    Text(user.user.antecedentes)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                                }
                                .frame(minHeight: 0, maxHeight: 22 * 10)
                            }
                        } header: {
                            Text("Historial Clinico")
                        }
                        Button("Sign Out", action: {
                            authentication.signOut()
                        }).foregroundStyle(Color.red)
                    }
                    .navigationTitle("Profile")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            if isEditing {
                                Button("Cancel") {
                                    // Borrar informacion de draft user
                                    draftUser.user = user.user
                                    isEditing = false
                                }
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if isEditing {
                                Button("Done") {
                                    // Guardar informacion en user y sandbox
                                    let validationResult = draftUser.user.error()
                                    if validationResult.0 {
                                        error = true
                                        errorMessage = validationResult.1
                                    }
                                    else {
                                        user.user = draftUser.user
                                        createUser(user: user.user)
                                        isEditing = false
                                    }
                                }
                            } else {
                                Button("Edit") {
                                    // Modo normal
                                    isEditing = true
                                }
                            }
                        }
                    }
                    .alert(isPresented: $error) {
                        Alert(
                            title: Text("Error"),
                            message: Text(errorMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                Spacer() // Pushes the content up
            }
            .padding(.bottom, keyboardHeight)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        // Modify view of keyboard
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { notification in
                keyboardHeight = 0
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                keyboardHeight = 33
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private func createUser(user: User) {
        // will wait until the createAction(symptom) finishes
        Task {
            do {
                try await
                createAction(user) //call the function that adds the user to the database
            } catch {
                print("[NewPostForm] Cannot create post: \(error)")
            }
        }
    }
}

// To dismiss keyboard on type
extension UIApplication {
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: UserModel(), createAction: { _ in })
    }
}
