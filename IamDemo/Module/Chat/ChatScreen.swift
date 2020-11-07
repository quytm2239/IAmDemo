//
//  ChatScreen.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 9/30/20.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SDWebImage

class ChatScreen: BaseScreen, UIScrollViewDelegate {

    // MARK: - Properties -
    private var viewModel: ChatViewModel
    weak var coordinator: MainCoordinator?

    lazy var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "dd/MM HH:mm"
        return format
    }()

    lazy var tableMess: AutoScrollUpTableView = {
        let table = AutoScrollUpTableView(frame: CGRect.zero, style: .plain)
        table.register(
            UINib(nibName: MessageTableCell.typeName, bundle: nil ),
            forCellReuseIdentifier: MessageTableCell.typeName
        )
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 120
        table.separatorStyle = .none
        table.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        return table
    }()

    lazy var textFieldMess: PaddingTextField = {
        let textFeld = PaddingTextField()
        textFeld.textColor = .black
        textFeld.backgroundColor = .white
        textFeld.placeholder = "Enter text to chat..."
        textFeld.layer.borderWidth = 0.5
        textFeld.layer.borderColor = UIColor.lightGray.cgColor
        return textFeld
    }()

    lazy var buttonSend: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitle("Send", for: .highlighted)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        return button
    }()

    // MARK: - Constructor
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil) // use without xib
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadMessage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            tableMess.contentInset = UIEdgeInsets(top: keyboardHeight, left: 0, bottom: 0, right: 0)
        }
    }

    @objc func keyboardWillHide() {
        tableMess.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    deinit {
        print("\(self.objectName) deinit")
        SocketIOCenter.shared.disconnect()
    }

    // MARK: - Overriding methods
    override func setupUI() {
        title = "Stranger Group Chat"
        view.addSubview(buttonSend)
        view.addSubview(textFieldMess)
        view.addSubview(tableMess)
    }

    override func setupUIConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        buttonSend.snp.makeConstraints { (maker) in
            maker.width.equalTo(80)
            maker.height.equalTo(50)
            maker.right.equalTo(safeArea.snp.right)
            maker.bottom.equalTo(safeArea.snp.bottom)
        }
        textFieldMess.snp.makeConstraints { (maker) in
            maker.height.equalTo(50)
            maker.left.equalTo(safeArea.snp.left)
            maker.right.equalTo(buttonSend.snp.left)
            maker.bottom.equalTo(safeArea.snp.bottom)
        }
        tableMess.snp.makeConstraints { (maker) in
            maker.top.equalTo(safeArea.snp.top)
            maker.left.equalTo(safeArea.snp.left)
            maker.right.equalTo(safeArea.snp.right)
            maker.bottom.equalTo(textFieldMess.snp.top)
        }
    }

    override func bindInput() {
        tableMess.rx
            .setDelegate(self)
            .disposed(by: bag)

        buttonSend.rx.tap
            .bind(to: viewModel.inputs.send)
            .disposed(by: bag)

        textFieldMess.rx.text
            .bind(to: viewModel.inputs.message)
            .disposed(by: bag)

        // this is for clear TextField
        buttonSend.rx.tap
            .bind { [weak self] (_) in
                self?.textFieldMess.text = nil
            }.disposed(by: bag)
    }

    override func bindOutput() {
        viewModel.outputs.msgList
            .skip(1)
            .bind( to:
                    tableMess.rx
                    .items(
                        cellIdentifier: MessageTableCell.typeName,
                        cellType: MessageTableCell.self
                    )
            ) { [weak self] (_, model, cell) in
                cell.imageAvatar.sd_setImage(
                    with: URL(string: SocketIOCenter.baseUrl + model.avatar),
                    placeholderImage: UIImage(named: "ninja"),
                    options: .progressiveLoad, context: nil)

                cell.labelMsg.text = model.message
                cell.labelName.text = model.username
                cell.labelTime.text =
                    self?.dateFormatter.string(from: Date(
                        timeIntervalSince1970: TimeInterval(model.time / 1000)
                    ))

                cell.setNeedsUpdateConstraints()
                cell.updateConstraintsIfNeeded()
            }.disposed(by: bag)

        viewModel.outputs.msgList
            .skip(1)
            .bind { [weak self] (items) in
                self?.tableMess.setCurrentItem(items.count)
            }.disposed(by: bag)

        viewModel.outputs.userInfo
            .subscribe { (event) in
                print(event.element?.toString() ?? "")
            }.disposed(by: bag)
    }
}
