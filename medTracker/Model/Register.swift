//
//  Registrar.swift
//  medTracker
//
//  Created by Alumno on 08/11/23.
//

import Foundation

struct Register : Codable, Hashable {
    var idSituacion : Int
    var telefono : String
    var fecha : Date
    var cantidad : Float
    var notas : String
    
    init(idSituacion: Int, telefono: String, fecha: Date, cantidad: Float, notas: String) {
        self.idSituacion = idSituacion
        self.telefono = telefono
        self.fecha = fecha
        self.cantidad = cantidad
        self.notas = notas
    }
}
