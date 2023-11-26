//
//  Patient.swift
//  medTracker
//
//  Created by Alumno on 25/11/23.
//

import Foundation

struct Patient : Codable, Hashable {
    var email : String
    var name : String
    
    init(email: String, nombre: String) {
        self.email = email
        self.name = nombre
    }
}
