//
//  pagInicio.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var listaDatos : SymptomList
    @ObservedObject var registers : RegisterList
    @State private var muestraEditarSintomas = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Show the view based on symptomList state (loading, empty, withValues).
                switch listaDatos.state {
                    case .isLoading:
                        ProgressView()
                    case .isEmpty:
                        Text("No hay sintomas registrados")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding()
                        Text("Porfavor de agregar sintomas para poder empezar a registrar.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    case .complete:
                        List{
                            ForEach(listaDatos.symptoms.indices, id: \.self) { index in
                                if listaDatos.symptoms[index].activo {
                                    let symptom = listaDatos.symptoms[index]
                                    NavigationLink{
                                        RegisterSymptomView(symptom: $listaDatos.symptoms[index], registers: registers, createAction: registers.makeCreateAction())
                                    } label: {
                                        Celda(unDato : symptom)
                                    }
                                    .padding(10)
                                    
                                }
                            }
                        }
                }
            }
            .navigationTitle("Datos de salud")
            .toolbar {
                // Button to traverse to EditSymptomView.
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        muestraEditarSintomas = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }

                }
            }
            // Present full screen the EditSymptomView.
            .fullScreenCover(isPresented: $muestraEditarSintomas) {
                EditSymptomView(listaDatos: listaDatos)
            }
        }
        .background(Color("mainGray"))
        .ignoresSafeArea()
    }
}

// Struct to show the respective icon for each symptom.
struct Celda: View {
    var unDato : Symptom
    
    var body: some View {
        HStack {
            Image(systemName: unDato.icon)
                .foregroundColor(Color(hex: unDato.color))
            VStack(alignment: .leading) {
                Text(unDato.nombre)
                    .font(.title2)
                
            }
        }
    }
}

struct pagInicio_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(listaDatos: SymptomList(), registers: RegisterList())
    }
}

