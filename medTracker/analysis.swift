//
//  analysis.swift
//  bottomTabBar
//
//  Created by Alumno on 16/10/23.
//

import SwiftUI

struct analysis: View {
    @State private var descripcion = "Este es un ejemplo de descripción que es bastante largo y se va haciendo mucho más largo para comprobar la funcionalidad."
    
    var body: some View {
        VStack {
            Text("Nombre de Síntoma")
            
            Text("Descripción: ")
            
            TextField("", text: $descripcion, axis : .vertical)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 20)
        }
    }
}

struct analysis_Previews: PreviewProvider {
    static var previews: some View {
        analysis()
    }
}
