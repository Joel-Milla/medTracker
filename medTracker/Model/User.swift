//
//  Usuario.swift
//  medTracker
//
//  Created by Alumno on 04/11/23.
//

import Foundation

struct User : Codable, Hashable {
    var telefono : String // Unique identifier
    var nombre : String
    var apellidoPaterno : String
    var apellidoMaterno : String
    var sexo : String
    var antecedentes : String
    var estatura : Double
    
    init() {
        self.telefono = ""
        self.nombre = ""
        self.apellidoPaterno = ""
        self.apellidoMaterno = ""
        self.sexo = ""
        self.antecedentes = ""
        self.estatura = 0.0
    }
    
    init(telefono: String, nombre: String, apellidoPaterno: String, apellidoMaterno: String, sexo: String, antecedentes: String, estatura: Double) {
        self.telefono = telefono
        self.nombre = nombre
        self.apellidoPaterno = apellidoPaterno
        self.apellidoMaterno = apellidoMaterno
        self.sexo = sexo
        self.antecedentes = antecedentes
        self.estatura = estatura
    }
}
