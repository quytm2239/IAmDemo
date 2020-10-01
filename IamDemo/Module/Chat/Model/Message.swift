//
//  Message.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//
import Foundation

class Message: Codable  {
    var username = ""
    var message = ""
    var avatar = ""
    var time: Int64 = 0
}
