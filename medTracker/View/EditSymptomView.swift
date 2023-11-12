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
    var listaDatos = [Symptom(id: 1, nombre: "Peso", description: "Este es un ejemplo de descripción que es bastante largo y se va haciendo mucho más largo para comprobar la funcionalidad.", cuantitativo: true, unidades: "kg", activo: true, color: ""),
                      Symptom(id: 2, nombre: "Cansancio", description: "Este es un ejemplo de descripción corto.", cuantitativo: false, unidades: "", activo: false, color: ""),
                      Symptom(id: 3, nombre: "Insomnio", description: "Este es un ejemplo de descripción mediano, es decir, con esto está bien.", cuantitativo: true, unidades: "", activo: false, color: ""),
                      Symptom(id: 4, nombre: "Estado cardíaco", description: "Latidos por minuto.", cuantitativo: true, unidades: "BPM", activo: false, color: "")]
    
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
