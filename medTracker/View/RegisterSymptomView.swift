//
//  RegistroDatos1.swift
//  medTracker
//
//  Created by Sebastian Presno Alvarado on 18/10/23.
//

import SwiftUI



struct RegisterSymptomView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var symptom : Symptom
    //@StateObject var symptom = Symptom()
    @State var metricsString = ""
    @State private var date = Date.now
    //@State var sliderOrTF : Bool = false
    @State var notes = "Agrega alguna nota..."
    var dummySymptom = "Migraña"
    @State var metric: Double = 0
    //@StateObject var symptom = Symptom()
    //let mainWhite = Color
    var body: some View {
        GeometryReader { geometry in
            NavigationStack(){
                ZStack {
                    Color("mainWhite").ignoresSafeArea()
                    VStack() {
                        Text(symptom.nombre)
                            .font(.title)
                            .foregroundStyle(Color("blueGreen"))
                            .bold()
                            .padding(.horizontal, -179)
                            .frame(height: geometry.size.height *  0.06)
                        DatePicker("Fecha registro", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .padding(.vertical,30)
                            .foregroundColor(Color("blueGreen")) // sale identico??
                            .tint(Color("blueGreen"))
                            .bold()
                        //Text("La fecha es \(date.formatted(date: .numeric, time: .shortened))")
                        if(!symptom.cuantitativo){
                            Text("¿Qué tanto malestar tienes?")
                                .font(.system(size: 18))
                                .foregroundStyle(Color("blueGreen"))
                                .bold()
                            CustomSlider(valueFinal: $metric)
                                .padding(.horizontal, 5)
                                .frame(height: geometry.size.height * 0.06)
                                .padding(.vertical)
                        }
                        else{
                            Text("Ingresa el valor")
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray, lineWidth: 0.5)
                                    .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                                    .frame(width: geometry.size.width * 0.63, height: geometry.size.height * 0.1)
                                
                                HStack {
                                    Image(systemName: "heart.text.square.fill")
                                        .foregroundColor(Color("blueGreen"))
                                        .font(.title)
                                    TextField("", text: $metricsString, prompt: Text("Valor").foregroundColor(.gray))
                                        .font(.title2)
                                    //                                    .overlay(
                                    //                                        Capsule(style: .continuous)
                                    //                                            .stroke(Color("blueGreen")
                                    //                                                    , style: StrokeStyle(lineWidth: 4, miterLimit: 100, dash: [0]))
                                    //                                    )
                                        .padding()
                                        .textFieldStyle(OvalTextFieldStyle())
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.leading)
                                        .keyboardType(.numberPad)
                                }
                                .padding()
                            }
                            //                            .overlay(
                            //                                RoundedRectangle(cornerRadius: 20)
                            //                                    .stroke(Color.gray, lineWidth: 0.5)
                            //                                .background(Color(""))
                            //                            )
                            
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
                            .shadow(color: .gray, radius: 2)
                            .multilineTextAlignment(.center)
                            .lineLimit(5)
                            .frame(height: geometry.size.height *  0.30)
                        Button{
                            if(self.notes == "Agrega alguna nota..."){
                                notes = ""
                            }
                            print("Done!")
                            dismiss()
                        }label:{
                            Label("Añadir información", systemImage: "cross.circle.fill")
                        }
                        .buttonStyle(Button1MedTracker())
                        .frame(height: geometry.size.height *  0.2)
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    Spacer()
                    .navigationTitle("Agregar síntoma")
                    .navigationBarTitleDisplayMode(.inline)
                }
                .toolbar{
                    Button{
                        dismiss()
                    }label:{
                        Text("Volver")
                    }
                }
            }
        }
    }
}


struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background((Color(.white)))
            
        /*(LinearGradient(gradient: Gradient(colors: [Color.white, Color("blueGreen").opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))*/
            .cornerRadius(10)
            .frame(width: 150)
    }
}


struct RegistroDatos1_Previews: PreviewProvider {
    static var previews: some View {
        RegisterSymptomView(symptom: .constant(Symptom(id: 0, nombre: "", description: "", cuantitativo: true, unidades: "", activo: true, color: "")))
    }
}

/*
 NOTAS:
Hay otra forma de hacer el slider (posicion)? no se si con todos los dispositivos quede asi de bien
 */
