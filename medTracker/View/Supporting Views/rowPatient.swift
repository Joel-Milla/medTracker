//
//  vistaDetalle.swift
//  medTracker
//
//  Created by Alumno on 25/11/23.
//

//
//  vistaDetalle.swift
//  listaNavigationView
//
//  Created by Alumno on 03/10/23.
//

import SwiftUI

struct rowPatient: View {
    var patient : Patient
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
            VStack(alignment: .leading) {
                Text(patient.name)
                    .font(.title3)
                Text(patient.email)
                    .font(.footnote)
            }
        }
    }
}

struct rowPatient_Previews: PreviewProvider {
    static var previews: some View {
        rowPatient(patient: Patient(email: "Joel", nombre: "yo"))
    }
}

