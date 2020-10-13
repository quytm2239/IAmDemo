//
//  UIColorExtension.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1)
    }

    /**
     This is Red - Green - Blue - Alpha
     */
    struct RGBA {

    }

    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt: UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)

        var red: UInt32!, green: UInt32!, blue: UInt32!
        switch hexWithoutSymbol.length {
        case 3: // #RGB
            red = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            green = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            blue = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
        case 6: // #RRGGBB
            red = (hexInt >> 16) & 0xff
            green = (hexInt >> 8) & 0xff
            blue = hexInt & 0xff
        default:
            break
        }

        self.init(
            red: (CGFloat(red)/255),
            green: (CGFloat(green)/255),
            blue: (CGFloat(blue)/255),
            alpha: alpha)
    }

    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }

    func isLightColor() -> Bool {
        let detailColor = self.rgba
        let lumen = ((detailColor.red * 255) * 0.299) + ((detailColor.green * 255) * 0.587) + ((detailColor.blue  * 255) * 0.114)
        return lumen > 186
    }

    //    for each c in r,g,b:
    //    c = c / 255.0
    //    if c <= 0.03928 then c = c/12.92 else c = ((c+0.055)/1.055) ^ 2.4

    func isLightColorBT709() -> Bool {
        let detailColor = self.rgba
        let red2 = detailColor.red.getBT709Value()
        let green2 = detailColor.green.getBT709Value()
        let blue2 = detailColor.blue.getBT709Value()
        let lumen = 0.2126 * red2 + 0.7152 * green2 + 0.0722 * blue2
        return lumen > 0.179
    }

    func alpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
}

extension CGFloat {
    func getBT709Value() -> CGFloat {
        let bt709 = self <= 0.03928 ? self / 12.92 : pow((( self + 0.055 ) / 1.055 ), 2.4)
        return bt709
    }
}
