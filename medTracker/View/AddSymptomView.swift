//
//  newSymptom.swift
//  medTracker
//
//  Created by Alumno on 26/10/23.
//

import SwiftUI
import SegmentedPicker

struct AddSymptomView: View {
    @Environment(\.dismiss) var dismiss
    @State var nombreSintoma = ""
    @State var descripcion = ""
    @State private var colorSymptom = Color.blue
    @State private var colorString = ""
    @State var notificaciones = false
    @State private var icon = "star.fill"
    @State private var isPresented = false
    @State var selectedIndex: Int?
    var cada_cuanto = ["Todos los días", "Cada semana", "Una vez al mes"]
    @State var notificaciones_seleccion = "Todos los días"
    @ObservedObject var symptoms : SymptomList
    @State private var selectedFrequency: String = "Todos los días" {
        didSet {
            if notificaciones {
                scheduleNotification(frecuencia: selectedFrequency)
            }
        }
    }
    
    typealias CreateAction = (Symptom) async throws -> Void
    let createAction: CreateAction
    
    var body: some View {
        NavigationStack {
            ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    TextField("Nombre síntoma", text: $nombreSintoma)
                        .font(.system(size: 28))
                        .foregroundColor(colorSymptom)
                        .submitLabel(.done)
                    
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: icon).font(.title)
                            .foregroundColor(colorSymptom)
                    }
                    .sheet(isPresented: $isPresented, content: {
                        SymbolsPicker(selection: $icon, title: "Choose your symbol", autoDismiss: true)
                    }).padding()
                    
                    ColorPicker("", selection: $colorSymptom)
                        .labelsHidden()
                        .padding(.trailing, 20)
                }
                .padding(.top, 20)
                
                Text("Descripción")
                    .font(.system(size: 24))
                    .padding(.top, 22)
                
                TextField("Escriba la descripción del síntoma", text: $descripcion)//, axis : .vertical)
                    .font(.system(size: 18))
                    .textFieldStyle(.roundedBorder)
                    .lineSpacing(4)
                    .padding(.trailing, 20)
                    .foregroundColor(colorSymptom)
                    .disableAutocorrection(true)
                    .submitLabel(.done)
                
                Text("Tipo")
                    .font(.system(size: 24))
                    .padding(.top, 40)
                
                HStack {
                    Spacer()
                    SegmentedPicker(
                        ["Cuantitativo", "Cualitativo"],
                        selectedIndex: Binding(
                            get: { selectedIndex },
                            set: { selectedIndex = $0 }),
                        content: { item, isSelected in
                            Text(item)
                                .foregroundColor(isSelected ? Color.white : Color.black )
                                .padding(.horizontal, 40)
                                .padding(.vertical, 8)
                            
                        },
                        selection: {
                            Capsule()
                                .fill(colorSymptom)
                        })
                    .onAppear {
                        selectedIndex = 0
                    }
                    .animation(.easeInOut(duration: 0.3))
                    Spacer()
                }
                .padding(.trailing, 20)
                .frame(height: 50)
                
                Toggle("Recibir notificaciones", isOn: $notificaciones)
                    .tint(colorSymptom)
                    .padding(.trailing, 20)
                    .padding(.top, 40)
                    .font(.system(size: 24))
                
                Picker("Quiero recibirlas:", selection: $selectedFrequency) {
                    ForEach(cada_cuanto, id: \.self) {
                        Text($0)
                        //.foregroundColor(notificaciones ? colorSymptom : Color.gray)
                    }
                }
                .pickerStyle(.navigationLink)
                .disabled(!notificaciones ? true : false)
                .foregroundColor(notificaciones ? colorSymptom : Color.gray)
                .padding(.trailing, 20)
                .font(.system(size: 18))
                .onChange(of: selectedFrequency) { newFrequency in
                    if notificaciones {
                        scheduleNotification(frecuencia: newFrequency)
                    }
                }
                
                HStack {
                    Spacer()
                    Button {
                        if nombreSintoma != "" &&
                            descripcion != "" &&
                            selectedIndex == 0 || selectedIndex == 1 {
                            let newID = symptoms.symptoms.generateUniqueID()
                            let cuantitativo = selectedIndex == 0 ? true : false
                            symptoms.symptoms.append(Symptom(id: newID, nombre: nombreSintoma, icon: icon, description: descripcion, cuantitativo: cuantitativo, unidades: "", activo: true, color: colorString))
                            createSymptom()
                            dismiss()
                        }
                    } label: {
                        Label("Añadir síntoma", systemImage: "cross.circle.fill")
                    }
                    .buttonStyle(Button1MedTracker(backgroundColor: colorSymptom))
                    .padding(.top, 50)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.leading, 20)
            .navigationBarTitle("Nuevo síntoma")
            .ignoresSafeArea(.keyboard)
        }
        }
        .onAppear {
            // Initialize hexString with the initial color
            colorString = hexString(from: colorSymptom)
            selectedIndex
        }
        .onChange(of: colorSymptom) { newColor in
            // Update hexString when the color changes
            colorString = hexString(from: newColor)
        }
        .background(Color("mainWhite"))
    }
        
    
    private func createSymptom() {
        // will wait until the createAction(symptom) finishes
        Task {
            do {
                try await createAction(symptoms.symptoms.last ?? Symptom(id: 0, nombre: "", icon: "", description: "", cuantitativo: true, unidades: "", activo: true, color: "")) //call the function that adds the symptom to the database
            } catch {
                print("[NewPostForm] Cannot create post: \(error)")
            }
        }
    }
    
    func scheduleNotification(frecuencia: String) {
        let content = UNMutableNotificationContent()
        content.title = "Recordatorio de MedTracker "
        content.subtitle = "Es hora de registrar \(nombreSintoma)"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        switch frecuencia {
            case "Todos los días":
                dateComponents.hour = 17
                dateComponents.minute = 02
            case "Cada semana":
                dateComponents.weekday = 4
                dateComponents.hour = 17
                dateComponents.minute = 02
            case "Una vez al mes":
                dateComponents.day = 22
                dateComponents.hour = 16
                dateComponents.minute = 43
            default:
                break
            }

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully!")
            }
        }
    }
    
    func hexString(from color: Color) -> String {
            // Convert SwiftUI Color to UIColor
            let uiColor = UIColor(color)

            // Get the RGBA components
            guard let components = uiColor.cgColor.components else {
                return ""
            }

            let red = Float(components[0])
            let green = Float(components[1])
            let blue = Float(components[2])

            // Convert the components to HEX
            let hexString = String(
                format: "#%02lX%02lX%02lX",
                lroundf(red * 255),
                lroundf(green * 255),
                lroundf(blue * 255)
            )

            return hexString
    }
}

extension Array where Element == Symptom {
    func generateUniqueID() -> Int {
        if let maxID = self.max(by: { $0.id < $1.id }) {
            return maxID.id + 1
        } else {
            return 1 // If the array is empty, start with ID 1
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct newSymptom_Previews: PreviewProvider {
    static var previews: some View {
        AddSymptomView(symptoms: SymptomList(), createAction: { _ in })
    }
}
