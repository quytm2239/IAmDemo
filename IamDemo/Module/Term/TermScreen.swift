//
//  TermScreen.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 9/30/20.
//

import UIKit
import RxCocoa
import MBProgressHUD

class TermScreen: BaseScreen {
    
    weak var coordinator: MainCoordinator?
    
    private var viewModel: TermViewModel!
    
    @IBOutlet weak var buttonJoinChat: UIButton!
    @IBOutlet weak var textFieldYear: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func configRelay() {
        
        viewModel.isValidAge.skip(1).bind { [unowned self] (isValid) in
            if (isValid) { self.coordinator?.openChatScreen() }
        }.disposed(by: bag)
        
        viewModel.error.skip(1).bind(onNext: { [unowned self] (error) in
            guard !error.isEmpty else { return }
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Close", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }
    
    override func configAction() {
        buttonJoinChat.rx.tap.bind { [unowned self] (_) in
            guard let year = self.textFieldYear.text ?? "", let yearInt = Int(year) else { return }
            CustomLoading.show()
            self.viewModel.year.accept(yearInt)
        }.disposed(by: bag)
    }
    
    /**
     DI
     */
    func setViewModel(_ viewModel: TermViewModel) {
        self.viewModel = viewModel
    }
    
}
