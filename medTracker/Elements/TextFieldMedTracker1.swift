//
//  TextFieldMedTracker1.swift
//  medTracker
//
//  Created by Sebastian Presno Alvarado on 10/11/23.
//

import Foundation
import SwiftUI



struct NeumorphicStyleTextField: View {
    
    var textField: TextField<Text>
    var imageName: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.white)
            textField
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.gray)
            .cornerRadius(6)
            .shadow(color: Color("blueGreen"), radius: 3, x: 2, y: 2)
            .shadow(color: Color.white, radius: 3, x: -2, y: -2)

        }
    
}

