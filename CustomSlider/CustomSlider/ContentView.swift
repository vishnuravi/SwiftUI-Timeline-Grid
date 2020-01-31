//
//  ContentView.swift
//  CustomSlider
//
//  Created by Vishnu Ravi on 1/29/20.
//  Copyright © 2020 Vishnu Ravi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View{
        StorySliderGrid(days: Array(1...5))
    }
}

struct StorySliderGrid: View {
    let days: [Int]
    @State var values: [Int: String] = [:]
    
    var body: some View{
        ZStack(){
            Group(){
                HStack(){
                    Text("Mild").font(.system(size: 12)).padding(.leading, 5)
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 325, height: 0.5)
                }.offset(y: -100)
                
                HStack(){
                    Text("Moderate").font(.system(size: 12)).padding(.leading, 5)
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 325, height: 0.5)
                }.offset(y: -200)
                
                HStack(){
                    Text("Severe").font(.system(size: 12)).padding(.leading, 5)
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 325, height: 0.5)
                }.offset(y: -300)
            }
            ScrollView(.horizontal, showsIndicators: false){
                HStack(){
                    ForEach(self.days, id: \.self){ day in
                        StoryDaySlider(values: self.$values, day: day).padding(10)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .padding(.trailing, 50)
                .padding(.leading, 50)
                
            }
        }
        
    }
}

struct StoryDaySlider: View {
    @Binding var values: [Int: String]
    @State private var position = CGSize.zero
    @GestureState private var dragOffset = CGSize.zero
    @State private var buttonColor = Color.gray
    let day: Int
    
    func updateSeverity(severity: String){
        self.values[self.day] = severity
    }
    
    var body: some View {
        ZStack(){
            Rectangle()
                .fill(Color.gray)
                .frame(width: 1, height: 300)
                .offset(y: -150)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            print("Tapped")
                    }
            )
            Text("\(self.day)")
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white)
                .background(Circle().fill(self.buttonColor))
                .padding(5)
                .offset(x: 0, y: self.position.height + self.dragOffset.height)
                .animation(.easeInOut)
                .gesture(
                    DragGesture()
                        .updating(self.$dragOffset, body: { (value, state, transaction) in
                            state = value.translation
                        })
                        .onEnded({ (value) in
                            let currentHeight = self.position.height + value.translation.height
                            
                            if(currentHeight < -50 && currentHeight >= -150){
                                self.position.height = -100
                                self.buttonColor = Color.yellow
                                self.updateSeverity(severity: "mild")
                            }else if(currentHeight < -150 && currentHeight >= -250){
                                self.position.height = -200
                                self.buttonColor = Color.orange
                                self.updateSeverity(severity: "moderate")
                            }else if(currentHeight < -250 && currentHeight >= -350){
                                self.position.height = -300
                                self.buttonColor = Color.red
                                self.updateSeverity(severity: "severe")
                            }else{
                                self.position.height = 0
                                self.buttonColor = Color.gray
                                self.updateSeverity(severity: "none")
                            }
                            
                            print("day: \(self.day), value: \(self.values[self.day]!)")
                        })
            )
        }
    }
}
