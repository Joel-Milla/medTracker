//
//  MainDoctorView.swift
//  medTracker
//
//  Created by Alumno on 25/11/23.
//

import SwiftUI
import FirebaseAuth

struct MainDoctorView: View {
    @EnvironmentObject var authentication: AuthViewModel

    var body: some View {
        Text(Auth.auth().currentUser?.email ?? "no email")
        Button {
            authentication.signOut()
        } label: {
            Text("Sign Out")
                .foregroundColor(Color.red)
        }
    }
}

struct MainDoctorView_Previews: PreviewProvider {
    static var previews: some View {
        MainDoctorView()
    }
}
