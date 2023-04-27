//
//  TabsView.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/4/26.
//

import SwiftUI

struct TabsView: View {
    
    @State private var selection = Tab.HomePage
    
    @Binding var finished: Bool
    
    enum Tab {
        case HomePage
        case Follow
        case Create
        case Message
        case Mine
    }
    
    var body: some View {
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
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                finished = true
            })
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    @State static var finished = false
    static var previews: some View {
        TabsView(finished: $finished)
    }
}
