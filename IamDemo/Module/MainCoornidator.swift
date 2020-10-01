//
//  MainCoornidator.swift
//  IamDemo
//
//  Created by Trần Mạnh Quý on 10/1/20.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = TermScreen()
        vc.coordinator = self
        vc.setViewModel(TermViewModel())
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openChatScreen() {
        let vc = ChatScreen()
        vc.coordinator = self
        vc.setViewModel(ChatViewModel()) // DI
        navigationController.pushViewController(vc, animated: true)
    }
}
