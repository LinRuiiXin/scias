//
//  StratupView.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/4/21.
//

import SwiftUI

struct StartupView: View {
    
    //    @Binding var finished: Bool
    
    @State var finished: Bool = false
    
    private let backgroundGradient = Gradient(colors: [
        Color(red: 59/255, green: 133/255, blue: 255/255),
        Color(red: 95/255, green: 204/255, blue: 200/255)
    ])
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: backgroundGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            ZStack {
                Color.white.zIndex(1)
                    .opacity(finished ? 0 : 1)
                    .animation(Animation.easeInOut(duration: 0.1).delay(0.2))
                TabsView(finished: $finished)
                    
            }
            .mask(
                LogoPath()
                    .scaleEffect(finished ? 0.8 : 1)
                    .animation(Animation.easeInOut(duration: 0.2))
                    .scaleEffect(finished ? 160 : 0.8)
//                    .transition(.slide)
                    .animation(Animation.spring(dampingFraction: 1.2).speed(1).delay(0.2))
                    .offset(x:finished ? 80 : 0, y: finished ? 2200 : 0)
                    .animation(Animation.easeInOut.delay(0.2))
            )
            
        }
        .ignoresSafeArea()
    }
    
}

//struct StratupView_Previews: PreviewProvider {
//    @State static var finished = false
//    static var previews: some View {
//        return StartupView(finished: $finished)
//    }
//}

struct StratupView_Previews: PreviewProvider {
    static var previews: some View {
        return StartupView()
    }
}
