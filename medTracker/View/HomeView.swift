//
//  pagInicio.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct HomeView: View {
    @State var muestraEditarSintomas = false
    var listaDatos = [Symptom(id: 1, nombre: "Peso", description: "Este es un ejemplo de descripción que es bastante largo y se va haciendo mucho más largo para comprobar la funcionalidad.", cuantitativo: true, unidades: "kg", activo: true, color: ""),
                      Symptom(id: 2, nombre: "Cansancio", description: "Este es un ejemplo de descripción corto.", cuantitativo: false, unidades: "", activo: false, color: ""),
                      Symptom(id: 3, nombre: "Insomnio", description: "Este es un ejemplo de descripción mediano, es decir, con esto está bien.", cuantitativo: true, unidades: "", activo: false, color: ""),
                      Symptom(id: 4, nombre: "Estado cardíaco", description: "Latidos por minuto.", cuantitativo: true, unidades: "BPM", activo: false, color: "")]
    
    var body: some View {
        VStack {
            HStack {
                Text("Síntomas")
                    .font(.largeTitle)
                Button {
                    muestraEditarSintomas = true
                } label: {
                    VStack {
                        Image(systemName: "pencil")
                            .aspectRatio(contentMode: .fit)
                        Text("Editar")
                    }
                }
                .fullScreenCover(isPresented: $muestraEditarSintomas) {
                    EditSymptomView()
                }
                .padding()
            }
            NavigationView {
                List{
                    ForEach(listaDatos, id: \.self){ dato in
                        NavigationLink{
                            //VistaRegistrar(undato: dato)
                        } label: {
                            Celda(unDato : dato)
                        }
                        
                    }
                }
    
            }
            
        }
        .padding()
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
