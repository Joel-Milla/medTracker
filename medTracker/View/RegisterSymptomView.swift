//
//  RegistroDatos1.swift
//  medTracker
//
//  Created by Sebastian Presno Alvarado on 18/10/23.
//

import SwiftUI



struct RegisterSymptomView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var mostrarTeclado : Bool
    @Binding var symptom : Symptom
    @ObservedObject var registers : RegisterList
    @Binding var sliderValue : Double
    //@StateObject var symptom = Symptom()
    @State var metricsString = ""
    @State private var date = Date.now
    //@State var sliderOrTF : Bool = false
    @State var notes = "Agrega alguna nota..."
    var dummySymptom = "Migraña"
    @State var metric: Double = 0
    @State var isPresented = false
    //@StateObject var symptom = Symptom()
    //let mainWhite = Color
    
    typealias CreateAction = (Register) async throws -> Void
    let createAction: CreateAction
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack(){
                ZStack {
                    VStack() {
                        Text(symptom.nombre)
                            .font(.title)
                            .foregroundStyle(Color(hex: symptom.color))
                            .bold()
                            .padding(.horizontal, -179)
                            .frame(height: geometry.size.height *  0.06)
                        DatePicker("Fecha registro", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.automatic)
                            .padding(.vertical,30)
                            //.preferredDatePickerStyle = .inline
                            .foregroundColor(Color(hex: symptom.color)) // sale identico??
                            .tint(Color(hex: symptom.color))
                            .bold()
                        //Text("La fecha es \(date.formatted(date: .numeric, time: .shortened))")
                        if(!symptom.cuantitativo){
                            Text("¿Qué tanto malestar tienes?")
                                .font(.system(size: 18))
                                .foregroundStyle(Color(hex: symptom.color))
                                .bold()
                            CustomSlider(valueFinal: $metric, valor: sliderValue)
                                .padding(.horizontal, 5)
                                .frame(height: geometry.size.height * 0.06)
                                .padding(.vertical, 35)
                        }
                        else{
                            Text("Ingresa el valor")
                                .font(.system(size: 18))
                                .foregroundStyle(Color(hex: symptom.color))
                                .bold()
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray, lineWidth: 0.5)
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color("mainWhite")))
                                    .frame(width: geometry.size.width * 0.63, height: geometry.size.height * 0.1)
                                
                                HStack {
                                    Image(systemName: "heart.text.square.fill")
                                        .foregroundColor(Color(hex: symptom.color))
                                        .font(.title)
                                    TextField("", text: $metricsString, prompt: Text("Valor").foregroundColor(.gray))
                                        .font(.title2)
                                        .padding()
                                        .textFieldStyle(OvalTextFieldStyle())
                                        .multilineTextAlignment(.leading)
                                        .keyboardType(.numberPad)
                                        .focused($mostrarTeclado)
                                }
                                .padding()
                            }
                        }
                            
                        //Spacer()
                        TextEditor(text: self.$notes) // usar geomtery reader
                            .foregroundColor(self.notes == notes ? .gray : .primary)
                            .onTapGesture {
                                if self.notes == notes {
                                    self.notes = ""
                                }
                            }
                            .padding(10)
                            .cornerRadius(30)
                            .scrollContentBackground(.hidden)
                            .background(Color("mainWhite"))
                            .shadow(color: .gray, radius: 0.5)
                            .multilineTextAlignment(.center)
                            .lineLimit(5)
                            .frame(height: geometry.size.height *  0.28)
                            .focused($mostrarTeclado)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    
                                    Button("OK") {
                                        mostrarTeclado = false
                                    }
                                }
                            }
                        Button{
                            if(self.notes == "Agrega alguna nota..."){
                                notes = ""
                            }
                            
                            if symptom.cuantitativo {
                                if let cantidad = Float(metricsString) {
                                    registers.registers.append(Register(idSymptom: symptom.id, fecha: date, cantidad: cantidad, notas: notes))
                                    createRegister()
                                    dismiss()
                                }
                                else{
                                    isPresented = true
                                }
                            } else {
                                registers.registers.append(Register(idSymptom: symptom.id, fecha: date, cantidad: Float(metric), notas: notes))
                                createRegister()
                                dismiss()
                            }
                        }label:{
                            Label("Añadir información", systemImage: "cross.circle.fill")
                        }
                        .alert("Añade información", isPresented: $isPresented, actions: {})
                        .buttonStyle(Button1MedTracker(backgroundColor: Color(hex: symptom.color)))
                        .frame(height: geometry.size.height *  0.12)
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    //Spacer()
                    .navigationTitle("Agregar síntoma")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func createRegister() {
        // will wait until the createAction(symptom) finishes
        Task {
            do {
                try await createAction(registers.registers.last ?? Register(idSymptom: 0, fecha: Date.now, cantidad: 0, notas: "")) //call the function that adds the symptom to the database
            } catch {
                print("[NewPostForm] Cannot create post: \(error)")
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}


struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background((Color("mainWhite")))
            
        /*(LinearGradient(gradient: Gradient(colors: [Color.white, Color("blueGreen").opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))*/
            .cornerRadius(10)
            .frame(width: 150)
    }
}

struct RegistroDatos1_Previews: PreviewProvider {
    static var previews: some View {
        RegisterSymptomView(symptom: .constant(Symptom(id: 0, nombre: "Prueba", icon: "star.fill", description: "", cuantitativo: true, unidades: "", activo: true, color: "#007AF")), registers: RegisterList(), sliderValue: .constant(0.0), createAction: { _ in })
    }
}

/*
 NOTAS:
 No funciona bien el quitar el teclado
 Modos oscuros
 Vista de análisis se ve rara
 Hacer share con nombre de síntoma y sortearlo
 widgets
 cambiar pantalla de inicio por colores verdes/azules
 */
