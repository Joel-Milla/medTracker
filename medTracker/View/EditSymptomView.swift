//
//  editarLista.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct EditSymptomView: View {
    @State var muestraNewSymptom = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject var listaDatos = SymptomList()
    
    @State private var isToggleOn: [Bool] = []

        init() {
            _isToggleOn = State(initialValue: Array(repeating: true, count: listaDatos.symptoms.count))
        }

    var body: some View {
            NavigationView {
                    VStack {
                        List {
                            Section(header: Text("Lista de datos de salud")) {
                                ForEach($listaDatos.symptoms.indices, id: \.self) { index in
                                    Toggle(listaDatos.symptoms[index].nombre, isOn: $isToggleOn[index])
                                }
                            }
                        }
                        .background(Color("mainGray"))
                        .font(.title3)
                        .navigationBarItems(leading: Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                            Text("Regresar")
                        })
                        .navigationBarItems(trailing:
                            Button {
                                muestraNewSymptom = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        )
                        .sheet(isPresented: $muestraNewSymptom) {
                            AddSymptomView()
                        }
                        .navigationTitle("Edita tus datos de salud")
                    }
                    .background(Color("mainGray"))
              
            }
        
    }
}


struct editarLista_Previews: PreviewProvider {
    static var previews: some View {
        EditSymptomView()
    }
}
