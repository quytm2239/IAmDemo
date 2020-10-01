//
//  NSObjectExtension.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import Foundation

extension NSObject {
    static var typeName: String {
        return String(describing: self)
    }
    var objectName: String {
        return String(describing: type(of: self))
    }
}
