//
//  newSymptom.swift
//  medTracker
//
//  Created by Alumno on 26/10/23.
//

import SwiftUI

struct newSymptom: View {
    @State var nombreSintoma = ""
    @State var descripcion = ""
    @State var tipo = ["#", "-*-"]
    
    init() {
            UISegmentedControl.appearance().selectedSegmentTintColor = .red
            UISegmentedControl.appearance().setTitleTextAttributes(
                [
                    .font: UIFont.boldSystemFont(ofSize: 24),
                    .foregroundColor: UIColor.white
            ], for: .selected)

            UISegmentedControl.appearance().setTitleTextAttributes(
                [
                    .font: UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor: UIColor.blue
            ], for: .normal)
        }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            TextField("Nombre del síntoma", text: $nombreSintoma, axis : .vertical)
                .font(.system(size: 28))
                .lineSpacing(4)
                .padding(.top, 40)
                .padding(.trailing, 20)
            
            Text("Descripción: ")
                .font(.system(size: 24))
                .padding(.top, 22)
            
            TextField("Escriba la descripción del síntoma", text: $descripcion, axis : .vertical)
                .font(.system(size: 18))
                .textFieldStyle(.roundedBorder)
                .lineSpacing(4)
                .padding(.trailing, 20)
            
            Text("Tipo: ")
                .font(.system(size: 24))
                .padding(.top, 22)
            
            Picker(selection: $tipo) {
                ForEach(tipo, id: \.self) { t in
                    Text(t)
                }
            } label: {
                
            }
            .pickerStyle(.segmented)
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 20)
    }
}

struct newSymptom_Previews: PreviewProvider {
    static var previews: some View {
        newSymptom()
    }
}
