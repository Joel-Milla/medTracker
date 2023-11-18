//
//  signOut.swift
//  medTracker
//
//  Created by Alumno on 17/11/23.
//

import SwiftUI
import FirebaseAuth

struct signOut: View {
    var body: some View {
        Button("Sign Out", action: {
            try! Auth.auth().signOut()
        })
    }
}

struct signOut_Previews: PreviewProvider {
    static var previews: some View {
        signOut()
    }
}
