//
//  LoginCoordinator.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit

class LoginCoordinator:NSObject, Coordinator{
    var navigationController: UINavigationController
    var loginViewController: LoginViewController!
    var childCoordinators: [Coordinator] = []
    weak var parentDelegate: ParentCoordinatorDelegate?
    
    init(navController: UINavigationController) {
        navigationController = navController
        super.init()
        loginViewController = createLoginViewController()
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func createLoginViewController() -> LoginViewController{
        let viewModel = LoginViewModelImpl(dependencies: LoginViewModelImpl.Dependencies(activitiesRepository: ActivitiesRepositoryImpl()))
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.loginNavigationDelegate = self
        return viewController
    }
}

extension LoginCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
}

extension LoginCoordinator: LoginNavigationDelegate {
    func openHomeScreen() {
        let homeCoordinator = HomeCoordinator(navController: navigationController)
        self.addChildCoordinator(coordinator: homeCoordinator)
        homeCoordinator.start()
    }
}

protocol LoginNavigationDelegate: AnyObject {
    func openHomeScreen()
}
