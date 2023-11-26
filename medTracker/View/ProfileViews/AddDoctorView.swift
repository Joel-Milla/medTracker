//
//  AddDoctorView.swift
//  medTracker
//
//  Created by Alumno on 25/11/23.
//

import SwiftUI

struct AddDoctorView: View {
    @ObservedObject var user: UserModel
    @State var email: String = ""
    @State var emailFound = false
    @State var progress: StateRequest = .complete
    @Environment(\.dismiss) var dismiss
    
    @State var existError = false
    @State var errorMessage = ""
    
    enum StateRequest {
        case loading
        case complete
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Agregar Doctor")) {
                        TextField("Email de doctor", text: $email)
                            .textContentType(.emailAddress)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary.opacity(0.15))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("mainBlue"), lineWidth: 1)
                            )
                        
                        Button(action: {
                            if email != "" {
                                Task {
                                    await addDoctorIfRoleMatches()
                                }
                            } else {
                                existError = true
                                errorMessage = "Por favor ingresa un email valido."
                            }
                        }, label: {
                            if progress == .complete {
                                Text("Compartir información")
                            } else {
                                ProgressView()
                            }
                        })
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color("mainBlue"), Color("blueGreen")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                    
                    Section(header: Text("Doctores Registrados")) {
                        if user.user.arregloDoctor.isEmpty {
                            HStack {
                                Spacer()
                                EmptyListView(
                                    title: "No hay doctores registrados",
                                    message: "Por favor agrega doctores para compartir los datos.",
                                    nameButton: "Nothing"
                                )
                                Spacer()
                            }
                        } else {
                            ForEach(user.user.arregloDoctor, id: \.self) { email in
                                Text(email)
                                    .font(.body)
                                    .padding(8)
                            }
                        }
                    }
                }
                //Spacer()
            }
            .alert(isPresented: $existError) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func addDoctorIfRoleMatches() async {
        self.progress = .loading
        let lowercaseEmail = email.lowercased() // Convert email to lowercase
        do {
            let doctorRole = try await HelperFunctions.fetchUserRole(email: lowercaseEmail)
            if doctorRole == "Doctor" {
                DispatchQueue.main.async {
                    user.user.arregloDoctor.append(email)
                    user.saveUserData()
                    email = ""
                    self.progress = .complete
                }
            } else {
                self.progress = .complete
                existError = true
                errorMessage = "No se encontro el email como valido."
            }
        } catch {
            // Handle any errors
            print(error.localizedDescription)
            self.progress = .complete
            existError = true
            errorMessage = "No se encontro el email como valido."
        }
    }
}

struct AddDoctorView_Previews: PreviewProvider {
    static var previews: some View {
        AddDoctorView(user: UserModel())
    }
}
