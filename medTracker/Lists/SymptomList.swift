//
//  SymptomList.swift
//  medTracker
//
//  Created by Alumno on 10/11/23.
//

import Foundation

class SymptomList : ObservableObject {
    @Published var symptoms = [Symptom]()
}
