//
//  PatientList.swift
//  medTracker
//
//  Created by Alumno on 25/11/23.
//

import Foundation

/**********************
 This class contains all the patients of a doctor.
 **********************************/
class PatientList : ObservableObject {
    @Published var patients = [Patient]()
    @Published var state: State = .isLoading //State of the symptoms array
    let repository = Repository() // Variable to call the functions inside the repository
    
    /**********************
     Important initialization methods
     **********************************/
    init() {
        //Fetch patients, so it loads every time
        fetchPatients()
        
        // For testing, the next function can be used for dummy data.
        //symptoms = getDefaultSymptoms()
    }
    
    enum State {
        case complete
        case isLoading
        case isEmpty
    }
    
    /**********************
     Helper functions
     **********************************/

    // Fetch symptoms from the database and save them on the symptoms list.
    func fetchPatients() {
        state = .isLoading
        Task {
            do {
                patients = try await self.repository.fetchPatients()
                state = patients.isEmpty ? .isEmpty : .complete
            } catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
            }
        }
    }
}
