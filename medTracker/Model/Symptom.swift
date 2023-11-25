//
//  DatosSalud.swift
//  medTracker
//
//  Created by Sebastian Presno Alvarado on 03/11/23.
//

import Foundation

struct Symptom : Codable, Hashable {
    var id : Int
    var nombre : String
    var icon : String
    var description : String
    var cuantitativo : Bool // True = Cuantitativo, False = Cualitativo
    var unidades  : String
    var activo : Bool
    var color : String
    var notificacion : String
    
    init(id: Int, nombre: String, icon: String, description: String, cuantitativo: Bool, unidades: String, activo: Bool, color: String) {
        self.id = id
        self.nombre = nombre
        self.icon = icon
        self.description = description
        self.cuantitativo = cuantitativo
        self.unidades = unidades
        self.activo = activo
        self.color = color
        self.notificacion = ""
    }
    func nameString()->String{
        return self.nombre
    }
}
