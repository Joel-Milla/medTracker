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
    @State var registrosSintomas : [Register] = []
    
    var body: some View {
        ZStack{
            // If there are no symptoms bein checked, then show this view.
            if listSymp.symptoms.isEmpty {
                //The action serves as a trigger to show a sheet of the view to add new symptoms.
                EmptyListView(
                    title: "No hay datos registrados",
                    message: "Favor de agregar datos para poder empezar a registrar.",
                    nameButton: "Agregar Dato",
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
                            AnalysisItemView(symptom: symptom, registerList: registers, listSymp: listSymp, allRegisters: registers.registers.filter({ $0.idSymptom == symptom.id }))
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
    let registerList: RegisterList
    let listSymp : SymptomList
    @State var allRegisters: [Register]
    @State private var muestraRegisterSymptomView = false
    @State var currentTab = "Semana"
    @State var registers : [Register] = []
    
    var body: some View {
        let colorSintoma = Color(hex: symptom.color)
        VStack(alignment: .leading) {
            Text(symptom.nombre)
                .foregroundColor(colorSintoma)
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)
            
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
            if allRegisters.isEmpty {
                EmptyListView(
                    title: "No hay registros de este sintoma",
                    message: "Porfavor de agregar un estado a este sintoma para mostrar avances.",
                    nameButton: "Agregar Registro",
                    action: { muestraRegisterSymptomView = true }
                )
                .sheet(isPresented: $muestraRegisterSymptomView) {
                    RegisterSymptomView(symptom: $symptom, registers: registerList, symptomList: listSymp, sliderValue: .constant(0.162),createAction: registerList.makeCreateAction())
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
                            Text("Semana")
                                .tag("Semana")
                            Text("Mes")
                                .tag("Mes")
                            Text("Todos")
                                .tag("Todos")
                        }
                        .pickerStyle(.segmented)
                        .padding(.leading, 60)
                    }
                    .padding(.bottom, symptom.cuantitativo ? 0 : 35)
                    
                    if symptom.cuantitativo {
                        ChartCuantitativa(filteredRegisters: registers)
                    } else {
                        ChartCualitativa(filteredRegisters: registers)
                    }
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color("mainWhite").shadow(.drop(color: .primary,radius: 1)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color(hex: symptom.color), lineWidth: 1) // Adjust color and lineWidth as needed
                        )
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(colorSintoma, lineWidth: 2) // Adjust color and line width as needed
                )
                .padding(.trailing, 20)
                
                Spacer(minLength: 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 20)
        /*.overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(colorSintoma)
        }*/
        .onAppear() {
            registers = allRegisters
            currentTab = "Semana"
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            registers = allRegisters.filter { $0.fecha > oneWeekAgo }
        }
        .onChange(of: currentTab) { newValue in
            registers = allRegisters
            if newValue == "Semana" {
                let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
                registers = allRegisters.filter { $0.fecha > oneWeekAgo }
            } else if newValue == "Mes" {
                let oneMonthAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
                registers = allRegisters.filter { $0.fecha > oneMonthAgo }
            }
        }
    }
    
    
    
    @ViewBuilder
    func ChartCuantitativa(filteredRegisters: [Register]) -> some View {
        
        let registers = filteredRegisters.sorted { $0.fecha < $1.fecha }
        
        let spm = operaciones(registers: registers)
        Text("Prom: \(spm[0].stringFormat)  Max: \(spm[1].stringFormat)  Min: \(spm[2].stringFormat)")
            .font(.system(size: 18).bold())
        //.foregroundColor(Color(hex: symptom.color))
        
        let min = spm[2]*0.8
        let max = spm[1]*1.2
        
        Chart {
            ForEach(registers, id:\.self) { register in
                LineMark (
                    x: .value("Día", register.fecha, unit: .day),
                    y: .value("CANTIDAD", register.cantidad)//register.animacion ? register.cantidad : 0)
                )
                .foregroundStyle(Color(hex: symptom.color))
                .interpolationMethod(.catmullRom)
                
                AreaMark (
                    x: .value("Día", register.fecha, unit: .day),
                    yStart: .value("minY", min),
                    yEnd: .value("maxY", register.cantidad)
                    //y: .range(min...register.cantidad)//register.animacion ? register.cantidad : 0)
                )
                .foregroundStyle(Color(hex: symptom.color).opacity(0.1))
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYScale(domain: min <= max ? min...max : 0...100)
        .frame(height: 250)
        .background(Color("mainWhite"))
        
    }
    /*.onAppear {
     for (index,_) in registers.registers.enumerated() {
     DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.4) {
     withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
     registers.registers[index].animacion = true
     }
     }
     }
     }
     }*/
    
    @ViewBuilder
    func ChartCualitativa(filteredRegisters: [Register]) -> some View {
        let registers = filteredRegisters.sorted { $0.fecha < $1.fecha }
        
        let yAxisLabels: [ImageYAxisLabel] = [
                ImageYAxisLabel(id: 10, image: "sadder_face"),
                ImageYAxisLabel(id: 30, image: "sad_face"),
                ImageYAxisLabel(id: 50, image: "normal_face"),
                ImageYAxisLabel(id: 70, image: "va_test"),
                ImageYAxisLabel(id: 90, image: "happier_face")
            ]
        
            Chart {
                ForEach(registers, id:\.self) { register in
                    LineMark (
                        x: .value("Día", register.fecha, unit: .day),
                        y: .value("CANTIDAD", register.cantidad)
                    )
                    .foregroundStyle(Color(hex: symptom.color))
                    .interpolationMethod(.catmullRom)

                    AreaMark (
                        x: .value("Día", register.fecha, unit: .day),
                        yStart: .value("minY", 0),
                        yEnd: .value("maxY", register.cantidad)
                    )
                    .foregroundStyle(Color(hex: symptom.color).opacity(0.1))
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartYScale(domain: 0...100)
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 6))
            }
            .overlay(
                customYAxisScale(yAxisLabels: yAxisLabels)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            )
            .frame(height: 250)
            .background(Color("mainWhite"))
        }
    
    private func customYAxisScale(yAxisLabels: [ImageYAxisLabel]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(yAxisLabels) { label in
                Image(label.image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.bottom, 6)
            }
        }
        .foregroundColor(.clear)
        .padding(.top, 5)
    }
    
    func operaciones(registers: [Register]) -> [Float] {
        var operacionesList : [Float] = [0,0,Float.greatestFiniteMagnitude]
        
        for item in registers {
            operacionesList[0] = operacionesList[0] + item.cantidad
            if operacionesList[1] < item.cantidad {
                operacionesList[1] = item.cantidad
            }
            if operacionesList[2] > item.cantidad {
                operacionesList[2] = item.cantidad
            }
        }
        operacionesList[0] = operacionesList[0] / Float(registers.count)
        
        return operacionesList
    }
}

struct analysis_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(listSymp: SymptomList(), registers: RegisterList())
    }
}
