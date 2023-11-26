//
//  MainDoctorView.swift
//  medTracker
//
//  Created by Alumno on 25/11/23.
//

import SwiftUI
import FirebaseAuth

/*
 Button {
 authentication.signOut()
 } label: {
 Text("Sign Out")
 .foregroundColor(Color.red)
 }
 */
struct MainDoctorView: View {
    @EnvironmentObject var authentication: AuthViewModel
    @StateObject var user = UserModel()
    @StateObject var listaPacientes = PatientList()
    
    var body: some View {
        NavigationStack {
            VStack {
                switch listaPacientes.state {
                case .isLoading:
                    ProgressView() //Loading animation
                case .isEmpty:
                    //Calls a view to show that the list is empty
                    EmptyListView(
                        title: "No hay pacientes registrados",
                        message: "Porfavor de pedirle a los usuarios de compartir su informacion.",
                        nameButton: "Agregar Sintoma"
                    )
                case .complete:
                    List {
                        ForEach(listaPacientes.patients , id: \.self) { patient in
                            NavigationLink {
                                AnalysisDoctorView(patient: patient)
                            } label: {
                                rowPatient(patient: patient)
                            }

                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        /*Button("Sign Out"){
                            authentication.signOut()
                        }
                        .foregroundColor(Color.red)*/
                        DoctorProfileView(user: user, createAction: user.makeCreateAction())
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                    
                }
            }
        }
    }
}

struct MainDoctorView_Previews: PreviewProvider {
    static var previews: some View {
        MainDoctorView()
    }
}
