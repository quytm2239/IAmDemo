//
//  UIColorExtension.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
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
        let L = ((detailColor.red * 255) * 0.299) + ((detailColor.green * 255) * 0.587) + ((detailColor.blue  * 255) * 0.114)
        return L > 186
    }
    
//    for each c in r,g,b:
//    c = c / 255.0
//    if c <= 0.03928 then c = c/12.92 else c = ((c+0.055)/1.055) ^ 2.4
    
    func isLightColorBT709() -> Bool {
        let detailColor = self.rgba
        let red2 = detailColor.red.getBT709Value()
        let green2 = detailColor.green.getBT709Value()
        let blue2 = detailColor.blue.getBT709Value()
        let L = 0.2126 * red2 + 0.7152 * green2 + 0.0722 * blue2
        return L > 0.179
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

