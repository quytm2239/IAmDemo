//
//  BaseScreen.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 9/30/20.
//

import UIKit
import RxSwift

class BaseScreen: UIViewController {
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.setNavigationBarHidden(true, animated: false)
        setupBasic()
        configRelay()
        configAction()
        setupUI()
        setupUIConstraint()
    }
    
    // MARK: -- For overriding purpose --
    func setupBasic() {}
    
    func configRelay() {}
    
    func configAction() {}
    
    func setupUI() {}
    
    func setupUIConstraint() {}
}
