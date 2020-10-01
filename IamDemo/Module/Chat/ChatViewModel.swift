//
//  ChatViewModel.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import RxCocoa
import RxSwift

class ChatViewModel {
    
    var username = ""
    var messageListRelay: BehaviorRelay<[Message]> = BehaviorRelay<[Message]>(value: [])
    var userInfoRelay: BehaviorRelay<YourInfo> = BehaviorRelay<YourInfo>(value: YourInfo())
    
    init() {
        setupBasic()
    }
    
    private func setupBasic() {
        SocketIOCenter.shared.connect()
        SocketIOCenter.shared.setDelegate(self)
    }
    
    func send(_ msg: String) {
        SocketIOCenter.shared.sendMsg(msg)
    }
}

extension ChatViewModel: SocketIOCenterDelegate {
    func onEvent(name: EventName, data: [Any]?) {
        
        guard let data = data, !data.isEmpty else { return }
        guard let dict = data[0] as? Dictionary<String, Any>else { return }
        guard let theJSONData = try?  JSONSerialization.data(
            withJSONObject: dict,
            options: .prettyPrinted
        ) else { return }
        
        switch name {
        case .your_info:
            guard let yourInfo = try? JSONDecoder().decode(YourInfo.self, from: theJSONData) else { return }
            userInfoRelay.accept(yourInfo)
        case .new_message:
            guard let message = try? JSONDecoder().decode(Message.self, from: theJSONData) else { return }
            var message2 = messageListRelay.value
            message2.append(message)
            messageListRelay.accept(message2)
        case .join_chat:
            let yourInfo = try? JSONDecoder().decode(YourInfo.self, from: theJSONData)
        }
    }
}
