//
//  RegisterList.swift
//  medTracker
//
//  Created by Alumno on 10/11/23.
//

import Foundation

class RegisterList : ObservableObject {
    @Published var registers = [Register]()
}

/*
 Register(idSymptom: 1, fecha: Date.now, cantidad: 80, notas: "Esto es una nota."),
 Register(idSymptom: 1, fecha: Date.now.addingTimeInterval(86400), cantidad: 80.5, notas: "Esto es una nota."),
 Register(idSymptom: 1, fecha: Date.now.addingTimeInterval(86400*2), cantidad: 80.2, notas: "Esto es una nota."),
 Register(idSymptom: 1, fecha: Date.now.addingTimeInterval(86400*3), cantidad: 79.6, notas: "Esto es una nota."),
 
 Register(idSymptom: 3, fecha: Date.now, cantidad: 80, notas: "Esto es una nota."),
 Register(idSymptom: 3, fecha: Date.now.addingTimeInterval(86400), cantidad: 70, notas: "Esto es una nota."),
 Register(idSymptom: 3, fecha: Date.now.addingTimeInterval(86400*2), cantidad: 30, notas: "Esto es una nota."),
 Register(idSymptom: 3, fecha: Date.now.addingTimeInterval(86400*3), cantidad: 40, notas: "Esto es una nota."),
 */
