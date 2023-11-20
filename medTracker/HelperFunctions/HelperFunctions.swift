//
//  HelperFunctions.swift
//  medTracker
//
//  Created by Alumno on 20/11/23.
//

import Foundation

/**********************
 This class will contain all the functions that are needed multiple times among all the project.
 **********************************/
@MainActor
class HelperFunctions {
    // This function returns a url inside sandbox based on the "path" variable that is being passed.
    static func rutaArchivos(filename path: String) -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathArchivo = url.appendingPathComponent(path)
        return pathArchivo
    }
    // The function write(), writes the "value" being passed into the "file" passed.
    static func write(_ value: String, inPath file: String) {
        if let codificado = try? JSONEncoder().encode(value) {
            try? codificado.write(to: rutaArchivos(filename: file)) //writes the value passed into the file passed.
        }
    }
}
