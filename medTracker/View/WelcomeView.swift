//
//  Bienvenida.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authentication: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 108/255, green: 171/255, blue: 219/255)
                    .ignoresSafeArea()
                VStack{
                    Text("¡Bienvenido a MedTracker!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    NavigationLink {
                        LogInView()
                    } label: {
                        Text("Iniciar Sesión")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 50)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    NavigationLink {
                        RegisterView(authentication: authentication.makeCreateAccountViewModel())
                    } label: {
                        Text("Registrarse")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 50)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                }
                
            }
        }
    }
}

struct Bienvenida_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
