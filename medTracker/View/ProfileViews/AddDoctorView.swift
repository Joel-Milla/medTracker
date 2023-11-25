//
//  AddDoctorView.swift
//  medTracker
//
//  Created by Alumno on 25/11/23.
//

import SwiftUI

struct AddDoctorView: View {
    @ObservedObject var user: UserModel
    @State var email = ""

    var body: some View {
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
            
            Button(action: {}, label: {
                // The switch check the status of the request and shows a loading animation if it is waiting a response from firebase.
                    Text("Compartir informacion")
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
            
            if user.user.arregloDoctor.isEmpty {
                EmptyListView(
                    title: "No hay doctores registrados",
                    message: "Porfavor de agregar doctores para compartir los datos.",
                    nameButton: "Agregar Sintoma"
                )
            }
        }
    }
}

struct AddDoctorView_Previews: PreviewProvider {
    static var previews: some View {
        AddDoctorView(user: UserModel())
    }
}
