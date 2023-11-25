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
                            AnalysisItemView(symptom: symptom, registerList: registers, registers: registers.registers.filter({ $0.idSymptom == symptom.id }))
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
            Image("logoP")
                .resizable()
                .imageScale(.small)
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
                .offset(x: 0, y: -360)
        }
    }
}

struct AnalysisItemView: View {
    @State var symptom: Symptom
    let registerList: RegisterList
    @State var registers: [Register]
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
            if registers.isEmpty {
                EmptyListView(
                    title: "No hay registros de este sintoma",
                    message: "Porfavor de agregar un estado a este sintoma para mostrar avances.",
                    nameButton: "Agregar Registro",
                    action: { muestraRegisterSymptomView = true }
                )
                .sheet(isPresented: $muestraRegisterSymptomView) {
                    RegisterSymptomView(symptom: $symptom, registers: registerList, sliderValue: .constant(0.162),createAction: registerList.makeCreateAction())
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
                    
                    let spm = operaciones()
                    Text("Sum: \(spm[0].stringFormat)  Prom: \(spm[1].stringFormat)  Max: \(spm[2].stringFormat)")
                        .font(.system(size: 18).bold())
                        //.foregroundColor(Color(hex: symptom.color))
                    
                    
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
        .chartOverlay(content: { proxy in
            GeometryReader { innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let location = value.location
                                
                                if let day: Date = proxy.value(atX: location.x) {
                                    print(day)
                                }
                            } .onEnded { value in
                                
                            }
                    )
            }
        })
        .onChange(of: currentTab) { newValue in
            //animateGraph(fromChange: true)
        }
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        let max = registers.max { item1, item2 in
            return item2.cantidad > item1.cantidad
        }?.cantidad ?? 0
        
        Chart {
            ForEach(registers, id:\.self) { register in
                LineMark (
                        x: .value("Día", register.fecha.formatted(.dateTime.day().month())),
                        y: .value("CANTIDAD", register.cantidad)//register.animacion ? register.cantidad : 0)
                    )
                .foregroundStyle(Color(hex: symptom.color))
                .interpolationMethod(.catmullRom)
                
                AreaMark (
                        x: .value("Día", register.fecha.formatted(.dateTime.day().month())),
                        y: .value("CANTIDAD", register.cantidad)//register.animacion ? register.cantidad : 0)
                    )
                .foregroundStyle(Color(hex: symptom.color).opacity(0.1))
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYScale(domain: 0...(max*1.5))
        .frame(height: 250)
        //.onAppear() {
          //  animateGraph()
        //}
    }
    
    /*func animateGraph(fromChange: Bool = false) {
        for (index,_) in registers.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    registers[index].animacion = true
                }
            }
        }
    }*/
    
    func operaciones() -> [Float] {
        var operacionesList : [Float] = [0,0,0]
        
        for item in registers {
            operacionesList[0] = operacionesList[0] + item.cantidad
            operacionesList[1] = operacionesList[1] + 1
            if operacionesList[2] < item.cantidad {
                operacionesList[2] = item.cantidad
            }
        }
        operacionesList[1] = operacionesList[0] / operacionesList[1]
        
        return operacionesList
    }
}

struct analysis_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(listSymp: SymptomList(), registers: RegisterList())
    }
}
