//
//  newSymptom.swift
//  medTracker
//
//  Created by Alumno on 26/10/23.
//

import SwiftUI
import SegmentedPicker

struct newSymptom: View {
    @State var nombreSintoma = ""
    @State var descripcion = ""
    @State var tipo = ["#", "-*-"]
    @State private var colorSymptom = Color.blue
    
    @State var selectedIndex: Int?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    TextField("Nombre del síntoma", text: $nombreSintoma, axis : .vertical)
                        .font(.system(size: 28))
                        .lineSpacing(4)
                        .foregroundColor(colorSymptom)
                    
                    ColorPicker("", selection: $colorSymptom)
                        .labelsHidden()
                        .padding(.trailing, 20)
                }
                .padding(.top, 20)
                
                Text("Descripción: ")
                    .font(.system(size: 24))
                    .padding(.top, 22)
                
                TextField("Escriba la descripción del síntoma", text: $descripcion, axis : .vertical)
                    .font(.system(size: 18))
                    .textFieldStyle(.roundedBorder)
                    .lineSpacing(4)
                    .padding(.trailing, 20)
                    .foregroundColor(colorSymptom)
                
                Text("Tipo: ")
                    .font(.system(size: 24))
                    .padding(.top, 22)
                
                HStack {
                    Spacer()
                    SegmentedPicker(
                        ["Cuantitativo", "Cualitativo"],
                        selectedIndex: Binding(
                            get: { selectedIndex },
                            set: { selectedIndex = $0 }),
                        content: { item, isSelected in
                            Text(item)
                                .foregroundColor(isSelected ? Color.white : Color.black )
                                .padding(.horizontal, 45)
                                .padding(.vertical, 8)
                        },
                        selection: {
                            Capsule()
                                .fill(colorSymptom)
                        })
                    .onAppear {
                        selectedIndex = 0
                    }
                    .animation(.easeInOut(duration: 0.3))
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.leading, 20)
            .background(Color("mainWhite"))
            .navigationTitle("Nuevo síntoma")
        }
    }
}

struct newSymptom_Previews: PreviewProvider {
    static var previews: some View {
        newSymptom()
    }
}
