//
//  TermScreen.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 9/30/20.
//

import UIKit
import RxCocoa

class TermScreen: BaseScreen {

    // MARK: - Properties
    weak var coordinator: MainCoordinator?
    private var viewModel: TermViewModel

    @IBOutlet weak var buttonJoinChat: UIButton!
    @IBOutlet weak var textFieldYear: UITextField!

    // MARK: - Constructor
    init(viewModel: TermViewModel) {
        self.viewModel = viewModel
        super.init(nibName: TermScreen.typeName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Overriding methods
    override func bindOutput() {

        viewModel.output.isValidAge
            .skip(1)
            .bind { [weak self] (isValid) in
            if isValid { self?.coordinator?.openChatScreen() }
        }.disposed(by: bag)

        viewModel.output.error
            .skip(1)
            .bind(onNext: { [weak self] (error) in
            guard !error.isEmpty else { return }
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Close", style: .default, handler: nil)
                alertController.addAction(okButton)
                self?.present(alertController, animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }

    override func bindInput() {
        buttonJoinChat.rx.tap
            .bind(to: viewModel.input.check)
            .disposed(by: bag)

        textFieldYear.rx.text
            .bind(to: viewModel.input.year)
            .disposed(by: bag)

        buttonJoinChat.rx.tap
            .bind { [weak self] in
            self?.textFieldYear.text = nil
            self?.textFieldYear.resignFirstResponder()
        }.disposed(by: bag)
    }
}
