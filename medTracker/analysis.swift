//
//  analysis.swift
//  bottomTabBar
//
//  Created by Alumno on 16/10/23.
//

import SwiftUI
import Charts

struct analysis: View {
    @State private var descripcion = "Este es un ejemplo de descripción que es bastante largo y se va haciendo mucho más largo para comprobar la funcionalidad."
    
    var sintomas = [DatosSalud(telefono: "1", nombre: "a", description: "a", unidades: 10.0, activo: true, color: Color.red), DatosSalud(telefono: "1", nombre: "b", description: "b", unidades: 10.0, activo: true, color: Color.blue), DatosSalud(telefono: "1", nombre: "c", description: "c", unidades: 10.0, activo: true, color: Color.yellow)]
    
    var registros = [Registrar(idSituacion: 0, telefono: "1", fecha: Date.now, cantidad: 3, notas: "Nota 1"), Registrar(idSituacion: 1, telefono: "1", fecha: Date.now.addingTimeInterval(86400), cantidad: 5, notas: "Nota 2"), Registrar(idSituacion: 2, telefono: "1", fecha: Date.now.addingTimeInterval(86400*2), cantidad: 10, notas: "Nota 3"), Registrar(idSituacion: 3, telefono: "1", fecha: Date.now.addingTimeInterval(86400*3), cantidad: 3, notas: "Nota 4"), Registrar(idSituacion: 4, telefono: "1", fecha: Date.now.addingTimeInterval(86400*4), cantidad: 5, notas: "Nota 5")]
    
    var body: some View {
        VStack {
            TabView {
                ForEach(sintomas, id: \.self) { sintoma in
                    VStack(alignment: .leading) {
                        Text(sintoma.nombre)
                            .foregroundColor(sintoma.color)
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, 30)
                        
                        Text("Descripción: ")
                            .font(.system(size: 24))
                            .padding(.top, 22)
                        
                        TextField("", text: $descripcion, axis : .vertical)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 18))
                            .lineSpacing(4)
                            .border(.black)
                            .padding(.trailing, 20)
                            .disabled(true)
                        
                        Text("Promedio Semanal: ")
                            .font(.system(size: 24))
                            .padding(.top, 100)
                        
                        Chart {
                            ForEach(registros, id:\.self) { registro in
                                BarMark(x: .value("DIA", registro.fecha.formatted(.dateTime.day().month())),
                                        y: .value("CANTIDAD", registro.cantidad))
                                    .cornerRadius(10)
                                    .annotation{
                                        Text(String(format: "%.0f", registro.cantidad))
                                    }
                            }
                        }
                        .frame(height: 300)
                        .foregroundStyle(sintoma.color)
                        .padding()
                        .shadow(radius: /*@START_MENU_TOKEN@*/6/*@END_MENU_TOKEN@*/)
                        .chartXAxisLabel("DIA", alignment: .topTrailing, spacing: 10)
                        .chartYAxisLabel("PRECIOS", spacing: 10)
                        .foregroundColor(.black)
                        .chartPlotStyle { plotContent in
                            plotContent
                                .background(.gray.opacity(0.1))
                                .border(Color.black, width: 2)
                        }
                        //Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, 20)
                    
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            Spacer(minLength: 50)
        }
        .background(Color("mainWhite"))
    }
}

struct analysis_Previews: PreviewProvider {
    static var previews: some View {
        analysis()
    }
}
