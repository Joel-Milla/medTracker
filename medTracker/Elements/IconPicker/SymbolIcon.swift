//
//  SwiftUIView.swift
//
//
//  Created by Alessio Rubicini on 22/10/23.
//

import SwiftUI

struct SymbolIcon: View {
    
    let icon: String
    @Binding var selection: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 25))
            .animation(.linear)
            .foregroundColor(self.selection == icon ? Color.accentColor : Color.primary)
            .onTapGesture {
                
                // Assign binding value
                withAnimation {
                    self.selection = icon
                }
            }
    }
    
}

struct symbolIcon_Previews: PreviewProvider {
    static var previews: some View {
        SymbolIcon(icon: "pill", selection: .constant("star.bubble"))
    }
}

