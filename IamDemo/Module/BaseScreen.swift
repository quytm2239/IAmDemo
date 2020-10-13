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
        setupBasic()
        setupUI()
        setupUIConstraint()
        bindInput()
        bindOutput()
    }

    // MARK: - For overriding purpose
    func setupBasic() {}

    func bindInput() {}

    func bindOutput() {}

    func setupUI() {}

    func setupUIConstraint() {}

    deinit {
        print("\(self.objectName) deinit")
    }
}
