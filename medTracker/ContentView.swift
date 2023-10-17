//
//  ContentView.swift
//  bottomTabBar
//
//  Created by Alumno on 16/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentTab: Tab = .Inicio
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @Namespace var animation
    var body: some View {
        TabView (selection: $currentTab) {
            analysis()
                .tag(Tab.Analisis)
            VStack {
                Text("vista Inicio")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("bg").ignoresSafeArea())
                    //.tag(Tab.Inicio)
            }
            .background(Color.gray)
            .tag(Tab.Inicio)
            profile()
                .tag(Tab.Perfil)
        }
        .overlay(
            HStack (spacing: 0){
                ForEach(Tab.allCases, id :\.rawValue) { tab in
                    TabButton(tab: tab)
                }
                .padding(.vertical)
                .padding(.bottom, getSafeArea().bottom == 0 ? 5 :
                            (getSafeArea().bottom - 15))
                .background(Color.white)
            }
            ,
            alignment: .bottom
        ).ignoresSafeArea(.all, edges: .bottom)
    }
    
    func TabButton(tab: Tab) -> some View {
        GeometryReader { proxy in
            
            Button(action: {
                withAnimation(.spring()) {
                    currentTab = tab
                }
            }, label: {
                VStack(spacing: 0) {
                    Image(systemName: currentTab == tab ? tab.rawValue + ".fill" : tab.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(currentTab == tab ? .primary : .secondary)
                        .padding(currentTab == tab ? 15 : 0)
                        .background(
                            ZStack {
                                if currentTab == tab {
                                    MaterialEffect(style: .light)
                                        .clipShape(Circle())
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                    
                                    Text(tab.tabName).foregroundColor(.primary)
                                        .font(.footnote).padding(.top, 50)
                                }
                            }
                        )
                        .contentShape(Rectangle())
                        .offset(y: currentTab == tab ? -35 : 0)
                }
            })
        }
        .frame(height: 25)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Tab: String, CaseIterable {
    case Analisis = "checkmark.seal"
    case Inicio = "house"
    case Perfil = "person"
    
    var tabName : String {
        switch self {
        case .Analisis:
            return "Analisis"
        case .Inicio:
            return "Inicio"
        case .Perfil:
            return "Perfil"
        }
    }
}

extension View {
    func getSafeArea() -> UIEdgeInsets {
        guard let pantalla = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = pantalla.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}

struct MaterialEffect : UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
