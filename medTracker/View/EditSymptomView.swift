//
//  editarLista.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

/**********************
 This view edits the symptoms that are being tracked.
 **********************************/
struct EditSymptomView: View {
    @State private var refreshID = UUID() //Serves to force the view to update
    @State var muestraAddSymptomView = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var listaDatos: SymptomList
    
    var body: some View {
        NavigationView {
            VStack {
                // Show a view with a message indicating the user that there are no symptoms being checked.
                if listaDatos.symptoms.isEmpty {
                    EmptyListView(
                        title: "No hay sintomas registrados",
                        message: "Porfavor de agregar sintomas para poder empezar a registrar.",
                        nameButton: "Agregar Sintoma",
                        action: { muestraAddSymptomView = true }
                    )
                }
                // If there are symptoms, then show them on a list.
                else {
                    List {
                        Section(header: Text("Lista de datos de salud")) {
                            ForEach(listaDatos.symptoms.indices, id: \.self) { index in
                                Toggle(listaDatos.symptoms[index].nombre, isOn: $listaDatos.symptoms[index].activo)
                            }
                        }
                    }
                    .id(refreshID)  // Force the view to update
                    .font(.title3)
                    .navigationTitle("Edita tus datos de salud")
                }
            }
            .toolbar {
                // Shows the back button to homeView
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                        Text("Regresar")
                    })
                }
                // Button to add a new symptom.
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        muestraAddSymptomView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $muestraAddSymptomView) {
                AddSymptomView(symptoms: listaDatos, createAction: listaDatos.makeCreateAction())
                    .onChange(of: listaDatos.symptoms) { _ in
                        refreshID = UUID() //Refresh the id to force the view to update.
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
