//
//  RichTextEditorWrapper.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/5/6.
//

import SwiftUI
import UIKit
import TwitterTextEditor

struct RichTextEditorWrapper: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        var editor = TextEditorView()
        editor.placeholderText = "Hello"
        return editor
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
