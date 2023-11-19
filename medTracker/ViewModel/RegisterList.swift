//
//  RegisterList.swift
//  medTracker
//
//  Created by Alumno on 10/11/23.
//

import Foundation

class RegisterList : ObservableObject {
    @Published var registers = [Register]() /*{
        didSet {
            if let codificado = try? JSONEncoder().encode(registers) {
                try? codificado.write(to: rutaArchivos())
            }
        }
    }*/
    let repository = Repository()
    func makeCreateAction() -> RegisterSymptomView.CreateAction {
        return { [weak self] register in
            try await self?.repository.createRegister(register)
        }
    }
    
    func fetchPosts() {
        Task {
            do {
                registers = try await self.repository.fetchRegisters()
            } catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
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
                return
            }
        }
        
        //If no JSON, fetch info
        fetchPosts()
        
        // For testing
        //registers = getDefaultRegisters()
    }
    
    private func getDefaultRegisters() -> [Register] {
        return [
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
}
