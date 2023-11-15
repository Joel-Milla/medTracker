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
                        HStack {
                            Text("Nuevo dato de salud")
                                .padding(.horizontal)
                            Button {
                                muestraNewSymptom = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        .padding(.vertical)
                        .font(.title2)
                        .sheet(isPresented: $muestraNewSymptom) {
                            AddSymptomView()
                        }

                        List {
                            Section(header: Text("Lista de datos de salud")) {
                                ForEach($listaDatos.symptoms.indices, id: \.self) { index in
                                    Toggle(listaDatos.symptoms[index].nombre, isOn: $isToggleOn[index])
                                }
                            }
                        }
                        .background(Color("mainGray"))
                        .font(.title3)
                        .navigationBarItems(trailing: Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .aspectRatio(contentMode: .fit)
                        })
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
