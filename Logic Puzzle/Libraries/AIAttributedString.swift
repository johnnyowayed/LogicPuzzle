//
//  AIAttributedString.swift
//  Fibler2
//
//  Created by Alexy Ibrahim on 12/18/18.
//  Copyright © 2018 siegma. All rights reserved.
//

import UIKit

@objcMembers class AIAttributedString: NSObject {
    
    static let sharedInstance = AIAttributedString()
    
    var mainString:String!
    private var attributedString:NSMutableAttributedString!
    
    override init() {
        self.mainString = ""
        self.attributedString = NSMutableAttributedString(string:self.mainString)
    }
    
    @objc init(withMainString mainString:String) {
        self.mainString = mainString
        self.attributedString = NSMutableAttributedString(string:self.mainString)
    }
    
    @objc init(withAttributedString attributedString:NSAttributedString) {
        self.mainString = attributedString.string
        self.attributedString = NSMutableAttributedString(attributedString: attributedString)
    }
    
    @objc final func appendString(string:String) -> AIAttributedString {
        self.mainString += string
        self.attributedString.append(NSAttributedString.init(string: string))
        
        return self
    }
    
    @objc final func addAttribute(forSubstring string:String? = nil, withTextColor textColor:UIColor) -> AIAttributedString {
        self.addAttribute(forSubstring: string, attributeName: convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor), value: textColor)
        
        return self
    }
    
    @objc final func addAttribute(alignment: NSTextAlignment) -> AIAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        self.addAttribute(forSubstring: nil, attributeName: convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle), value: paragraph)
        
        return self
    }
    
    @objc final func addAttribute(forSubstring string:String? = nil, withFont font:UIFont) -> AIAttributedString {
        self.addAttribute(forSubstring: string, attributeName: convertFromNSAttributedStringKey(NSAttributedString.Key.font), value: font)
        
        return self
    }
    
    @objc final func addAttribute(forSubstring string:String? = nil, withUnderlineAreaColor color:UIColor? = nil) -> AIAttributedString {
        self.addAttribute(forSubstring: string, attributeName: convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle), value: NSUnderlineStyle.single.rawValue)
        if let color = color {
            self.addAttribute(forSubstring: string, attributeName: convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor), value: color)
        }
        
        return self
    }
    
    @objc final func addAttribute(forSubstring string:String? = nil, withBackgroundColor backgroundColor:UIColor) -> AIAttributedString {
        self.addAttribute(forSubstring: string, attributeName: convertFromNSAttributedStringKey(NSAttributedString.Key.backgroundColor), value: backgroundColor)
        
        return self
    }
    
    @objc final func addAttribute(forSubstring string:String? = nil, withUrl url:String) -> AIAttributedString {
        self.addAttribute(forSubstring: string, attributeName: convertFromNSAttributedStringKey(NSAttributedString.Key.link), value: URL.init(string: url)!)
        
        return self
    }
    
//    final func clickable(onString string:String? = nil, _ callback: @escaping ((_ link: String) -> ())) -> AIAttributedString {
//        var range = NSMakeRange(0, self.mainString.count)
//        if let string = string {
//            range = (self.mainString as NSString).range(of: string)
//        }
//        
//        
//        let unEscapedString = (self.attributedString.string as NSString).substring(with: range)
//        let escapedString = unEscapedString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed) ?? ""
//        self.attributedString.addAttribute(NSLinkAttributeName, value: "AttributedTextView:\(escapedString)", range: range)
////        urlCallbacks[unEscapedString] = callback
//        
//        return self
//    }
//    
//    public func interactWithURL(URL: URL) {
////        let unescapedString = URL.absoluteString.replacingOccurrences(of: "AttributedTextView:", with: "").removingPercentEncoding ?? ""
////        urlCallbacks[unescapedString]?(unescapedString)
//    }
    
    final func addImage(image:UIImage) -> AIAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        self.attributedString.append(imageString)
        
        
        return self
    }
    
    private final func addAttribute(forSubstring string:String? = nil, attributeName:String, value: Any) {
        var range = NSMakeRange(0, self.mainString.count)
        if let string = string {
            range = (self.mainString as NSString).range(of: string)
        }
        self.attributedString.addAttribute(convertToNSAttributedStringKey(attributeName), value: value , range: range)
    }
    
    
    final func text(alignment: NSTextAlignment? = nil) -> NSAttributedString {
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.alignment = alignment ?? .left
        
        return NSAttributedString(attributedString: self.attributedString)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKey(_ input: String) -> NSAttributedString.Key {
	return NSAttributedString.Key(rawValue: input)
}

extension String {
    
    func attributedString() -> AIAttributedString {
        return AIAttributedString.init(withMainString: self)
    }
}

extension NSAttributedString {

    func attributedString() -> AIAttributedString {
        return AIAttributedString.init(withAttributedString: self)
    }
}


extension NSMutableAttributedString {
    public func trimCharactersInSet(charSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: charSet as CharacterSet)
        
        // Trim leading characters from character set.
        while range.length != 0 && range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet)
        }
        
        // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        while range.length != 0 && NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        }
    }
}

