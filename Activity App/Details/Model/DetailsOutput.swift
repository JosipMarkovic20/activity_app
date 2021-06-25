//
//  DetailsOutput.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation

struct DetailsOutput{
    var item: ActivityViewItem?
    var event: DetailsOutputEvent?
}

enum DetailsOutputEvent{
    case reloadData
    case error(_ message: String)
}

