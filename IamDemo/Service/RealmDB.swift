//
//  RealmDB.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 11/7/20.
//

import Foundation
import RealmSwift

class RealmDB {
    private let realm = try! Realm()
    
    // Singleton
    private static var instance: RealmDB!
    
    private init() {}
    
    public static func getIntance() -> RealmDB {
        if instance == nil { instance = RealmDB() }
        return instance
    }
    
    // Swift
    public static var shared: RealmDB {
        if instance == nil { instance = RealmDB() }
        return instance
    }
    
    func persist(_ obj: Object) {
        try! realm.write {
            realm.add(obj, update: .modified)
        }
    }
    
    func persist(_ list: [Object]) {
        try! realm.write({
            realm.add(list, update: .modified)
        })
    }
    
    func get<T: Object>(byId: Int) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: byId)
    }
    
    func get<T: Object>(_ filter: String = "") -> [T] {
        let result = filter.isEmpty
            ? realm.objects(T.self)
            : realm.objects(T.self).filter(filter)
        var resultArray = [T]()
        result.forEach { (item) in resultArray.append(item) }
        return resultArray
    }
}
