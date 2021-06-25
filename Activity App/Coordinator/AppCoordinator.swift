//
//  AppCoordinator.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit

class AppCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    
    init(window: UIWindow){
        self.window = window
    }
    
    func start() {
        let presenter = UINavigationController()
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        if UserDefaultsManager.shared.isLoggedIn(){
            createHomeCoordinator(presenter: presenter)
        }else{
            createLoginCoordinator(presenter: presenter)
        }
        
    }
    
    func createLoginCoordinator(presenter: UINavigationController){
        let loginCoordinator = LoginCoordinator(navController: presenter)
        self.addChildCoordinator(coordinator: loginCoordinator)
        loginCoordinator.start()
    }
    
    func createHomeCoordinator(presenter: UINavigationController){
        let homeCoordinator = HomeCoordinator(navController: presenter)
        self.addChildCoordinator(coordinator: homeCoordinator)
        homeCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        removeChildCoordinator(coordinator: self)
    }
}
