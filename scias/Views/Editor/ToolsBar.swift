//
//  ToolsBar.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/5/6.
//

import SwiftUI

struct ToolsBar: View {
    
    struct ToolTab {
        let iconName: String
        let callback: ()->()
    }
    
    private let background = Color(
        red: 250,
        green: 250,
        blue: 250
    )
    
    var body: some View {
        let toolTabs = [
            ToolTab(iconName: "character", callback: onCharacter),
            ToolTab(iconName: "photo", callback: onPhoto),
            ToolTab(iconName: "plus", callback: onMore),
            ToolTab(iconName: "gear", callback: onSetup)
        ]
        ZStack {
            background
            HStack {
                Spacer()
                ForEach(toolTabs, id: \.iconName) { tab in
                    Button(action: tab.callback) {
                        Image(systemName: tab.iconName)
                    }
                    Spacer()
                }
            }
            .foregroundColor(.black)
        }
    }
    
    func onCharacter() {
        
    }
    
    func onPhoto() {
        
    }
    
    func onMore() {
        
    }
    
    func onSetup() {
        
    }
    
}

struct ToolsBar_Previews: PreviewProvider {
    static var previews: some View {
        ToolsBar()
    }
}
