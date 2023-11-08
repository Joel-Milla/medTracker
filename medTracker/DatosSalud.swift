//
//  DatosSalud.swift
//  medTracker
//
//  Created by Sebastian Presno Alvarado on 03/11/23.
//

import Foundation
import SwiftUI

// struct DatosSalud : Codable, Identifiable {
struct DatosSalud : Hashable, Identifiable {
    var id = UUID()
    var telefono : String
    var nombre : String
    var description : String
    var unidades  : Float
    var activo : Bool
    var color : Color
    
    init(id: UUID = UUID(), telefono: String, nombre: String, description: String, unidades: Float, activo: Bool, color: Color) {
        self.id = id
        self.telefono = telefono
        self.nombre = nombre
        self.description = description
        self.unidades = unidades
        self.activo = activo
        self.color = color
    }
}
