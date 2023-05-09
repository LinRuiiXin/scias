//
//  Example.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/5/9.
//

import SwiftUI

class A: ObservableObject {
    @Published var a: [Int] = []
}

class B: A {
    func b() {
        a = [1]
    }
}

struct C: UIViewRepresentable {
    
    @ObservedObject var b: B
    
    func makeUIView(context: Context) -> UITextView {
        return UITextView()
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        print("update")
    }
    
}

struct Example: View {
    @ObservedObject var b = B()
    var body: some View {
        VStack {
            C(b: b)
            Button(action: {
                b.b()
            }, label: {
                Text("click")
            })
        }
    }
}

struct Example_Previews: PreviewProvider {
    static var previews: some View {
        Example(b: B())
    }
}
