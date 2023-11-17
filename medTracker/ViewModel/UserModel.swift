//
//  UserModel.swift
//  medTracker
//
//  Created by Alumno on 17/11/23.
//

import Foundation

/*class UserModel: ObservableObject {
    @Published var user = User {
        didSet {
            if let codificado = try? JSONEncoder().encode(user) {
                try? codificado.write(to: rutaArchivos())
            }
        }
    }

    func rutaArchivos() -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent("User.JSON")
        return pathArchivo
    }

    init() {
        loadUser()
    }

    // Load user from the file or use default values
    private func loadUser() {
        do {
            let datosRecuperados = try Data(contentsOf: rutaArchivos())
            let datosDecodificados = try JSONDecoder().decode(User.self, from: datosRecuperados)
            user = datosDecodificados
        } catch {
            // If decoding fails or no data is available, use default values
            user = getDefaultUser()
        }
    }

    // Default user for a new user
    private func getDefaultUser() -> User {
        return User(telefono: "1", nombre: "Diego", apellidoPaterno: "Velázquez", apellidoMaterno: "Saldaña", sexo: "Masculino", antecedentes: "", estatura: 1.68)
    }
}*/

