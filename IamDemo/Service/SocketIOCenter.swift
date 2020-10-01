//
//  SocketIOCenter.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 9/30/20.
//

import SocketIO

enum EventName: String {
    case your_info = "your_info",
         new_message = "new_message",
         join_chat = "join_chat"
}

protocol SocketIOCenterDelegate {
    func onEvent(name: EventName, data: [Any]?)
}

class SocketIOCenter {
    // MARK: -- Properties --
    public static let shared = SocketIOCenter()
    static let baseUrl = "https://strange-chat.herokuapp.com"
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    private var delegate: SocketIOCenterDelegate?
    
    // MARK: -- Initialize --
    private init() {
        manager = SocketManager(socketURL: URL(string: SocketIOCenter.baseUrl)!, config: [.log(false), .compress, .reconnects(true)])
        socket = manager.defaultSocket
        setupEventHandler()
    }
    
    // MARK: -- Basic methods --
    func connect() {
        socket.connect()
    }
    
    func setDelegate(_ delegate: SocketIOCenterDelegate) {
        self.delegate = delegate
    }
    
    func setupEventHandler() {
        socket.on(clientEvent: .connect) {data, ack in
            print("Connected to socket server")
        }
        socket.on(clientEvent: .error) {data, ack in
            print(data)
        }
        socket.onAny { [unowned self](anyEvent) in
            guard let eventName = EventName.init(rawValue: anyEvent.event) else { return }
            self.delegate?.onEvent(name: eventName, data: anyEvent.items)
        }
    }
    
    func sendMsg(_ msg: String) {
        socket.emit(EventName.new_message.rawValue, CustomData(msg: msg))
    }
}


struct CustomData : SocketData {
    let msg: String
    func socketRepresentation() -> SocketData {
        return msg
    }
}

