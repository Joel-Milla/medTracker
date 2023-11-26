//
//  Repository.swift
//  medTracker
//
//  Created by Alumno on 17/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/**********************
 This struct contains helper functions to make the connection to the database (firebase)
 **********************************/

struct Repository {
    // Variables to make the connection to firebase.
    private var symptomReference: CollectionReference
    private var doctorReference: CollectionReference
    private var registerReference: CollectionReference
    private var userReference = Firestore.firestore().collection("Users")
    private var email: String
    
    /**********************
     Important initialization methods
     **********************************/
    init() {
        email = Repository.getEmail()
        // Assuming you want to append the email to the collection name
        symptomReference = Firestore.firestore().collection("symptoms_\(email)")
        doctorReference = Firestore.firestore().collection("doctor_\(email)")
        registerReference = Firestore.firestore().collection("registers_\(email)")
    }
    
    /**********************
     Helper functions
     **********************************/
    
    // Function to get the email of the current user.
    static func getEmail() -> String {
        if let email = try? Data.init(contentsOf: HelperFunctions.filePath("email.JSON")) {
            if let email = try? JSONDecoder().decode(String.self, from: email) {
                return email
            }
        }
        return ""
    }
    
    // Function to write a symptom in database.
    func createSymptom(_ symptom: Symptom) async throws {
        let document = symptomReference.document(String(symptom.id))
        try await document.setData(from: symptom)
    }
    
    // Function to fetch all the symptoms in firebase.
    func fetchSymptoms() async throws -> [Symptom] {
        let snapshot = try await symptomReference
            .order(by: "id", descending: false)
            .getDocuments()
        // Convert the returning documents into the class Symptom
        return snapshot.documents.compactMap { document in
            try! document.data(as: Symptom.self)
        }
    }
    
    // Function to write a register in database.
    func createRegister(_ register: Register) async throws {
        let document = registerReference.document(UUID().uuidString)
        try await document.setData(from: register)
    }
    
    // Functin to obtain the registers that exist on database.
    func fetchRegisters() async throws -> [Register] {
        let snapshot = try await registerReference
            .order(by: "idSymptom", descending: false)
            .getDocuments()
        // Convert the returning documents into the class Register
        return snapshot.documents.compactMap { document in
            try! document.data(as: Register.self)
        }
    }
    
    // Function to write a user in database.
    func createUser(_ user: User) async throws {
        let document = userReference.document(email)
        try await document.setData(from: user)
    }
    
    // Functin to obtain the user info that exist on database.
    func fetchUser() async throws -> User {
        let documentReference = userReference.document(email)
        let documentSnapshot = try await documentReference.getDocument()
        
        // Try to decode the document data into a User object
        do {
            let userData = try documentSnapshot.data(as: User.self)
            return userData
        } catch {
            // Handle the error if decoding fails
            throw NSError(domain: "DataDecodingError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user data: \(error.localizedDescription)"])
        }
    }
    
    // Function to write own name as a document in doctors collection
    func writePatient(_ docEmail: String, _ user: User) async throws {
        let doctorReference = Firestore.firestore().collection("doctor_\(docEmail)")
        let document = doctorReference.document(email)
        try await document.setData([
            "name": user.nombreCompleto,
            "email": email
        ])
    }
    
    // Function to fetch all the patients of a doctor.
    func fetchPatients() async throws -> [Patient] {
        let snapshot = try await doctorReference
            .order(by: "name", descending: false)
            .getDocuments()
        // Convert the returning documents into the class Patient
        return snapshot.documents.compactMap { document in
            try! document.data(as: Patient.self)
        }
    }
}

// This method is to not show an error for some of the methods above.
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
