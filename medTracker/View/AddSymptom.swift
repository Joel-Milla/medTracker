//
//  AddSymptom.swift
//  medTracker
//
//  Created by Alumno on 17/11/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AddSymptom: View {
    typealias CreateAction = (Symptom) async throws -> Void
    let createAction: CreateAction
    
    @ObservedObject var listaDatos : SymptomList
            
    @State var symptom = Symptom(id: 1, nombre: "test", description: "test", cuantitativo: true, unidades: "test", activo: true, color: "#86B953")
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Button("Add test symptom") {
                createSymptom()
                dismiss()
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
        }
    }

    private func createSymptom() {
        // Just append the symptom to the list
        symptom.id = listaDatos.symptoms.count
        symptom.nombre = "\(symptom.id)"
        listaDatos.symptoms.append(symptom)
        // will wait until the createAction(symptom) finishes
        Task {
            do {
                try await createAction(symptom) //call the function that adds the symptom to the database
                dismiss()
            } catch {
                print("[NewPostForm] Cannot create post: \(error)")
            }
        }
    }
    
}

struct AddSymptom_Previews: PreviewProvider {
    static var previews: some View {
        AddSymptom(createAction: { _ in }, listaDatos: SymptomList())
    }
}
