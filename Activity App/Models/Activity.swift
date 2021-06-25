//
//  Activity.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit

struct Activity: Codable {
    let activity: String
    let type: ActivityType
    let participants: Int
    let price: Float
    let key: String
    let accessibility: Float
}

enum ActivityType: String, Codable{
    case education
    case recreational
    case social
    case diy
    case charity
    case cooking
    case relaxation
    case music
    case busywork
    
    var image: UIImage? {
        switch self{
        case .education:
            return R.image.education()
        case .recreational:
            return R.image.recreational()
        case .social:
            return R.image.social()
        case .diy:
            return R.image.diy()
        case .charity:
            return R.image.charity()
        case .cooking:
            return R.image.cooking()
        case .relaxation:
            return R.image.relaxation()
        case .music:
            return R.image.music()
        case .busywork:
            return R.image.busywork()
        }
    }
}
