//
//  pagInicio.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct HomeView: View {
    @State var muestraEditarSintomas = false
    @StateObject var listaDatos = SymptomList()
    
    var body: some View {
        NavigationStack {
        VStack {
                List{
                    ForEach(listaDatos.symptoms.indices, id: \.self) { index in
                        
                        if listaDatos.symptoms[index].activo {
                            let symptom = listaDatos.symptoms[index]
                            NavigationLink{
                                RegisterSymptomView(symptom: $listaDatos.symptoms[index])
                            } label: {
                                Celda(unDato : symptom)
                            }
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
        HomeView()
    }
}

struct Celda: View {
    var unDato : Symptom

    var body: some View {
        HStack {
            //Poner aquí el ícono del dato:)
            VStack(alignment: .leading) {
                Text(unDato.nombre)
                    .font(.title3)
                
            }
        }
    }
}
