//
//  TestView.swift
//  scias
//
//  Created by 林瑞鑫 on 2023/4/26.
//

import SwiftUI

struct LogoPath: View {
    var body: some View {
        var height = CGFloat(0)
        var width = CGFloat(0)
        var wordSpacing = CGFloat(0)
        var lastPosition: CGPoint?
        return Path { path in
            let font = UIFont.systemFont(ofSize: 60, weight: .bold)
            let attributedString = NSAttributedString(string: "scias", attributes: [NSAttributedString.Key.font: font])
            let line = CTLineCreateWithAttributedString(attributedString as CFAttributedString)
            let runArray = CTLineGetGlyphRuns(line) as! [CTRun]
            for run in runArray {
                let glyphCount = CTRunGetGlyphCount(run)
                for i in 0..<glyphCount {
                    let range = CFRangeMake(i, 1)
                    var glyph: CGGlyph = 0
                    var position: CGPoint = .zero
                    CTRunGetGlyphs(run, range, &glyph)
                    CTRunGetPositions(run, range, &position)
                    position.y += 33
                    let pathForGlyph = CTFontCreatePathForGlyph(font as CTFont, glyph, nil)
                    var transform = CGAffineTransform(translationX: position.x, y: position.y)
                    transform = transform.scaledBy(x: 1, y: -1) // flip y-axis
                    transform = transform.translatedBy(x: 0, y: font.descender)  // move to baseline
                    let boundingBox = pathForGlyph?.boundingBox
                    width += boundingBox?.width ?? 0
                    height = max(height, boundingBox?.height ?? 0)
                    if let lastPos = lastPosition {
                        wordSpacing = position.x - lastPos.x - (boundingBox?.width ?? 0)
                    }
                    lastPosition = position
                    path.addPath(Path(pathForGlyph!), transform: transform)
                }
            }
        }
        .frame(width: width + wordSpacing * 4, height: height + 5)
        .padding(.bottom, 0)
    }
}

struct LogoPath_Previews: PreviewProvider {
    static var previews: some View {
        LogoPath()
    }
}
