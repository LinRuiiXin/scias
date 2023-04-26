//
//  ContentView.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/4/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = Tab.HomePage
    
    @State var finished = false
    
    enum Tab {
        case HomePage
        case Follow
        case Create
        case Message
        case Mine
    }
    
    var body: some View {
        ZStack {
//            StartupView(finished: $finished)
//                .zIndex(1.0)
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        finished = true
//                    }
//                }
            TabView(selection: $selection) {
                HomePageTabView()
                    .tabItem { Image(systemName: "house") }
                    .tag(Tab.HomePage)

                FollowTabView()
                    .tabItem { Image(systemName: "checkmark.seal") }
                    .tag(Tab.Follow)

                CreateTabView()
                    .tabItem { Image(systemName: "wand.and.stars") }
                    .tag(Tab.Create)

                MessageTabView()
                    .tabItem { Image(systemName: "message") }
                    .tag(Tab.Message)

                MineTabView()
                    .tabItem { Image(systemName: "person") }
                    .tag(Tab.Mine)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
