//
//  MarkdownParser.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/5/7.
//

import Foundation
import Down
import UIKit
import SwiftUI

class MarkdownParser {
    
    public static func toAttrString(_ formattedString: String) -> NSAttributedString {
        let down = Down(markdownString: formattedString)
        return try! down.toAttributedString()
    }
    
    public static func toMd(_ attrString: NSAttributedString) -> String {
        return attrString.convertAttributedStringToMarkdown(attrString)
    }
    
}


extension NSAttributedString {
    func convertAttributedStringToMarkdown(_ attributedString: NSAttributedString) -> String {
        var markdown = ""
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.enumerateAttributes(in: range, options: []) { (attributes, range, _) in
            let font = attributes[NSAttributedString.Key.font] as? UIFont ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            let bold = font.fontDescriptor.symbolicTraits.contains(.traitBold)
            let italic = attributes[NSAttributedString.Key.obliqueness] != nil
            let underline = attributes[NSAttributedString.Key.underlineStyle] != nil
            let strikethrough = attributes[NSAttributedString.Key.strikethroughStyle] != nil
//            let foregroundColor = attributes[NSAttributedString.Key.foregroundColor] as? UIColor ?? .black
//            let backgroundColor = attributes[NSAttributedString.Key.backgroundColor] as? UIColor
            let string = attributedString.attributedSubstring(from: range).string

            var formatting = ""
            if bold {
                formatting += "**"
            }
            if italic {
                formatting += "*"
            }
            if underline {
                formatting += "<u>"
            }
            if strikethrough {
                formatting += "~~"
            }
//            if let backgroundColor = backgroundColor {
//                formatting += "<span style=\"background-color: \(String(describing: backgroundColor.hexString))\">"
//            }
//            if let foregroundColor = foregroundColor.hexString {
//                formatting += "<span style=\"color: \(foregroundColor)\">"
//            }

            formatting += string

//            if let _ = foregroundColor.hexString {
//                formatting += "</span>"
//            }
//            if let _ = backgroundColor {
//                formatting += "</span>"
//            }
            if strikethrough {
                formatting += "~~"
            }
            if underline {
                formatting += "</u>"
            }
            if italic {
                formatting += "*"
            }
            if bold {
                formatting += "**"
            }

            markdown += formatting
        }
        return markdown
    }
}
