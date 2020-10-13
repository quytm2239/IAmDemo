//
//  SocketIOCenter.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 9/30/20.
//

import SocketIO

enum EventName: String {
    case yourInfo = "your_info",
         newMessage = "new_message",
         joinChat = "join_chat"
}

protocol SocketIOCenterDelegate: class {
    func onEvent(name: EventName, data: [Any]?)
}

struct CustomData: SocketData {
    let msg: String
    func socketRepresentation() -> SocketData {
        return msg
    }
}

class SocketIOCenter {
    // MARK: - Properties
    public static let shared = SocketIOCenter()
    static let baseUrl = "https://strange-chat.herokuapp.com"

    private let manager: SocketManager
    private let socket: SocketIOClient
    private weak var delegate: SocketIOCenterDelegate?

    // MARK: - Constructor
    private init() {
        manager = SocketManager(socketURL: URL(string: SocketIOCenter.baseUrl)!, config: [.log(false), .compress, .reconnects(true)])
        socket = manager.defaultSocket
        setupEventHandler()
    }

    // MARK: - Basic methods
    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func setDelegate(_ delegate: SocketIOCenterDelegate) {
        self.delegate = delegate
    }

    private func setupEventHandler() {
        socket.on(clientEvent: .connect) {_, _ in
            print("Connected to socket server")
        }
        socket.on(clientEvent: .error) {data, _ in
            print(data)
        }
        socket.onAny { [weak self](anyEvent) in
            guard let eventName = EventName.init(rawValue: anyEvent.event) else { return }
            self?.delegate?.onEvent(name: eventName, data: anyEvent.items)
        }
    }

    func sendMsg(_ msg: String) {
        socket.emit(EventName.newMessage.rawValue, CustomData(msg: msg))
    }
}
