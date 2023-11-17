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
    @ObservedObject var listaDatos: SymptomList

    var body: some View {
            NavigationView {
                    VStack {
                        List {
                            Section(header: Text("Lista de datos de salud")) {
                                ForEach(listaDatos.symptoms.indices, id: \.self) { index in
                                    Toggle(listaDatos.symptoms[index].nombre, isOn: $listaDatos.symptoms[index].activo)
                                    //listaDatos.symptoms[index].activo = true
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
        EditSymptomView(listaDatos: SymptomList())
    }
}
