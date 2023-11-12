//
//  RegistroDatos1.swift
//  medTracker
//
//  Created by Sebastian Presno Alvarado on 18/10/23.
//

import SwiftUI


//usar contentview??
//cambiar color de contenttitle?

struct RegisterSymptomView: View {
    @Environment(\.dismiss) var dismiss
    @State var metricsString = ""
    @State private var date = Date.now
    @State var sliderOrTF : Bool = true
    @State var notes = "Agrega alguna nota..."
    var dummySymptom = "Migraña"
    @State var metric: Double = 0
    //let mainWhite = Color
    var body: some View {
        GeometryReader { geometry in
            NavigationStack(){
                ZStack {
                    Color("mainWhite").ignoresSafeArea()
                    VStack() {
                        Text(dummySymptom)
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
                        if(sliderOrTF){
                            Text("Califica cómo te sientes")
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
                            HStack {
                                Image(systemName: "heart.text.square.fill")
                                    .foregroundColor(Color("blueGreen"))
                                    .font(.title2)
                                TextField("", text: $metricsString, prompt: Text("Valor").foregroundColor(.white))
                                        .padding()
                                    .textFieldStyle(OvalTextFieldStyle())
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                            }
                            .padding(.horizontal)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                                .background(Color(""))
                            )

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
            .background(Color("blueGreen").opacity(0.5))
        /*(LinearGradient(gradient: Gradient(colors: [Color.white, Color("blueGreen").opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))*/
            .cornerRadius(10)
            .frame(width: 150)
    }
}


struct RegistroDatos1_Previews: PreviewProvider {
    static var previews: some View {
        RegisterSymptomView()
    }
}

/*
 NOTAS:
 COMO CAMBIAR SLIDER THUMBNAIL
 QUE ES INIT??
 pongo dos imagenes en los extremos de la barra?
 QUE PONGO DE BOTON?
 HAY FORMA DE CAMBIAR EL COLOR DEL PICKER DE FECHA?
 AÑADIR LISTA DE UNIDADES
 HACER CLASES
 MEJORAR SISTEMA DE NOTAS, NO PUEDO HACER MAS GRANDE EL TEXTFIELD??
 Siento que hay mucho espacio
 Mejor tipo de animacion... usar sheet? o cambiar con transicion
 Investigar elementos interesantes
 Hacer otra vista para agregar notas??
 Agregar gradient
 */
