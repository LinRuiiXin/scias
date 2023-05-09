//
//  Mode.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/5/8.
//

import Foundation
import SwiftUI

enum Attribute {
    case MutuallyExclusive;
    case Overlay
}

class Mode {
    
    typealias Setter = (inout [NSAttributedString.Key : Any]) -> ()
    
    let atrribute: Attribute
    let `default`: Bool
    let name: String
    let setter: Setter
    
    init(_ attribute: Attribute = .MutuallyExclusive, `default`: Bool = false, name: String = "", setter: @escaping Setter = {_ in }) {
        self.atrribute = attribute
        self.default = `default`
        self.name = name
        self.setter = setter
    }
    
}

class Modes {
    
    typealias Keys = NSAttributedString.Key
    
    static let Text = Mode(default: true, name: "Text", setter: { styles in
        
    })
    static let Normal = Mode(default: true, name: "Normal", setter: { styles in
        let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        styles[.font] = font
    })
    static let Title = Mode(name: "Title", setter: { styles in
        guard var font = styles[.font] as? UIFont else {
            return
        }
        let originalTraits = font.fontDescriptor.symbolicTraits
        let newTraits = originalTraits.union(.traitBold)
        let newDescriptor = font.fontDescriptor.withSymbolicTraits(newTraits)
        font = UIFont(descriptor: newDescriptor!, size: font.pointSize)
        if var fontStyles = styles[.font] as? [NSAttributedString.Key: UIFont] {
            fontStyles[.font] = font
            styles[.font] = fontStyles
        } else {
            styles[.font] = font
        }
    })
    static let Headline = Mode(name: "Headline", setter: { styles in
        
    })
    static let SubHeadline = Mode(name: "SubHeadline", setter: { styles in
        
    })
    static let Body = Mode(default: true, name: "Body", setter: { styles in
        
    })
    static let List = Mode(name: "List")
    static let DotList = Mode(name: "DotList")
    static let NumberList = Mode(name: "NumberList")
    static let NoneStyle = Mode(default: true, name: "NoneStyle", setter: { styles in
        
    })
    
    static let FontSize = Mode(.Overlay, default: true, name: "FontSize")
    static let Style = Mode(.Overlay, default: true, name: "Style")
    static let Bold = Mode(.Overlay, name: "Bold", setter: { styles in
        guard var font = styles[.font] as? UIFont else {
            return
        }
        let descriptor = font.fontDescriptor.withSymbolicTraits(.traitBold)
        font = UIFont(descriptor: descriptor!, size: font.pointSize)
        styles[.font] = font
    })
    static let Italics = Mode(.Overlay, name: "Italics", setter: { styles in
    })
    static let Underline = Mode(.Overlay, name: "Underline", setter: { styles in
        
    })
    static let Strikethrough = Mode(.Overlay, name: "Strikethrough", setter: { styles in
        
    })
    
}

class ModeRelation {
    
    typealias MR = ModeRelation
    
    let mode: Mode
    
    var childModes: [ModeRelation]
    
    init(_ mode: Mode, _ childModes: [ModeRelation] = []) {
        self.mode = mode
        self.childModes = childModes
    }
    
    func getParent(_ mode: Mode) -> MR? {
        if mode === ModeRelation.DEFAULT.mode {
            return nil
        }
        var queue = Queue<MR>()
        queue.enqueue(self)
        while let current = queue.dequeue() {
            for child in current.childModes {
                guard child.mode !== mode else {
                    return current
                }
                queue.enqueue(child)
            }
        }
        return nil
    }
    
    func find(_ mode: Mode) -> MR? {
        var queue = Queue<MR>()
        queue.enqueue(self)
        while let current = queue.dequeue() {
            guard current.mode !== mode else{
                return current
            }
            for child in current.childModes {
                queue.enqueue(child)
            }
        }
        return nil
    }
    
    typealias ModeCallback = (Mode) -> ()
    
    func bfs(_ callback: ModeCallback) {
        bfs(self, callback)
    }
    
    func bfs(_ mr: MR,_ callback: ModeCallback) {
        var queue = Queue<MR>()
        queue.enqueue(mr)
        while let current = queue.dequeue() {
            callback(current.mode)
            for child in current.childModes {
                queue.enqueue(child)
            }
        }
    }
    
    /// Text : [
    ///     Normal : [
    ///         Fontsize: [ Title, Headline, SubHeadline, Body]
    ///         Style : [ Bold, Italics, Underline, Strikethrough]
    ///     ]
    ///     List : [
    ///         DotList, NumberList
    ///     ]
    /// ]
    static let title = MR(Modes.Title)
    static let headline = MR(Modes.Headline)
    static let subHeadline = MR(Modes.SubHeadline)
    static let body = MR(Modes.Body)
    static let fontSize = MR(Modes.FontSize, [title, headline, subHeadline, body])
    
    static let noneStyle = MR(Modes.NoneStyle)
    static let bold = MR(Modes.Bold)
    static let italics = MR(Modes.Italics)
    static let underline = MR(Modes.Underline)
    static let strikethrough = MR(Modes.Strikethrough)
    static let style = MR(Modes.Style, [noneStyle, bold, italics, underline, strikethrough])
    
    static let normal = MR(Modes.Normal, [fontSize, style])
    
    static let dotList = MR(Modes.DotList)
    static let numberList = MR(Modes.NumberList)
    static let list = MR(Modes.List, [dotList, numberList])
    
    static let text = MR(Modes.Text, [normal, list])
    static let DEFAULT = text
    
}

class TypingMode: ModeRelation, ObservableObject {
    
    @Published var version = 0
    
    static let DF_RULES = ModeRelation.DEFAULT
    
    init(_ mode: Mode = DF_RULES.mode) {
        super.init(mode)
        buildWithDefault()
    }
    
    @discardableResult
    func set(_ mode: Mode) -> TypingMode {
        print("Set: \(mode.name)")
        if mode === TypingMode.DF_RULES.mode {
            buildWithDefault()
        }
        else {
            if let parentMode = TypingMode.DF_RULES.getParent(mode) {
                let targetParent = find(parentMode.mode)
                switch mode.atrribute {
                case .MutuallyExclusive:
                    targetParent?.childModes = [TypingMode(mode)]
                case .Overlay:
                    var newChildren = targetParent?.childModes.filter({$0.mode.atrribute == .Overlay}) ?? []
                    newChildren.append(TypingMode(mode))
                    targetParent?.childModes = newChildren
                }
                version += 1
            }
        }
        print("Updated Mode: ")
        bfs() { mode in
            print("\(mode.name) ", terminator: "")
        }
        print("")
        return self
    }
    
    func buildWithDefault() {
        TypingMode.DF_RULES.find(mode)?.childModes.filter({ $0.mode.default }).forEach({ defaultMode in
            print("BuildWithDefault: add mode: \(defaultMode.mode.name)")
            set(defaultMode.mode)
        })
    }
    
    func get() -> [NSAttributedString.Key : Any] {
        var typingStyles: [NSAttributedString.Key : Any] = [:]
        bfs() { mode in
            mode.setter(&typingStyles)
        }
        return typingStyles
    }
    
}

struct Queue<T> {
    private var elements: [T] = []
    
    // 入队
    mutating func enqueue(_ element: T) {
        elements.append(element)
    }
    
    // 出队
    mutating func dequeue() -> T? {
        if elements.isEmpty {
            return nil
        } else {
            return elements.removeFirst()
        }
    }
    
    // 获取队头元素
    func peek() -> T? {
        return elements.first
    }
    
    // 判断队列是否为空
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    // 获取队列的长度
    var count: Int {
        return elements.count
    }
    
}
