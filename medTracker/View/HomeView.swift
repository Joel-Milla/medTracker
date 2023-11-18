//
//  pagInicio.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct HomeView: View {
    @State var muestraEditarSintomas = false
    @ObservedObject var listaDatos : SymptomList
    @ObservedObject var registers : RegisterList
    
    var body: some View {
        NavigationStack {
        VStack {
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
            .navigationTitle("Datos de salud")
            .navigationBarItems(trailing:
                Button {
                muestraEditarSintomas = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            )
            .fullScreenCover(isPresented: $muestraEditarSintomas) {
                EditSymptomView(listaDatos: listaDatos)
            }
        }
        .background(Color("mainGray"))
        .ignoresSafeArea()
    }
}

struct pagInicio_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(listaDatos: SymptomList(), registers: RegisterList())
    }
}

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

