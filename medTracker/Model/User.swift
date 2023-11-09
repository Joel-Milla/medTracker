//
//  Usuario.swift
//  medTracker
//
//  Created by Alumno on 04/11/23.
//

import Foundation

struct User : Codable {
    var telefono : String // Unique identifier
    var nombre : String
    var apellidoPaterno : String
    var apellidoMaterno : String
    var sexo : String
    var antecedentes : String
    var estatura : Double
}
