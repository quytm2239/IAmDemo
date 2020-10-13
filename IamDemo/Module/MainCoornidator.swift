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
        let screen = TermScreen(viewModel: TermViewModel())
        screen.coordinator = self
        navigationController.pushViewController(screen, animated: false)
    }

    func openChatScreen() {
        let screen = ChatScreen(viewModel: ChatViewModel())
        screen.coordinator = self
        navigationController.pushViewController(screen, animated: true)
    }
}
