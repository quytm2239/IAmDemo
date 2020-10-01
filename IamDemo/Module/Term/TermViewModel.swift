//
//  TermVM.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 9/30/20.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
import MBProgressHUD

class TermViewModel {
    
    let bag = DisposeBag()
    
    var year: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var isValidAge: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var error: BehaviorRelay<String> = BehaviorRelay<String>(value: "")

    init() {
        configRelay()
        configAction()
    }
    
    func configRelay() {
        year = BehaviorRelay<Int>(value: 0)
        isValidAge = BehaviorRelay<Bool>(value: false)
        error = BehaviorRelay<String>(value: "")
    }
    
    func configAction() {
        year.skip(1).bind(onNext: { (year) in
            AF.request(SocketIOCenter.baseUrl + "/check-age", method: .post, parameters: ["year": year], encoder: URLEncodedFormParameterEncoder.default, headers: HTTPHeaders(["Content-type" : "application/x-www-form-urlencoded"]), interceptor: nil, requestModifier: nil).responseJSON {[unowned self] (dataRes) in
                print(dataRes)
                CustomLoading.hide()
                if let json = dataRes.value as? [String: Any], let success = json["success"] as? Bool {
                    self.isValidAge.accept(success)
                    if let error = json["error"] as? String , !success {
                        self.error.accept(error)
                    }
                }
            }
            
        }).disposed(by: bag)
    }
}
