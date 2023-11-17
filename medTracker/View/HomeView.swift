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
                    ForEach($listaDatos.symptoms, id: \.self){ $dato in
                        NavigationLink{
                            RegisterSymptomView(symptom: $dato)
                        } label: {
                            Celda(unDato : dato)
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
            .sheet(isPresented: $muestraEditarSintomas) {
                AddSymptomView()
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
