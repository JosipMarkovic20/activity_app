//
//  ParentCoordinatorDelegate.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation

protocol ParentCoordinatorDelegate: AnyObject {
    func childHasFinished(coordinator: Coordinator)
}
