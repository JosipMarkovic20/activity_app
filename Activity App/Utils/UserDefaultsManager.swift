//
//  UserDefaultsManager.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation

class UserDefaultsManager{
    
    static let loggedInKey: String = "loggedIn"
    static let activityKey: String = "activities"
    
    private init(){}
    
    static let shared: UserDefaultsManager = UserDefaultsManager()
    
    
    func isLoggedIn() -> Bool{
        return UserDefaults.standard.bool(forKey: UserDefaultsManager.loggedInKey)
    }
    
    func getActivities() -> [Activity]{
        guard let data = UserDefaults.standard.value(forKey: UserDefaultsManager.activityKey) as? Data else { return []}
        let decoder = JSONDecoder()
        guard let activities = try? decoder.decode([Activity].self, from: data) else { return []}
        return activities
    }
    
    func saveActivites(activities: [Activity]){
        let encodedValues = SerilizationManager.getEncodedObject(object: activities)
        UserDefaults.standard.setValue(encodedValues, forKey: UserDefaultsManager.activityKey)
    }
}
