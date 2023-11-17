//
//  analysis.swift
//  bottomTabBar
//
//  Created by Alumno on 16/10/23.
//

import SwiftUI
import Charts

struct AnalysisView: View {
    
    @ObservedObject var listSymp : SymptomList
    @ObservedObject var registers : RegisterList
    
    var body: some View {
        VStack {
            TabView {
                ForEach(listSymp.symptoms, id: \.id) { symptom in
                    AnalysisItemView(symptom: symptom, registers: registers)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            Spacer(minLength: 50)
        }
    }
}

struct AnalysisItemView: View {
    let symptom: Symptom
    let registers: RegisterList
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(symptom.nombre)
                .foregroundColor(Color(hex: symptom.color))
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)
            
            Text("Descripción: ")
                .font(.system(size: 24))
                .padding(.vertical, 10)
            
            Text("\(symptom.description)")
                .padding(.trailing, 20)
                .foregroundColor(Color(hex: symptom.color))
                .lineSpacing(4)
                .font(.system(size: 18))
                .frame(height: 120, alignment: .top)
            
            Text("Últimos registros:")
                .font(.system(size: 24))
                .padding(.top, 30)
            
            Chart {
                ForEach(registers.registers.filter { $0.idSymptom == symptom.id }, id:\.self) { register in
                    BarMark(x: .value("DIA", register.fecha.formatted(.dateTime.day().month())), y: .value("CANTIDAD", register.cantidad))
                        .cornerRadius(10)
                        .annotation {
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
            
            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 20)
    }
}



struct analysis_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(listSymp: SymptomList(), registers: RegisterList())
    }
}
