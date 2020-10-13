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

struct TermViewModelInput {
    var year: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var check: PublishRelay<Void> = PublishRelay<Void>()
}

struct TermViewModelOutput {
    var isValidAge: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var error: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
}

class TermViewModel {

    let bag = DisposeBag()

    var input = TermViewModelInput()
    var output = TermViewModelOutput()

    init() {
        configAction()
    }

    private func configAction() {
        input.check.bind(onNext: { [weak self] in
            guard let rawYear = self?.input.year.value, let year = Int(rawYear) else { return }
            CustomLoading.show()
            AF.request(
                SocketIOCenter.baseUrl + "/check-age",
                method: .post,
                parameters: ["year": year],
                encoder: URLEncodedFormParameterEncoder.default,
                headers: HTTPHeaders(["Content-type": "application/x-www-form-urlencoded"]),
                interceptor: nil, requestModifier: nil)
                .responseJSON {[weak self] (dataRes) in
                print(dataRes)
                CustomLoading.hide()
                if let json = dataRes.value as? [String: Any], let success = json["success"] as? Bool {
                    self?.output.isValidAge.accept(success)
                    if let error = json["error"] as? String, !success {
                        self?.output.error.accept(error)
                    }
                }
            }
        }).disposed(by: bag)
    }
    
    deinit {
        print("TermViewModel deinit")
    }
}
