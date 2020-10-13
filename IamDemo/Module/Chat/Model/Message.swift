//
//  Message.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//
import Foundation

struct Message: Codable {
    var username = ""
    var message = ""
    var avatar = ""
    var time: Int64 = 0

    mutating func update(_ username: String) {
        self.username = username
    }
}
