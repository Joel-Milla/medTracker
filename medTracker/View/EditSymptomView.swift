//
//  editarLista.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct EditSymptomView: View {
    @State var sintomaOn : Bool = true
    @State var muestraNewSymptom = false
    @Environment(\.presentationMode) var presentationMode
    var listaDatos = [Symptom(telefono: "1", nombre: "a", description: "a", unidades: 10.0, activo: true, color: Color.red), Symptom(telefono: "1", nombre: "b", description: "b", unidades: 10.0, activo: true, color: Color.blue), Symptom(telefono: "1", nombre: "c", description: "c", unidades: 10.0, activo: true, color: Color.yellow)]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Text("Nuevo dato de salud")
                    Button{
                        muestraNewSymptom = true
                    }label: {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $muestraNewSymptom) {
                    AddSymptomView()
                }
                
                Section(header: Text("Lista de datos de salud")) {
                    List{
                        ForEach(listaDatos, id: \.self){ dato in
                            Toggle(dato.nombre, isOn: $sintomaOn)
                            
                        }
                    }
                   
                }
                .navigationBarItems(trailing: Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.primary)
                            })
            }
            
        }
    }
}

struct editarLista_Previews: PreviewProvider {
    static var previews: some View {
        EditSymptomView()
    }
}
