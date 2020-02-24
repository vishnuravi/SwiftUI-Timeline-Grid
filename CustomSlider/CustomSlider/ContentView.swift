//
//  ContentView.swift
//  CustomSlider
//
//  Created by Vishnu Ravi on 1/29/20.
//  Copyright © 2020 Vishnu Ravi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let days = [Date().addingTimeInterval(-60 * 60 * 48),
                Date().addingTimeInterval(-60 * 60 * 24),
                Date(),
                Date().addingTimeInterval(60 * 60 * 24),
                Date().addingTimeInterval(60 * 60 * 48),
                Date().addingTimeInterval(60 * 60 * 72),
                Date().addingTimeInterval(60 * 60 * 96)]
    
    var body: some View{
        StorySliderGrid(days: days)
    }
}

struct StorySliderGrid: View {
    let days: [Date]
    @State var values: [Date: String] = [:]
    @State var comments: [Date: String] = [:]
    
    var body: some View{
        ZStack(){
            Group(){
                HStack(){
                    Text("NONE")
                        .font(.custom("AvenirNext-Regular", size: 12))
                        .foregroundColor((Color(red: 33/255, green: 61/255, blue: 153/255)))
                        .padding(.leading, 5)
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 325, height: 0.5)
                }
                
                HStack(){
                    Text("MILD")
                        .font(.custom("AvenirNext-Regular", size: 12))
                        .foregroundColor((Color(red: 33/255, green: 61/255, blue: 153/255)))
                        .padding(.leading, 5)
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 325, height: 0.5)
                }.offset(y: -100)
                
                
                HStack(){
                    Text("MODERATE")
                        .font(.custom("AvenirNext-Regular", size: 12))
                        .foregroundColor((Color(red: 33/255, green: 61/255, blue: 153/255)))
                        .padding(.leading, 5)
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 325, height: 0.5)
                }.offset(y: -200)
                
                
                HStack(){
                    Text("SEVERE")
                        .font(.custom("AvenirNext-Regular", size: 12))
                        .foregroundColor((Color(red: 33/255, green: 61/255, blue: 153/255)))
                        .padding(.leading, 5)
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 325, height: 0.5)
                }.offset(y: -300)
            }
            ScrollView(.horizontal, showsIndicators: false){
                HStack(){
                    ForEach(self.days, id: \.self){ day in
                        StoryDaySlider(values: self.$values, comments: self.$comments, day: day).padding(4)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .padding(.trailing, 50)
                .padding(.leading, 50)
                
            }
        }
        
    }
}

struct StoryDayModal: View {
    @Binding var comment: String
    @Binding var showModal: Bool
    let day: Date
    
    func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(){
            Text("What happened on \(dateString(date: self.day))?")
                .font(.custom("AvenirNext-Regular", size: 28))
                .padding(30)
            TextFieldWithLine(placeholder: "Type here", text: $comment)
                .padding(50)
            Spacer()
            Button(action: {
                self.showModal.toggle()
            }){
            Image(systemName: "arrow.right")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .padding()
                .background(Color(red: 33/255, green: 61/255, blue: 153/255))
                .cornerRadius(30)
            }
            Spacer()
        }
    }
}


struct StoryDaySlider: View {
    @Binding var values: [Date: String]
    @Binding var comments: [Date: String]
    @State var comment = ""
    @State private var position = CGSize(width: 0, height: 100)
    @GestureState private var dragOffset = CGSize.zero
    @GestureState private var isLongPressed = false
    @State private var buttonColor = Color.gray
    let day: Date
    @State private var showModal = false
    
    func updateSeverity(severity: String){
        self.values[self.day] = severity
    }
    
    func setPosition(position: String){
        switch position {
        case "severe":
            self.position.height = -300
            self.buttonColor = Color(UIColor(red:0.92, green:0.23, blue:0.35, alpha:1.0))
            self.updateSeverity(severity: "severe")
        case "moderate-severe":
            self.position.height = -250
            self.buttonColor = Color(UIColor(red:0.94, green:0.41, blue:0.30, alpha:1.0))
            self.updateSeverity(severity: "moderate-severe")
        case "moderate":
            self.position.height = -200
            self.buttonColor = Color(UIColor(red:0.96, green:0.53, blue:0.27, alpha:1.0))
            self.updateSeverity(severity: "moderate")
        case "mild-moderate":
            self.position.height = -150
            self.buttonColor = Color(UIColor(red:0.98, green:0.71, blue:0.22, alpha:1.0))
            self.updateSeverity(severity: "mild-moderate")
        case "mild":
            self.position.height = -100
            self.buttonColor = Color(UIColor(red:1.00, green:0.83, blue:0.19, alpha:1.0))
            self.updateSeverity(severity: "mild")
        case "none":
            self.position.height = 0
            self.buttonColor = Color(UIColor(red:0.73, green:0.86, blue:0.35, alpha:1.0))
            self.updateSeverity(severity: "none")
        default:
            self.position.height = 100
            self.buttonColor = Color.gray
            self.updateSeverity(severity: "null")
        }
        print("day: \(self.day), value: \(self.values[self.day]!)")
    }
    
