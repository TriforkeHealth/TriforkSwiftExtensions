//
//  NSMutableAttributedStringExtensionTests.swift
//  TriforkSwiftExtensions
//
//  Created by Thomas Kalhøj Clemensen on 23/08/2017.
//  Copyright © 2017 Trifork A/S. All rights reserved.
//

import XCTest
@testable import TriforkSwiftExtensions

class NSMutableAttributedStringExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAppendTextFontColor() {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString()
        XCTAssert(attributedString.length == 0)
        
        let text: String = "A very testy string"
        attributedString.appendString(text: text, withFont: UIFont.boldSystemFont(ofSize: 15.0), andColor: UIColor.magenta)
        XCTAssert(attributedString.string == text)
        
        let attributes: [String: Any] = attributedString.attributes(at: 0, effectiveRange: nil)
        self.assert(attributes: attributes, fontName: ".SFUIText-Semibold", fontSize: 15.0, color: UIColor.magenta)
        
        let text2: String = "something after that"
        attributedString.appendString(text: text2, withFont: UIFont.systemFont(ofSize: 50.0), andColor: nil)
        
        let attributes2: [String: Any] = attributedString.attributes(at: text.characters.count, effectiveRange: nil)
        self.assert(attributes: attributes2, fontName: ".SFUIDisplay", fontSize: 50.0, color: nil)
        
        //Check index 0 again, to make sure the attributes weren't changed after 'attributes2' was used.
        let attributes3: [String: Any] = attributedString.attributes(at: 0, effectiveRange: nil)
        self.assert(attributes: attributes3, fontName: ".SFUIText-Semibold", fontSize: 15.0, color: UIColor.magenta)
    }
    
    
    private func assert(attributes: [String: Any], fontName: String?, fontSize: CGFloat?, color: UIColor?) {
        XCTAssert((attributes[NSFontAttributeName] as? UIFont)?.fontName == fontName, "The font name should be \(fontName ?? "nil")")
        XCTAssert((attributes[NSFontAttributeName] as? UIFont)?.pointSize == fontSize, "The size should be \(String(describing: fontSize))")
        XCTAssert((attributes[NSForegroundColorAttributeName] as? UIColor) == color, "The color should be \(color?.description ?? "nil")")
    }
}
