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
    // MARK: -- Properties --
    private var viewModel: ChatViewModel!
    weak var coordinator: MainCoordinator?
    
    lazy var dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM HH:mm"
        return f
    }()
    
    lazy var tableMess: AutoScrollUpTableView = {
        let table = AutoScrollUpTableView(frame: CGRect.zero, style: .plain)
        // Register cell
        table.register(UINib(nibName: MessageTableCell.typeName, bundle: nil), forCellReuseIdentifier: MessageTableCell.typeName)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 120
        table.separatorStyle = .none
        table.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        return table
    }()
    
    lazy var textFieldMess: PaddingTextField = {
        let tf = PaddingTextField()
        tf.textColor = .black
        tf.backgroundColor = .white
        tf.placeholder = "Enter text to chat..."
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    lazy var buttonSend: UIButton = {
        let btn = UIButton()
        btn.setTitle("Send", for: .normal)
        btn.setTitle("Send", for: .highlighted)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        return btn
    }()
    
    
    // MARK: -- Lifecycle --
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
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
        //Do something here
        tableMess.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: -- Setup methods --
    /**
     DI
     */
    func setViewModel(_ vm: ChatViewModel) {
        self.viewModel = vm
    }
    
    /**
     This relates to binding but from relay configuration
     */
    override func configRelay() {
        viewModel.messageListRelay.skip(1).bind(to: tableMess.rx.items(cellIdentifier: MessageTableCell.typeName, cellType: MessageTableCell.self)) { [unowned self] (index,model,cell) in
            cell.imageAvatar.sd_setImage(with: URL(string: SocketIOCenter.baseUrl + model.avatar), placeholderImage: UIImage(named: "ninja"), options: .progressiveLoad, context: nil)
            cell.labelMsg.text = model.message
            cell.labelName.text = model.username
            cell.labelTime.text = self.dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(model.time / 1000)))
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
        }.disposed(by: bag)
        viewModel.messageListRelay.skip(1).bind { [unowned self] (items) in
            self.tableMess.currentItem = items.count
        }.disposed(by: bag)
    }
    
    override func configAction() {
        tableMess.rx.setDelegate(self).disposed(by: bag)
        buttonSend.rx.tap.bind { [unowned self] (_) in
            guard let text = textFieldMess.text else { return }
            self.viewModel.send(text)
            self.textFieldMess.text = nil
        }.disposed(by: bag)
    }
    
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
    
}
