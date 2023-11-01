//
//  analysis.swift
//  bottomTabBar
//
//  Created by Alumno on 16/10/23.
//

import SwiftUI

struct analysis: View {
    @State private var descripcion = "Este es un ejemplo de descripción que es bastante largo y se va haciendo mucho más largo para comprobar la funcionalidad."
    @State private var sintomas = ["Síntoma1", "Síntoma2", "Síntoma3"]
    
    
    var body: some View {
        VStack {
            TabView {
                ForEach(sintomas, id: \.self) { sintoma in
                    VStack(alignment: .leading) {
                        HStack (spacing: 25) {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .padding(.top, 30)
                                .foregroundColor(Color.red)
                            
                            Text(sintoma)
                                .font(.largeTitle)
                                .bold()
                                .padding(.top, 30)
                        }
                        Text("Descripción: ")
                            .font(.system(size: 24))
                            .padding(.top, 22)
                        
                        TextField("", text: $descripcion, axis : .vertical)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 18))
                            .lineSpacing(4)
                            .border(.black)
                            .padding(.trailing, 20)
                            .disabled(true)
                        
                        Text("Promedio Semanal: ")
                            .font(.system(size: 24))
                            .padding(.top, 100)
                        
                        HStack {
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .padding(.top, 40)
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, 20)
                    
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            Spacer(minLength: 50)
        }
    }
}

struct analysis_Previews: PreviewProvider {
    static var previews: some View {
        analysis()
    }
}
