//
//  analysis.swift
//  bottomTabBar
//
//  Created by Alumno on 16/10/23.
//

import SwiftUI
import Charts

/**********************
 This view shows an analysis of the symptoms that are being tracked.
 **********************************/
struct AnalysisView: View {
    @State private var refreshID = UUID()
    @ObservedObject var listSymp: SymptomList
    @ObservedObject var registers: RegisterList
    @State private var muestraNewSymptom = false
    
    var body: some View {
        // If there are no symptoms bein checked, then show this view.
        if listSymp.symptoms.isEmpty {
            //The action serves as a trigger to show a sheet of the view to add new symptoms.
            EmptyListView(
                title: "No hay sintomas registrados",
                message: "Porfavor de agregar sintomas para poder empezar a registrar.",
                nameButton: "Agregar Sintoma",
                action: { muestraNewSymptom = true }
            )
            .sheet(isPresented: $muestraNewSymptom) {
                AddSymptomView(symptoms: listSymp, createAction: listSymp.makeCreateAction())
            }
        }
        // If there are symptoms being checked then show this view.
        else {
            VStack {
                // Show a tab for each symptom that is active.
                TabView {
                    ForEach(listSymp.symptoms.filter { $0.activo == true }, id: \.id) { symptom in
                        AnalysisItemView(symptom: symptom, registers: registers)
                    }
                }
                .id(refreshID)  // Force the TabView to update
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Spacer(minLength: 50)
            }
            .background(Color("mainWhite"))
            .onChange(of: registers.registers) { _ in
                // This will be called when registers change
                refreshID = UUID()  // Force the TabView to update
            }
        }
    }
}

struct AnalysisItemView: View {
    @State var symptom: Symptom
    let registers: RegisterList
    @State private var muestraRegisterSymptomView = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(symptom.nombre)
                .foregroundColor(Color(hex: symptom.color))
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)
            
            Text("Descripción:")
                .font(.system(size: 24))
                .padding(.vertical, 10)
//            Section{
//                ShareLink(
//                    "",
//                    item: ["Hola", "adios"].joined(separator: "\n"),
//                    preview: SharePreview("Comparte tus datos")
//                )
//            }

            
            Text("\(symptom.description)")
                .padding(.trailing, 20)
                .foregroundColor(Color(hex: symptom.color))
                .lineSpacing(4)
                .font(.system(size: 20))
                .frame(height: 120, alignment: .top)
            
            // The next if/else statement check for each symptoms if there is a data, if not then the if will run and notify the user that need to add a value to the symptom.
            if registers.registers.filter({ $0.idSymptom == symptom.id }).isEmpty {
                EmptyListView(
                    title: "No hay registros de este sintoma",
                    message: "Porfavor de agregar un estado a este sintoma para mostrar avances.",
                    nameButton: "Agregar Registro",
                    action: { muestraRegisterSymptomView = true }
                )
                .sheet(isPresented: $muestraRegisterSymptomView) {
                    RegisterSymptomView(symptom: $symptom, registers: registers, sliderValue: .constant(0.162),createAction: registers.makeCreateAction())
                }
                //The else statement runs if there is already data associated with the symptom.
            } else {
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
                
                Spacer(minLength: 50)
            }
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
