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
        ZStack{
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
            GeometryReader { geometry in
                        Image("logoP")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
                            .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.015)
                    }
        }
    }
}

struct AnalysisItemView: View {
    @State var symptom: Symptom
    let registers: RegisterList
    @State private var muestraRegisterSymptomView = false
    @State var currentTab = "7 días"
    
    var body: some View {
        let colorSintoma = Color(hex: symptom.color)
        VStack(alignment: .leading) {
            Text(symptom.nombre)
                .foregroundColor(colorSintoma)
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
            Text("Descripción: ")
                .font(.system(size: 24))
                .padding(.top, 5)
            
            Text("\(symptom.description)")
                .padding(.trailing, 20)
                .foregroundColor(colorSintoma)
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
                
                VStack (alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Registros")
                            .fontWeight(.semibold)
                            .foregroundColor(colorSintoma)
                        
                        Picker("", selection: $currentTab) {
                            Text("7 días")
                                .tag("7 días")
                            Text("Semanal")
                                .tag("Semanal")
                            Text("Mensual")
                                .tag("Mensual")
                        }
                        .pickerStyle(.segmented)
                        .padding(.leading, 60)
                        
                    }
                    
                    /*var sum : Float = 0.0
                    var prom : Float = 0.0
                    var max : Float = 0.0
                    
                    ForEach(registers.registers.filter { $0.idSymptom == symptom.id }, id:\.self) { item in
                        sum += item.cantidad
                        prom = prom + 1
                        if max < item.cantidad {
                            max = item.cantidad
                        }
                    }
                    
                    prom = sum / prom
                    
                    Text("Sum: \(sum.stringFormat), Prom: \(max.stringFormat), Max: \(prom.stringFormat)")
                        .font(.title3.bold())
                  */
                    AnimatedChart()
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 2)))
                }
                .padding(.trailing, 20)
                
                Spacer(minLength: 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 20)
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        let max = registers.registers.max { item1, item2 in
            return item2.cantidad > item1.cantidad
        }?.cantidad ?? 0
        
        Chart {
            ForEach(registers.registers.filter { $0.idSymptom == symptom.id }, id:\.self) { register in
                BarMark (
                        x: .value("Día", register.fecha.formatted(.dateTime.day().month())),
                        y: .value("CANTIDAD", register.cantidad)
                    )
            }
        }
        .chartYScale(domain: 0...(max*1.5))
        .frame(height: 250)
        /*.onAppear {
            for (index,_) in registers.registers.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.4) {
                    withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                        registers.registers[index].animacion = true
                    }
                }
            }
        }*/
    }
}



struct analysis_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(listSymp: SymptomList(), registers: RegisterList())
    }
}
