//
//  RegisterList.swift
//  medTracker
//
//  Created by Alumno on 10/11/23.
//

import Foundation

class RegisterList : ObservableObject {
    @Published var registers = [Register]() {
        didSet {
            if let codificado = try? JSONEncoder().encode(registers) {
                try? codificado.write(to: rutaArchivos())
            }
        }
    }
    
    func rutaArchivos() -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent("Registers.JSON")
        return pathArchivo
    }
    
    init() {
        if let datosRecuperados = try? Data.init(contentsOf: rutaArchivos()) {
            if let datosDecodificados = try? JSONDecoder().decode([Register].self, from: datosRecuperados) {
                registers = datosDecodificados
                if registers == [] {
                    registers = [
                        Register(idSymptom: 1, fecha: Date.now, cantidad: 80, notas: "Esto es una nota."),
                        Register(idSymptom: 1, fecha: Date.now.addingTimeInterval(86400), cantidad: 80.5, notas: "Esto es una nota."),
                        Register(idSymptom: 1, fecha: Date.now.addingTimeInterval(86400*2), cantidad: 80.2, notas: "Esto es una nota."),
                        Register(idSymptom: 1, fecha: Date.now.addingTimeInterval(86400*3), cantidad: 20, notas: "Esto es una nota."),
                        
                        Register(idSymptom: 2, fecha: Date.now, cantidad: 80, notas: "Esto es una nota."),
                        
                        Register(idSymptom: 3, fecha: Date.now, cantidad: 80, notas: "Esto es una nota."),
                        Register(idSymptom: 3, fecha: Date.now.addingTimeInterval(86400), cantidad: 70, notas: "Esto es una nota."),
                        Register(idSymptom: 3, fecha: Date.now.addingTimeInterval(86400*2), cantidad: 30, notas: "Esto es una nota."),
                        Register(idSymptom: 3, fecha: Date.now.addingTimeInterval(86400*3), cantidad: 40, notas: "Esto es una nota."),
                        
                        Register(idSymptom: 4, fecha: Date.now, cantidad: 80, notas: "Esto es una nota.")
                    ]
                }
                return
            }
        }
        registers = []
    }
}
