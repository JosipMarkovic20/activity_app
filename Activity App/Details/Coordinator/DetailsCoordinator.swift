//
//  DetailsCoordinator.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit

class DetailsCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var detailsViewController: DetailsViewController!
    var childCoordinators: [Coordinator] = []
    var parentDelegate: ParentCoordinatorDelegate?
    
    init(navController: UINavigationController, activity: ActivityViewItem) {
        navigationController = navController
        super.init()
        detailsViewController = createDetailsViewController(activity: activity)
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        navigationController.pushViewController(detailsViewController, animated: true)
    }

    func createDetailsViewController(activity: ActivityViewItem) -> DetailsViewController {
        let viewModel = DetailsViewModelImpl(dependencies: DetailsViewModelImpl.Dependencies(activity: activity))
        let viewController = DetailsViewController(viewModel: viewModel)
        return viewController
    }
}
extension DetailsCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
    
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
}
