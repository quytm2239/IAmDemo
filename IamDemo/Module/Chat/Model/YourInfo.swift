//
//  YourInfo.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import Foundation

struct YourInfo: Codable {
    var room = 0
    var username = ""
    var avatar = ""
    var totalOnline = 0

    enum CodingKeys: String, CodingKey {
        case room
        case username
        case avatar
        case totalOnline = "total_online"
    }

    func toString() -> String {
        return "\(username) has joined room: \(room), total online: \(totalOnline)"
    }
}
