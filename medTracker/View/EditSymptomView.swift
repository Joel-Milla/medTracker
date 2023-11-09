//
//  editarLista.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct EditSymptomView: View {
    @State var sintomaOn : Bool = true
    var listaDatos = [Symptom(telefono: "1", nombre: "a", description: "a", unidades: 10.0, activo: true, color: Color.red), Symptom(telefono: "1", nombre: "b", description: "b", unidades: 10.0, activo: true, color: Color.blue), Symptom(telefono: "1", nombre: "c", description: "c", unidades: 10.0, activo: true, color: Color.yellow)]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Text("Nuevo dato de salud")
                    Button{
                        
                    }label: {
                        Image(systemName: "plus")
                    }
                }
                Section(header: Text("Lista de datos de salud")) {
                    /*List{
                        ForEach(ListaDatosSalud.datosSalud){ dato in
                            Toggle(datoSalud: dato, isOn: $sintomaOn)
                            
                        }
                    }*/ //aquí intento ya que se pongan cosas de la lista directamente
                    Toggle("Síntoma 1", isOn: $sintomaOn) //Dummy
                        .padding(.horizontal)
                }
            }
            
        }
    }
}

struct editarLista_Previews: PreviewProvider {
    static var previews: some View {
        EditSymptomView()
    }
}
