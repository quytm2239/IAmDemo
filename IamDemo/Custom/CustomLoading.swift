//
//  CustomLoading.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import UIKit
import SnapKit

class CustomLoading: UIView {
    
    private unowned var currentWindow: UIWindow?
    
    private static let shared = CustomLoading(frame: CGRect.zero)
    private let loading = UIActivityIndicatorView(style: .whiteLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    class func update(_ currentWindow: UIWindow?) {
        CustomLoading.shared.currentWindow = currentWindow
    }
    
    private func setupUI() {
        backgroundColor = UIColor(hex: "#000000", alpha: 0.6)
        addSubview(loading)
        loading.snp.makeConstraints { (maker) in
            maker.width.equalTo(50)
            maker.height.equalTo(50)
            maker.centerX.centerY.equalToSuperview()
        }
    }
    
    private func attach() {
        currentWindow?.addSubview(self)
        snp.makeConstraints { (maker) in
            maker.width.equalToSuperview()
            maker.height.equalToSuperview()
            maker.centerX.centerY.equalToSuperview()
        }
        loading.startAnimating()
    }
    
    private func detach() {
        loading.stopAnimating()
        snp.removeConstraints()
        removeFromSuperview()
    }
    
    class func show() {
        shared.attach()
    }
    
    class func hide() {
        shared.detach()
    }
}
