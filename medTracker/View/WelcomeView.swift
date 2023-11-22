//
//  Bienvenida.swift
//  medTracker
//
//  Created by Alumno on 09/11/23.
//

import SwiftUI

/**********************
 This view only displays a welcome message and two buttons to log in or register.
 **********************************/
struct WelcomeView: View {
    @EnvironmentObject var authentication: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack{
                    Image("logoV")
                        .resizable()
                        .imageScale(.small)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 250)
                    Text("¡Bienvenido a MedTracker!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(red: 28/255, green: 32/255, blue: 19/255))
                    NavigationLink {
                        LogInView()
                    } label: {
                        Text("Iniciar Sesión")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 50)
                            .background(LinearGradient(gradient: Gradient(colors: [Color("mainBlue"), Color("blueGreen")]), startPoint: .leading, endPoint: .trailing))
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
                            .background(LinearGradient(gradient: Gradient(colors: [Color("mainBlue"), Color("blueGreen")]), startPoint: .leading, endPoint: .trailing))
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
