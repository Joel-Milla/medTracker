//
//  AnalysisDoctorView.swift
//  medTracker
//
//  Created by Alumno on 26/11/23.
//

import SwiftUI
import Charts

/**********************
 This view shows an analysis of the symptoms that are being tracked by the patient.
 **********************************/
struct AnalysisDoctorView: View {
    let patient: Patient
    @State var patientsData: PatientsData
    
    init(patient: Patient) {
        self.patient = patient
        _patientsData = State(initialValue: PatientsData(email: patient.email))
    }
    
    var body: some View {
        ZStack {
            switch patientsData.state {
            case .complete:
                // If there are no symptoms bein checked, then show this view.
                if patientsData.symptoms.isEmpty {
                    //The action serves as a trigger to show a sheet of the view to add new symptoms.
                    EmptyListView(
                        title: "No hay sintomas registrados",
                        message: "El paciente no ha agregado ningun sintoma.",
                        nameButton: "Agregar Sintoma"
                    )
                }
                // If there are symptoms being checked then show this view.
                else {
                    VStack {
                        // Show a tab for each symptom that is active.
                        TabView {
                            ForEach(patientsData.symptoms.filter { $0.activo == true }, id: \.id) { symptom in
                                AnalysisPatientView(symptom: symptom, allRegisters: patientsData.registers.filter({ $0.idSymptom == symptom.id }))
                            }
                        }
                        .tabViewStyle(.page)
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                        
                        Spacer(minLength: 50)
                    }
                    .background(Color("mainWhite"))
                }
                GeometryReader { geometry in
                    Image("logoP")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
                        .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.015)
                }
            case .isLoading:
                ProgressView()
            }
        }
    }
}

struct AnalysisPatientView: View {
    @State var symptom: Symptom
    @State var allRegisters: [Register]
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
                    message: "El paciente no ha ingresado ningun dato para este sintoma.",
                    nameButton: "Agregar Registro"
                )
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
                    
                    AnimatedChart(filteredRegisters: registers)
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
    func AnimatedChart(filteredRegisters: [Register]) -> some View {
        
        let registers = filteredRegisters.sorted { $0.fecha < $1.fecha }
        
        let spm = operaciones(registers: registers)
        Text("Sum: \(spm[0].stringFormat)  Prom: \(spm[1].stringFormat)  Max: \(spm[2].stringFormat)")
            .font(.system(size: 18).bold())
        //.foregroundColor(Color(hex: symptom.color))
        
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
    }
    
    func operaciones(registers: [Register]) -> [Float] {
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

struct AnalysisDoctorView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisDoctorView(patient: Patient(email: "", name: ""))
    }
}
