//
//  Message.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//
import Foundation
import RealmSwift

class Message: Object, Codable {
    @objc dynamic var id = 0
    @objc dynamic var username = ""
    @objc dynamic var message = ""
    @objc dynamic var avatar = ""
    @objc dynamic var time: Int64 = 0
    
    override init() {
        let randomInt = Int.random(in: 1..<1000000)
        id = randomInt
    }
    
    override static func primaryKey() -> String {
        return "id"
    }

    func update(_ username: String) {
        self.username = username
    }
}
