//
//  analysis.swift
//  bottomTabBar
//
//  Created by Alumno on 16/10/23.
//

import SwiftUI
import Charts

struct AnalysisView: View {
    @State var registers = [
        Register(idSymptom: 1, fecha: Date.now, cantidad: 80, notas: "Esto es una nota."),
        Register(idSymptom: 1, fecha: Date.now.addingTimeInterval(86400), cantidad: 80.5, notas: "Esto es una nota."),
        Register(idSymptom: 1, fecha: Date.now.addingTimeInterval(86400*2), cantidad: 80.2, notas: "Esto es una nota."),
        Register(idSymptom: 1, fecha: Date.now.addingTimeInterval(86400*3), cantidad: 79.6, notas: "Esto es una nota."),
        
        Register(idSymptom: 2, fecha: Date.now, cantidad: 80, notas: "Esto es una nota."),
        
        Register(idSymptom: 3, fecha: Date.now, cantidad: 80, notas: "Esto es una nota."),
        Register(idSymptom: 3, fecha: Date.now.addingTimeInterval(86400), cantidad: 70, notas: "Esto es una nota."),
        Register(idSymptom: 3, fecha: Date.now.addingTimeInterval(86400*2), cantidad: 30, notas: "Esto es una nota."),
        Register(idSymptom: 3, fecha: Date.now.addingTimeInterval(86400*3), cantidad: 40, notas: "Esto es una nota."),
        
        Register(idSymptom: 4, fecha: Date.now, cantidad: 80, notas: "Esto es una nota.")
    ]
    
    @State var symptoms = [
        Symptom(id: 1, nombre: "Peso", description: "Este es un ejemplo de descripción que es bastante largo y se va haciendo mucho más largo para comprobar la funcionalidad.", cuantitativo: true, unidades: "kg", activo: true, color: "#007AF"),
        Symptom(id: 2, nombre: "Cansancio", description: "Este es un ejemplo de descripción corto.", cuantitativo: false, unidades: "", activo: false, color: "#AF43EB"),
        Symptom(id: 3, nombre: "Insomnio", description: "Este es un ejemplo de descripción mediano, es decir, con esto está bien.", cuantitativo: true, unidades: "", activo: false, color: "#D03A20"),
        Symptom(id: 4, nombre: "Estado cardíaco", description: "Latidos por minuto.", cuantitativo: true, unidades: "BPM", activo: false, color: "#86B953")
    ]
    
    var body: some View {
        VStack {
            TabView {
                ForEach(symptoms, id: \.self) { symptom in
                    VStack(alignment: .leading) {
                        Text(symptom.nombre)
                            .foregroundColor(Color(hex: symptom.color))
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, 30)
                        
                        Text("Descripción: ")
                            .font(.system(size: 24))
                            .padding(.top, 22)
                        
                        @State var descripcion = symptom.description
                        
                        TextField("", text: $descripcion, axis : .vertical)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 18))
                            .lineSpacing(4)
                            .border(.black)
                            .padding(.trailing, 20)
                            .disabled(true)
                        
                        Text("Promedio última semana: ")
                            .font(.system(size: 24))
                            .padding(.top, 30)
                        
                        Chart {
                            ForEach(registers, id:\.self) { register in
                                BarMark(x: .value("DIA", register.fecha.formatted(.dateTime.day().month())),
                                        y: .value("CANTIDAD", register.cantidad))
                                    .cornerRadius(10)
                                    .annotation{
                                        Text(String(format: "%.0f", register.cantidad))
                                    }
                            }
                        }
                        .frame(height: 300)
                        .foregroundStyle(Color(hex: symptom.color))
                        .padding()
                        .shadow(radius: /*@START_MENU_TOKEN@*/6/*@END_MENU_TOKEN@*/)
                        .chartXAxisLabel("DIA", alignment: .topTrailing, spacing: 10)
                        .chartYAxisLabel("CANTIDAD", spacing: 10)
                        .foregroundColor(.black)
                        .chartPlotStyle { plotContent in
                            plotContent
                                .background(.gray.opacity(0.1))
                                .border(Color.black, width: 2)
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
        .background(Color("mainWhite"))
    }
}

struct analysis_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
            .environmentObject(SymptomList())
            .environmentObject(RegisterList())
    }
}
