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
            Color("mainWhite")
                .ignoresSafeArea()
            VStack{
                Text("¡Bienvenido a MedTracker!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("blueGreen"))
                Button("Registrarse") {
                    muestraRegistro = true
                }
                .fullScreenCover(isPresented: $muestraRegistro, content: {
                    RegisterView()
                })
                .buttonStyle(Button1MedTracker())
                .padding()
                Button("Iniciar Sesión") {
                    muestraLogin = true
                }
                .fullScreenCover(isPresented: $muestraLogin, content: {
                    LogInView()
                })
                .buttonStyle(Button1MedTracker())
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
