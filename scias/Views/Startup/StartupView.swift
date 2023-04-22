//
//  StratupView.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/4/21.
//

import SwiftUI

struct StartupView: View {
    
    @Binding var finished: Bool
    
//    @State var finished: Bool
    
    private let backgroundGradient = Gradient(colors: [
        Color(red: 59/255, green: 133/255, blue: 255/255),
        Color(red: 95/255, green: 204/255, blue: 200/255)
    ])
    
    private let backgroundGradientTransparency = Gradient(colors: [
        Color(red: 255, green: 255, blue: 255, opacity: 0),
        Color(red: 255, green: 255, blue: 255, opacity: 0)
    ])
    
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    gradient: backgroundGradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                    .opacity(finished ? 0 : 1)
                    .animation(Animation.easeInOut(duration: 0.01).delay(0.7))
                Image("scias")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .scaleEffect(finished ? 0.5 : 1)
                    .animation(.easeInOut(duration: 0.3))
                    .scaleEffect(finished ? 90 : 0.5)
                    .offset(x: finished ? 40 : 0, y: finished ? 1800 : 0)
                    .animation(Animation.spring(dampingFraction: 1).speed(0.9).delay(0.3))
                    .opacity(finished ? 0 : 1)
                    .animation(Animation.easeInOut.delay(0.7))
//                    .onTapGesture{
//                        finished.toggle()
//                    }
                
            }
        }
        .ignoresSafeArea()
    }
}

struct StratupView_Previews: PreviewProvider {
    @State static var finished = false
    static var previews: some View {
        return StartupView(finished: $finished)
            .onTapGesture {
                finished.toggle()
            }
//        return StartupView(finished: false)
    }
}
