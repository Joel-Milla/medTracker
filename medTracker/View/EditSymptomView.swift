//
//  editarLista.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct EditSymptomView: View {
    @State private var refreshID = UUID()
    @State var muestraNewSymptom = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var listaDatos: SymptomList
    
    var body: some View {
        NavigationView {
            VStack {
                if listaDatos.symptoms.isEmpty {
                    EmptyListView(
                        title: "No hay sintomas registrados",
                        message: "Porfavor de agregar sintomas para poder empezar a registrar."
                    )
                }
                else {
                    List {
                        Section(header: Text("Lista de datos de salud")) {
                            ForEach(listaDatos.symptoms.indices, id: \.self) { index in
                                Toggle(listaDatos.symptoms[index].nombre, isOn: $listaDatos.symptoms[index].activo)
                            }
                        }
                    }
                    .id(refreshID)
                    .font(.title3)
                    .navigationTitle("Edita tus datos de salud")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                        Text("Regresar")
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        muestraNewSymptom = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $muestraNewSymptom) {
                AddSymptomView(symptoms: listaDatos, createAction: listaDatos.makeCreateAction())
                    .onChange(of: listaDatos.symptoms) { _ in
                        refreshID = UUID()
                    }
            }
        }
    }
}



struct editarLista_Previews: PreviewProvider {
    static var previews: some View {
        EditSymptomView(listaDatos: SymptomList())
    }
}
