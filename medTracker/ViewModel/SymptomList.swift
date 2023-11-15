//
//  SymptomList.swift
//  medTracker
//
//  Created by Alumno on 10/11/23.
//

import Foundation

class SymptomList : ObservableObject {
    @Published var symptoms = [Symptom]()
    
    init() {
        symptoms.append(Symptom(id: 1, nombre: "Peso", description: "Este es un ejemplo de descripción que es bastante largo y se va haciendo mucho más largo para comprobar la funcionalidad.", cuantitativo: true, unidades: "kg", activo: true, color: ""))
        symptoms.append(Symptom(id: 2, nombre: "Cansancio", description: "Este es un ejemplo de descripción corto.", cuantitativo: false, unidades: "", activo: false, color: ""))
        symptoms.append(Symptom(id: 3, nombre: "Insomnio", description: "Este es un ejemplo de descripción mediano, es decir, con esto está bien.", cuantitativo: true, unidades: "", activo: false, color: ""))
        symptoms.append(Symptom(id: 4, nombre: "Estado cardíaco", description: "Latidos por minuto.", cuantitativo: true, unidades: "BPM", activo: false, color: ""))
    }
}

/*
 Symptom(id: 1, nombre: "Peso", description: "Este es un ejemplo de descripción que es bastante largo y se va haciendo mucho más largo para comprobar la funcionalidad.", cuantitativo: true, unidades: "kg", activo: true, color: ""),
 Symptom(id: 2, nombre: "Cansancio", description: "Este es un ejemplo de descripción corto.", cuantitativo: false, unidades: "", activo: false, color: ""),
 Symptom(id: 3, nombre: "Insomnio", description: "Este es un ejemplo de descripción mediano, es decir, con esto está bien.", cuantitativo: true, unidades: "", activo: false, color: ""),
 Symptom(id: 4, nombre: "Estado cardíaco", description: "Latidos por minuto.", cuantitativo: true, unidades: "BPM", activo: false, color: "")
 */
