//
//  SymptomList.swift
//  medTracker
//
//  Created by Alumno on 10/11/23.
//

import Foundation
import SwiftUI

class SymptomList : ObservableObject {
    @Published var symptoms = [Symptom]() {
        didSet {
            if let codificado = try? JSONEncoder().encode(symptoms) {
                try? codificado.write(to: rutaArchivos())
            }
        }
    }
    let repository = Repository()
    func makeCreateAction() -> AddSymptomView.CreateAction {
        return { [weak self] symptom in
            try await self?.repository.createSymptom(symptom)
        }
    }
    
    func fetchPosts() {
        Task {
            do {
                symptoms = try await self.repository.fetchSymptoms()
            } catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
            }
        }
    }
    
    func rutaArchivos() -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent("Symptoms.JSON")
        return pathArchivo
    }
    
    init() {
        if let datosRecuperados = try? Data.init(contentsOf: rutaArchivos()) {
            if let datosDecodificados = try? JSONDecoder().decode([Symptom].self, from: datosRecuperados) {
                symptoms = datosDecodificados
                return
            }
        }
        
        //If no JSON, fetch info
        fetchPosts()
        
        // For testing
        // symptoms = getDefaultSymptoms()
    }
    
    private func getDefaultSymptoms() -> [Symptom] {
        return [
            Symptom(id: 1, nombre: "Peso", icon: "star.fill",  description: "Este es un ejemplo de descripción que es bastante largo y se va haciendo mucho más largo para comprobar la funcionalidad.", cuantitativo: true, unidades: "kg", activo: true, color: "#007AF"),
            Symptom(id: 2, nombre: "Cansancio", icon: "star.fill", description: "Este es un ejemplo de descripción corto.", cuantitativo: false, unidades: "", activo: false, color: "#AF43EB"),
            Symptom(id: 3, nombre: "Insomnio", icon: "star.fill", description: "Este es un ejemplo de descripción mediano, es decir, con esto está bien.", cuantitativo: true, unidades: "", activo: false, color: "#D03A20"),
            Symptom(id: 4, nombre: "Estado cardíaco", icon: "star.fill", description: "Latidos por minuto.", cuantitativo: true, unidades: "BPM", activo: false, color: "#86B953"),
            Symptom(id: 5, nombre: "Estado cardíaco 2", icon: "star.fill", description: "Latidos por minuto.", cuantitativo: true, unidades: "BPM", activo: false, color: "#86B953")
        
        ]
    }
}
