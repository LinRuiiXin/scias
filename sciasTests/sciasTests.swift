//
//  sciasTests.swift
//  sciasTests
//
//  Created by 林瑞鑫 on 2023/5/9.
//

import XCTest

final class sciasTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

import Foundation

enum Attribute {
    case MutuallyExclusive;
    case Overlay
}

class Mode {
    
    let atrribute: Attribute
    let `default`: Bool
    
    init(_ attribute: Attribute = .MutuallyExclusive, `default`: Bool = false) {
        self.atrribute = attribute
        self.default = `default`
    }
    
}

class Modes {
    
    static let Text = Mode(default: true)
    static let Normal = Mode(default: true)
    static let Title = Mode()
    static let Headline = Mode()
    static let SubHeadline = Mode()
    static let Body = Mode(default: true)
    static let List = Mode()
    static let DotList = Mode()
    static let NumberList = Mode()
    
    static let FontSize = Mode(.Overlay, default: true)
    static let Style = Mode(.Overlay, default: true)
    static let Bold = Mode(.Overlay)
    static let Italics = Mode(.Overlay)
    static let Underline = Mode(.Overlay)
    static let Strikethrough = Mode(.Overlay)
    
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
    
    static let bold = MR(Modes.Bold)
    static let italics = MR(Modes.Italics)
    static let underline = MR(Modes.Underline)
    static let strikethrough = MR(Modes.Strikethrough)
    static let style = MR(Modes.Style, [bold, italics, underline, strikethrough])
    
    static let normal = MR(Modes.Normal, [fontSize, style])
    
    static let dotList = MR(Modes.DotList)
    static let numberList = MR(Modes.NumberList)
    static let list = MR(Modes.List, [dotList, numberList])
    
    static let text = MR(Modes.Text, [normal, list])
    static let DEFAULT = text
    
}

class TypingMode: ModeRelation {
    
    static let DF_RULES = ModeRelation.DEFAULT
    
    init(_ mode: Mode = DF_RULES.mode) {
        super.init(TypingMode.DF_RULES.mode)
        buildWithDefault()
    }
    
    func set(_ mode: Mode) -> TypingMode {
        if mode === TypingMode.DF_RULES.mode {
            buildWithDefault()
        }
        else {
            if let parentMode = getParent(mode) {
                let targetParent = find(parentMode.mode)
                switch mode.atrribute {
                case .MutuallyExclusive:
                    targetParent?.childModes = [TypingMode(mode)]
                case .Overlay:
                    var newChildren = targetParent?.childModes.filter({$0.mode.atrribute == .Overlay}) ?? []
                    newChildren.append(TypingMode(mode))
                    targetParent?.childModes = newChildren
                }
            }
        }
        return self
    }

    func buildWithDefault() {
        TypingMode.DF_RULES.find(mode)?.childModes.filter({ $0.mode.default }).forEach({ defaultMode in
            set(defaultMode.mode)
        })
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
