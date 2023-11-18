//
//  Repository.swift
//  medTracker
//
//  Created by Alumno on 17/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Repository {
    static let symptomReference = Firestore.firestore().collection("symptoms")
    static let registerReference = Firestore.firestore().collection("registers")
    //static let id = UUID()
    
    static func createSymptom(_ symptom: Symptom) async throws {
        let document = symptomReference.document(String(symptom.id))
        try await document.setData(from: symptom)
    }
    
    static func fetchSymptoms() async throws -> [Symptom] {
        let snapshot = try await symptomReference
            .order(by: "id", descending: false)
            .getDocuments()
        // Convert the returning documents into the class Symptom
        return snapshot.documents.compactMap { document in
            try! document.data(as: Symptom.self)
        }
    }
    
    static func createRegister(_ register: Register) async throws {
        let document = registerReference.document(UUID().uuidString)
        try await document.setData(from: register)
    }
    
    static func fetchRegisters() async throws -> [Register] {
        let snapshot = try await registerReference
            .order(by: "idSymptom", descending: false)
            .getDocuments()
        // Convert the returning documents into the class Symptom
        return snapshot.documents.compactMap { document in
            try! document.data(as: Register.self)
        }
    }
}

// This method is to not show an error for some of the methods above
private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // Method only throws if there’s an encoding error, which indicates a problem with our model.
            // We handled this with a force try, while all other errors are passed to the completion handler.
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}
