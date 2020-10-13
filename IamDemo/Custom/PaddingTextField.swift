//
//  PaddingTextField.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import UIKit

class PaddingTextField: UITextField {
    struct Padding {
        static let horizontal: CGFloat = 8
        static let vertical: CGFloat = 0
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Padding.horizontal,
            y: bounds.origin.y + Padding.vertical,
            width: bounds.size.width - Padding.horizontal * 2,
            height: bounds.size.height - Padding.vertical * 2
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
