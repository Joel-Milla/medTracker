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
    
    enum StateRequest {
        case loading
        case complete
    }
    
    var body: some View {
        VStack {
            Form {
                Group {
                    TextField("Email de doctor", text: $email)
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                }
                .padding()
                .background(Color.secondary.opacity(0.15))
                .cornerRadius(10)
                
                Button(action: {
                    Task {
                        await addDoctorIfRoleMatches()
                    }
                }, label: {
                    // The switch check the status of the request and shows a loading animation if it is waiting a response from firebase.
                    if progress == .complete {
                        Text("Compartir informacion")
                    } else {
                        ProgressView()
                    }
                })
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                //.frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color("mainBlue"), Color("blueGreen")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            if user.user.arregloDoctor.isEmpty {
                EmptyListView(
                    title: "No hay doctores registrados",
                    message: "Porfavor de agregar doctores para compartir los datos.",
                    nameButton: "Agregar Sintoma"
                )
            } else {
                List {
                    ForEach(user.user.arregloDoctor, id: \.self) { email in
                        Text(email)
                            .font(.title2)
                            .padding(10)
                    }
                }
            }
        }
    }
    
    func addDoctorIfRoleMatches() async {
        self.progress = .loading
        do {
            let doctorRole = try await HelperFunctions.fetchUserRole(email: email)
            if doctorRole == "Doctor" {
                user.user.arregloDoctor.append(email)
                email = ""
                self.progress = .complete
            }
        } catch {
            // Handle any errors
            print(error.localizedDescription)
            self.progress = .complete
        }
    }
}

struct AddDoctorView_Previews: PreviewProvider {
    static var previews: some View {
        AddDoctorView(user: UserModel())
    }
}
