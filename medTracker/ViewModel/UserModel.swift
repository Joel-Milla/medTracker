//
//  UserModel.swift
//  medTracker
//
//  Created by Alumno on 17/11/23.
//

import Foundation

class UserModel: ObservableObject {
    @Published var user = User() /*{
        didSet {
            if let codificado = try? JSONEncoder().encode(user) {
                try? codificado.write(to: rutaArchivos())
            }
        }
    }*/

    func rutaArchivos() -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent("User.JSON")
        return pathArchivo
    }

    init() {
        loadUser()
    }

    // Load user from the file or use default values
    func saveUser() {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "savedUser")
        }
    }
    
    func loadUser() {
        if let savedUserData = UserDefaults.standard.object(forKey: "savedUser") as? Data {
            if let loadedUser = try? JSONDecoder().decode(User.self, from: savedUserData) {
                user = loadedUser
            }
        }
    }
}

