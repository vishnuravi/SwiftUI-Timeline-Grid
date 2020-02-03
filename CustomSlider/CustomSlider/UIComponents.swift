//
//  UIComponents.swift
//  Story-Health-iOS-SwiftUI
//
//  Created by Vishnu Ravi on 11/28/19.
//  Copyright © 2019 Vishnu Ravi. All rights reserved.
//

import Foundation

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amountToShake: CGFloat = 10
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amountToShake * sin(animatableData * CGFloat(3) * .pi),
            y: 0))
    }
}

struct ProgressBar : View {
    @Binding var progress: CGFloat
    var width: CGFloat
    var height: CGFloat
    var barColor: Color?
    var bgColor: Color?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(self.bgColor ?? Color(red: 85/255, green: 198/255, blue: 212/255))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(self.barColor ?? Color(red: 33/255, green: 61/255, blue: 153/255))
                    .frame(width: self.progress*geometry.size.width, height: geometry.size.height)
            }
        }
            .frame(width: width, height: height)
    }

}

struct HorizontalLine: View {
    
    private var height: CGFloat
    private var color: Color?
    
   init(height: CGFloat = 1.0, color: Color){
        self.height = height
        self.color = color
    }
    
    var body: some View {
        Rectangle().frame(height: height, alignment: .bottom).foregroundColor(color)
    }
}

struct TextFieldWithLine: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private var text: Binding<String>
    private var placeholder: String
    private var isSecure: Bool
    private var lineHeight: CGFloat
    
    @State var passwordIcon: String = "eye.slash"
    @State var passwordHidden: Bool = true
    
    init(placeholder: String, text: Binding<String>, isSecure: Bool = false, lineHeight: CGFloat = CGFloat(0.5)) {
        self.placeholder = placeholder
        self.text = text
        self.isSecure = isSecure
        self.lineHeight = lineHeight
    }
    
    var body: some View {
        
        VStack {
            if(isSecure){
                HStack(){
                    if(self.passwordHidden){
                        SecureField(placeholder, text: text)
                    }else{
                        TextField(placeholder, text: text).autocapitalization(.none)
                    }
                    Button(action: {
                        self.passwordHidden.toggle()
                        if(self.passwordHidden){
                            self.passwordIcon = "eye.slash"
                        }else{
                            self.passwordIcon = "eye"
                        }
                    }){
                        Image(systemName: self.passwordIcon).padding(5)
                    }
                }
                HorizontalLine(height: lineHeight, color: (self.colorScheme == .light) ? Color.black : Color.white)
            }else{
                TextField(placeholder, text: text)
                HorizontalLine(height: lineHeight, color: (self.colorScheme == .light) ? Color.black : Color.white)
            }
        }.padding(.bottom, lineHeight)
    }
}
