//
//  ChatViewModel.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import RxCocoa
import RxSwift

protocol ChatViewModelInputs {
    var message: BehaviorRelay<String?> { get set}
    var send: PublishRelay<Void> { get set}
}

protocol ChatViewModelOutPuts {
    var msgList: BehaviorRelay<[Message]> { get }
    var userInfo: BehaviorRelay<YourInfo> { get }
}

protocol ChatViewModelType {
    var inputs: ChatViewModelInputs { get }
    var outputs: ChatViewModelOutPuts { get }
}

class ChatViewModel: ChatViewModelOutPuts, ChatViewModelInputs, ChatViewModelType {

    let bag = DisposeBag()

    // MARK: - Inputs
    var message: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var send: PublishRelay<Void> = PublishRelay<Void>()

    // MARK: - Outputs
    var msgList: BehaviorRelay<[Message]> = BehaviorRelay<[Message]>(value: [])
    var userInfo: BehaviorRelay<YourInfo> = BehaviorRelay<YourInfo>(value: YourInfo())

    // MARK: - Properties
    var inputs: ChatViewModelInputs { return self }
    var outputs: ChatViewModelOutPuts { return self }
    var username = ""

    // MARK: - Constructor
    init() {
        setupAction()
        setupSocket()
    }

    // MARK: - Setup methods
    private func setupSocket() {
        SocketIOCenter.shared.connect()
        SocketIOCenter.shared.setDelegate(self)
    }

    private func setupAction() {
        send.bind(onNext: {
            if let mess = self.message.value {
                SocketIOCenter.shared.sendMsg(mess)
            }
        }).disposed(by: bag)
    }

    deinit {
        print("ChatViewModel deinit")
    }
}

extension ChatViewModel: SocketIOCenterDelegate {
    func onEvent(name: EventName, data: [Any]?) {

        guard let data = data, !data.isEmpty else { return }
        guard let dict = data[0] as? [String: Any]else { return }
        guard let theJSONData = try?  JSONSerialization.data(
            withJSONObject: dict,
            options: .prettyPrinted
        ) else { return }

        switch name {
        case .yourInfo:
            guard let yourInfo = try? JSONDecoder()
                    .decode(YourInfo.self, from: theJSONData) else { return }
            self.userInfo.accept(yourInfo)

        case .newMessage:
            guard var message = try? JSONDecoder()
                    .decode(Message.self, from: theJSONData) else { return }
            if message.username == self.username {
                message.update("\(message.username) (You)")
            }
            let new = msgList.value + [message]
            self.msgList.accept(new)

        case .joinChat:
            let userInfo = try? JSONDecoder().decode(YourInfo.self, from: theJSONData)
            username = userInfo?.username ?? ""
            print(userInfo?.toString())
        }
    }
}
