//
//  pagInicio.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct pagInicio: View {
    @State var muestraEditarSintomas = false
    var listaDatos = [DatosSalud(telefono: "1", nombre: "a", description: "a", unidades: 10.0, activo: true, color: Color.red), DatosSalud(telefono: "1", nombre: "b", description: "b", unidades: 10.0, activo: true, color: Color.blue), DatosSalud(telefono: "1", nombre: "c", description: "c", unidades: 10.0, activo: true, color: Color.yellow)]
    
    var body: some View {
        VStack {
            HStack {
                Text("Síntomas")
                    .font(.largeTitle)
                Button {
                    muestraEditarSintomas = true
                    //este botón te va a llevar a la vista de toggle de síntomas
                } label: {
                    VStack {
                        Image(systemName: "pencil")
                            .aspectRatio(contentMode: .fit)
                        Text("Editar")
                    }
                }
                .sheet(isPresented: $muestraEditarSintomas) {
                    editarLista()
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
        pagInicio()
    }
}

struct Celda: View {
    var unDato : DatosSalud

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
