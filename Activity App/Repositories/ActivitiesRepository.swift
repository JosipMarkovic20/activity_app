//
//  ActivitiesRepository.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import RxSwift

class ActivitiesRepositoryImpl: ActivitiesRepository{
    let restManager = RESTManager()
    func getInitialActivities() -> Observable<Result<[Activity], Error>> {
        var activities = [Activity]()
        let observable: Observable<Result<Activity, Error>> = getNewActivity()
        return observable.flatMap {[unowned self] activityData  -> Observable<Result<Activity, Error>> in
            switch activityData{
            case .success(let activity):
                activities.append(activity)
                return getNewActivity()
            case .failure(let error):
                return .just(.failure(error))
            }
        }.flatMap {[unowned self] activityData  -> Observable<Result<Activity, Error>> in
            switch activityData{
            case .success(let activity):
                activities.append(activity)
                return getNewActivity()
            case .failure(let error):
                return .just(.failure(error))
            }
        }.flatMap {[unowned self] activityData  -> Observable<Result<Activity, Error>> in
            switch activityData{
            case .success(let activity):
                activities.append(activity)
                return getNewActivity()
            case .failure(let error):
                return .just(.failure(error))
            }
        }.flatMap {[unowned self] activityData  -> Observable<Result<Activity, Error>> in
            switch activityData{
            case .success(let activity):
                activities.append(activity)
                return getNewActivity()
            case .failure(let error):
                return .just(.failure(error))
            }
        }.flatMap {activityData  -> Observable<Result<[Activity], Error>> in
            switch activityData{
            case .success(let activity):
                activities.append(activity)
                return .just(.success(activities))
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
    func getNewActivity() -> Observable<Result<Activity, Error>> {
        let observable: Observable<Result<Activity, Error>> = restManager.getData(url: RestEndpoints.activity.endpoint()).handleError()
        return observable
    }
    
    
}

protocol ActivitiesRepository{
    func getInitialActivities() -> Observable<Result<[Activity], Error>>
    func getNewActivity() -> Observable<Result<Activity, Error>>
}
