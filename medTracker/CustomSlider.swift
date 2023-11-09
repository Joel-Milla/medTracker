//
//  TestSlider.swift
//  medTracker
//
//  Created by Sebastian Presno Alvarado on 07/11/23.
//

import Foundation
import SwiftUI

struct CustomSlider: View {
    @Binding var valueFinal: Double
    @State var lastCoordinateValue: CGFloat = 0
    @State var value : Double = 0
    var body: some View {
        GeometryReader { gr in
            let cursorSize = gr.size.height * 0.8
            let radius = gr.size.height * 0.5
            let minValue = 0.0
            let maxValue = gr.size.width * 0.9
            
            ZStack {
                RoundedRectangle (cornerRadius: radius)
                    .foregroundColor (getColor())
                HStack {
                    Circle()
                        .foregroundStyle(.white)
                        .frame (width: cursorSize, height: cursorSize)
                        .offset (x: self.value)
                        .gesture (
                            DragGesture (minimumDistance: 0)
                                .onChanged { v in
                                    if (abs(v.translation.width) < 0.1) {
                                        self.lastCoordinateValue = self.value
                                    }
                                    if v.translation.width > 0 {
                                        self.value = min (maxValue, self.lastCoordinateValue + v.translation.width)
                                    } else{
                                        self.value = max (minValue, self.lastCoordinateValue + v.translation.width)
                                        
                                    }
                                }
                        )
                    Image("happy_green")
                        .resizable()
                        .scaledToFit()
                        .offset(x:self.value - 50)
                        .gesture (
                            DragGesture (minimumDistance: 0)
                                .onChanged { v in
                                    if (abs(v.translation.width) < 0.1) {
                                        self.lastCoordinateValue = self.value
                                    }
                                    if v.translation.width > 0 {
                                        self.value = min (maxValue, self.lastCoordinateValue + v.translation.width)
                                        valueFinal = getValue(maxValue: maxValue)
                                    } else{
                                        self.value = max (minValue, self.lastCoordinateValue + v.translation.width)
                                        valueFinal = getValue(maxValue: maxValue)
                                    }
                                }
                        )
                    Text("\(valueFinal,  specifier: "%.2F")")
                    Spacer()
                }
            }
        }
    }
    func getColor()->Color{
        if(valueFinal < 30){
            return Color.green
        }
        else if(valueFinal >= 30 && valueFinal < 70){
            return Color.yellow
        }
        else if(valueFinal >= 70){
            return Color.red
        }
        else{
            return Color("mainBlue")
        }
    }
    func getValue(maxValue: Double)->Double{
       return(100 * value) / maxValue
    }
    func getImage()->String{
        if(valueFinal < 30){
            return ""
        }
        else if(valueFinal >= 30 && valueFinal < 70){
            return ""
        }
        else if(valueFinal >= 70){
            return ""
        }
        else{
            return ""
        }
    }

}
