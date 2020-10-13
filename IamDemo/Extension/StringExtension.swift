//
//  StringExtension.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//
import UIKit

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }

    func substring(_ from: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: from)
        let newStr = String(self.suffix(from: index)) // Swift 4
        return newStr
    }

    func substringTo(_ endIndex: Int) -> String {
        let index = self.index(self.endIndex, offsetBy: endIndex)
        let newStr = String(self.prefix(upTo: index)) // Swift 4
        return newStr
    }

    var length: Int {
        return self.count
    }

    var localizable: String {
        return NSLocalizedString(self, comment: "")
    }

    func encodeUrl() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let paragraph: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraph.lineBreakMode = lineBreakMode
        let boundingBox =
            self.boundingRect(
                with: constraintRect,
                options: .usesLineFragmentOrigin,
                attributes: [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.paragraphStyle: paragraph
                ],
                context: nil)

        return boundingBox.height
    }

    func heightWithSpacing(withConstrainedWidth width: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode, spacing: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let paragraph: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraph.lineSpacing = spacing
        paragraph.lineBreakMode = lineBreakMode
        let boundingBox =
            self.boundingRect(
                with: constraintRect,
                options: .usesLineFragmentOrigin,
                attributes: [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.paragraphStyle: paragraph
                ],
                context: nil)

        return boundingBox.height
    }

    func width(withConstraintedHeight height: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let paragraph: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraph.lineBreakMode = lineBreakMode
        let boundingBox =
            self.boundingRect(
                with: constraintRect,
                options: .usesLineFragmentOrigin,
                attributes: [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.paragraphStyle: paragraph
                ],
                context: nil)

        return boundingBox.width
    }

    func toFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: self, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    var toNSString: NSString {
        return self as NSString
    }

    var toDecimal: NSDecimalNumber {
        return NSDecimalNumber(string: self)
    }

    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }

    var isValidDec: Bool {
        return self.toDecimal.compare(NSDecimalNumber.notANumber) != ComparisonResult.orderedSame
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(string.startIndex..., in: string)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
