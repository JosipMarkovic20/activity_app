//
//  HomeCoordinator.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit

class HomeCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var homeViewController: HomeViewController!
    var childCoordinators: [Coordinator] = []
    var parentDelegate: ParentCoordinatorDelegate?
    
    init(navController: UINavigationController) {
        navigationController = navController
        super.init()
        homeViewController = createHomeViewController()
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        navigationController.pushViewController(homeViewController, animated: true)
    }

    func createHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModelImpl(dependencies: HomeViewModelImpl.Dependencies(activitiesRepository: ActivitiesRepositoryImpl()))
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.homeNavigationDelegate = self
        return viewController
    }
}
extension HomeCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
    
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
}

extension HomeCoordinator: HomeNavigationDelegate{
    func navigateToDetails(activity: ActivityViewItem) {
        let coordinator = DetailsCoordinator(navController: navigationController, activity: activity)
        addChildCoordinator(coordinator: coordinator)
        coordinator.start()
    }
}

protocol HomeNavigationDelegate: AnyObject {
    func navigateToDetails(activity: ActivityViewItem)
}
