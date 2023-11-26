//
//  Patient.swift
//  medTracker
//
//  Created by Alumno on 25/11/23.
//

import Foundation

struct Patient : Codable, Hashable {
    var email : String
    var nombre : String
    
    init(email: String, nombre: String) {
        self.email = email
        self.nombre = nombre
    }
}
