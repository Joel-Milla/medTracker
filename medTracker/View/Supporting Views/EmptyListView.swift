//
//  EmptyListView.swift
//  medTracker
//
//  Created by Alumno on 20/11/23.
//

import SwiftUI

struct EmptyListView: View {
    let title: String
    let message: String
    var action: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Text(message)
            if let action = action {
                Button(action: action) {
                    Text("Agregar sintoma")
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                }
                .padding(.top)
            }
        }
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .padding()
    }
}


struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView(
            title: "Cannot Load Posts",
            message: "Something went wrong while loading posts. Please check your Internet connection.",
            action: {}
        )
        EmptyListView(
            title: "No Posts",
            message: "There aren’t any posts yet."
        )
    }
}