    func getDayfromDate(date: Date) -> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let dayString = formatter.string(from: date)
        return Int(dayString) ?? 0
        
    }
    
    func getWeekdayfromDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date)
        return String(weekDay.prefix(3))
    }
    
    func getMonthfromDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
    
    func ordinalNumber(num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: num))!
    }
    
    var body: some View {
        ZStack(){
            Group(){
                Rectangle()
                    .fill(Color(UIColor.lightGray))
                    .frame(width: 1, height: 300)
                    .opacity(0.3)
                    .offset(y: -150)
                Rectangle()
                    .fill(Color(UIColor.lightGray))
                    .frame(width: 1, height: 100)
                    .opacity(0.3)
                    .offset(y: 50)
                Text(getMonthfromDate(date: self.day))
                    .font(.custom("AvenirNext-Regular", size: 18))
                    .foregroundColor((Color(red: 33/255, green: 61/255, blue: 153/255)))
                    .opacity(0.5)
                    .offset(y: 175)
                Text(getWeekdayfromDate(date: self.day))
                    .font(.custom("AvenirNext-Regular", size: 18))
                    .foregroundColor((Color(red: 33/255, green: 61/255, blue: 153/255)))
                    .offset(y: 150)
            }
            Group(){
                Button(action: {
                    self.setPosition(position: "none")
                }){
                    Circle()
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width:10, height: 10)
                }.offset(y: 0)
                
                Button(action: {
                    self.setPosition(position: "mild")
                }){
                    Circle().frame(width:15, height: 15).foregroundColor(Color(UIColor.lightGray)).opacity(0.5)
                }.offset(y: -100)
                
                Button(action: {
                    self.setPosition(position: "mild-moderate")
                }){
                    Circle().frame(width:10, height: 10).foregroundColor(Color(UIColor.lightGray)).opacity(0.5)
                }.offset(y: -150)
                
                Button(action: {
                    self.setPosition(position: "moderate")
                }){
                    Circle().frame(width:15, height: 15).foregroundColor(Color(UIColor.lightGray)).opacity(0.5)
                }.offset(y: -200)
                
                Button(action: {
                    self.setPosition(position: "moderate-severe")
                }){
                    Circle().frame(width:10, height: 10).foregroundColor(Color(UIColor.lightGray)).opacity(0.5)
                }.offset(y: -250)
                
                Button(action: {
                    self.setPosition(position: "severe")
                }){
                    Circle().frame(width:15, height: 15).foregroundColor(Color(UIColor.lightGray)).opacity(0.5)
                }.offset(y: -300)
            }
            Text(String(getDayfromDate(date: self.day)))
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white)
                .font(.custom("AvenirNext-Regular", size: 22))
                .background(
                    Circle()
                        .fill(self.buttonColor)
                            .overlay(
                              Circle()
                                .stroke(Color.blue, lineWidth: self.comment.isEmpty ? 0 : 3)
                                .opacity(0.8)
                            ))
                .padding(5)
                .offset(x: 0, y: self.position.height + self.dragOffset.height)
                .blur(radius: self.isLongPressed ? 2 : 0)
                .animation(.easeOut)
                .sheet(isPresented: $showModal){
                    StoryDayModal(comment: self.$comment, showModal: self.$showModal, day: self.day)
            }
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .updating($isLongPressed){ value, state, transaction in
                        state = value
                    }
                    .onEnded { _ in
                        self.showModal.toggle()
            })
                .gesture(
                    DragGesture()
                        .updating(self.$dragOffset, body: { (value, state, transaction) in
                            state = value.translation
                        })
                        .onEnded({ (value) in
                            let currentHeight = self.position.height + value.translation.height
                            
                            if(currentHeight < 50 && currentHeight >= -50){
                                self.setPosition(position: "none")
                            }else if(currentHeight < -50 && currentHeight >= -125){
                                self.setPosition(position: "mild")
                            }else if(currentHeight < -125 && currentHeight >= -175){
                                self.setPosition(position: "mild-moderate")
                            }else if(currentHeight < -175 && currentHeight >= -225){
                                self.setPosition(position: "moderate")
                            }else if(currentHeight < -225 && currentHeight >= -275){
                                self.setPosition(position: "moderate-severe")
                            }else if(currentHeight < -275 && currentHeight >= -400){
                                self.setPosition(position: "severe")
                            }else{
                                self.setPosition(position: "null")
                            }
                            
                        })
            )
        }
    }
}
