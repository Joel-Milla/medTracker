//
//  Bienvenida.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct WelcomeView: View {
    @State var muestraLogin = false
    @State var muestraRegistro = false
    var body: some View {
        ZStack {
            Color(red: 108/255, green: 171/255, blue: 219/255)
                .ignoresSafeArea()
            VStack{
                Text("¡Bienvenido a MedTracker!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                Button("Registrarse") {
                    muestraRegistro = true
                }
                .fullScreenCover(isPresented: $muestraRegistro, content: {
                    RegisterView()
                })
                .buttonStyle(.borderedProminent)
                .padding()
                Button("Iniciar Sesión") {
                    muestraLogin = true
                }
                .fullScreenCover(isPresented: $muestraLogin, content: {
                    LogInView()
                })
                .buttonStyle(.borderedProminent)
                
            }
            
        }
        .toolbar(.hidden)
    }
}

struct Bienvenida_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
