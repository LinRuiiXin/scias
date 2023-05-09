//
//  RichTextEditor.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/5/6.
//

import SwiftUI
import Down

struct MarkdownEditor: UIViewRepresentable {
    
//    var attributedText = NSMutableAttributedString(attributedString: parseMarkdown("# Hello\n**HI**"))
    @State var attributedText = parseMarkdown("# Hello\n**HI**")
    
    var bold: Bool
    
    @ObservedObject var typingStyle: TypingMode
    
    private static func parseMarkdown(_ formattedString: String) -> NSAttributedString {
        let down = Down(markdownString: formattedString)
        return try! down.toAttributedString()
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
        let newStyle = typingStyle.get()
        print("update style: new style: \(newStyle.keys)")
        uiView.typingAttributes = newStyle
    }

    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
}

class Coordinator: NSObject, UITextViewDelegate {
    
    var parent: MarkdownEditor
    
    var textView: UITextView?
    
    init(_ parent: MarkdownEditor) {
        self.parent = parent
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textView = textView // Set the reference to the UITextView
    }
    
    func textViewDidChange(_ textView: UITextView) {
        parent.attributedText = textView.attributedText
    }
    
}

struct RichTextEditor: View {
    
    @State var bold = false
    
//    @State var typingStyle: [NSAttributedString.Key : Any] = [:]
    
    @ObservedObject var typingStyle = TypingMode(Modes.Text)
    
    var body: some View {
        let editor = MarkdownEditor(bold: bold, typingStyle: typingStyle)
        let stack = VStack {
            editor
            HStack {
                Spacer()
                Button(action: {
                    bold.toggle()
                }, label: {
                    Text("Title")
                })
                Spacer()
                Button(action: {
                    typingStyle.set(Modes.Bold)
                }, label: {
                    Text("bold")
                })
                Spacer()
                Button(action: {
                    typingStyle.set(Modes.Italics)
                }, label: {
                    Text("italics")
                })
                Spacer()
                Button(action: {
                    bold.toggle()
                }, label: {
                    Text("underline")
                })
                Spacer()
            }
        }
        return stack
    }
    
    
}

struct RichTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        RichTextEditor()
    }
}
