//
//  DoctorProfileView.swift
//  medTracker
//
//  Created by Alumno on 25/11/23.
//


import SwiftUI

/**********************
 This view shows the profile data of the doctor and allows the user to edit it.
 **********************************/
struct DoctorProfileView: View {
    @ObservedObject var user: UserModel
    @EnvironmentObject var authentication: AuthViewModel
    @State private var draftUser: UserModel = UserModel()
    @State private var isEditing = false
    
    var sexo = ["-", "Masculino", "Femenino", "Prefiero no decir"]
    @State var estatura = ""
    @State private var selectedSexo = "Masculino" // Default value
    
    @State private var error: Bool = false
    @State private var errorMessage: String = ""
    
    typealias CreateAction = (User) async throws -> Void
    let createAction: CreateAction
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .overlay(Circle().stroke(Color("mainBlue"), lineWidth: 2))
                Form {
                    Section {
                        if isEditing {
                            HStack {
                                Text("Nombre completo:")
                                Text("Nombre completo: \(user.user.nombreCompleto)")
                            }
                            HStack {
                                Text("Teléfono:")
                                TextField("+81 2611 1857", text: $draftUser.user.telefono)}
                        } else {
                            Text("Nombre completo: \(user.user.nombreCompleto)")
                            Text("Teléfono: \(user.user.telefono)")
                        }
                    } header: {
                        Text("Datos personales")
                    }
                    
                    Section {
                        if isEditing {
                            HStack {
                                Text("Estatura:")
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
                    
                    
                    Button(action: { authentication.signOut() }) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
                .keyboardToolbar()
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
                                    //user.saveUserData()
                                    createUser(user: user.user)
                                    isEditing = false
                                }
                            }
                        } else {
                            Button("Editar") {
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
            .navigationBarBackButtonHidden(isEditing)
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

struct DoctorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorProfileView(user: UserModel(), createAction: { _ in })
    }
}

