//
//  newSymptom.swift
//  medTracker
//
//  Created by Alumno on 26/10/23.
//

import SwiftUI
import SegmentedPicker

struct AddSymptomView: View {
    @State var nombreSintoma = ""
    @State var descripcion = ""
    @State private var colorSymptom = Color.blue
    @State private var colorString = ""
    
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
                
                Text("Descripción: \(colorString)")
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
        .onAppear {
            // Initialize hexString with the initial color
            colorString = hexString(from: colorSymptom)
        }
        .onChange(of: colorSymptom) { newColor in
            // Update hexString when the color changes
            colorString = hexString(from: newColor)
        }
    }
    
    func hexString(from color: Color) -> String {
            // Convert SwiftUI Color to UIColor
            let uiColor = UIColor(color)

            // Get the RGBA components
            guard let components = uiColor.cgColor.components else {
                return ""
            }

            let red = Float(components[0])
            let green = Float(components[1])
            let blue = Float(components[2])

            // Convert the components to HEX
            let hexString = String(
                format: "#%02lX%02lX%02lX",
                lroundf(red * 255),
                lroundf(green * 255),
                lroundf(blue * 255)
            )

            return hexString
    }
}

struct newSymptom_Previews: PreviewProvider {
    static var previews: some View {
        AddSymptomView()
    }
}