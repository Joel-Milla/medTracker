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
    var antecedentes : String
    var sexo: String
    var fechaNacimiento: Date
    var estatura : String
    
    var formattedDateOfBirth: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Set the date format as needed
            return dateFormatter.string(from: fechaNacimiento)
        }
    }
    
    var formattedAntecedentes: String {
        get {
            return self.antecedentes
        }
        set {
            if newValue.count > 1000 {
                self.antecedentes = String(newValue.prefix(1000))
            } else {
                self.antecedentes = newValue
            }
        }
    }
    
    init() {
        self.telefono = ""
        self.nombre = ""
        self.apellidoPaterno = ""
        self.apellidoMaterno = ""
        self.antecedentes = ""
        self.sexo = ""
        self.fechaNacimiento = Date()
        self.estatura = ""
    }
    
    init(telefono: String, nombre: String, apellidoPaterno: String, apellidoMaterno: String, antecedentes: String, sexo: String, fechaNacimiento: Date, estatura: String) {
        self.telefono = telefono
        self.nombre = nombre
        self.apellidoPaterno = apellidoPaterno
        self.apellidoMaterno = apellidoMaterno
        self.antecedentes = antecedentes
        self.sexo = sexo
        self.fechaNacimiento = fechaNacimiento
        self.estatura = estatura
    }
    
    func error() -> (Bool, String) {
        if let height = Double(self.estatura) {
            if (self.telefono == "" || self.nombre == "" || self.apellidoPaterno == "" || self.apellidoMaterno == "" || self.estatura == "" || self.sexo == "") {
                return (true, "Datos faltantes. Por favor llenar todos los campos obligatorios.")
            } else if (height < 0.20 || height > 2.5) {
                return (true, "Estatura invalida. Por favor de poner una estatura valid en unidad centimetros.")
            } else if (self.fechaNacimiento == Date.now || self.fechaNacimiento > Date.now || (getYear(date: Date.now) - getYear(date: self.fechaNacimiento) > 120)) {
                return (true, "Por favor poner una fecha valida.")
            }
        } else {
            return (true, "Estatura invalida. Por favor de poner una estatura valida en unidad metros.")
        }
        return (false, "")
    }
    
    func getYear(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return components.year ?? 0
    }
}
