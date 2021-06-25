//
//  HomeViewModel.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModelImpl: HomeViewModel {
    var loaderPublisher = PublishSubject<Bool>()
    var input: ReplaySubject<HomeInput> = ReplaySubject.create(bufferSize: 1)
    var output: BehaviorRelay<HomeOutput> = BehaviorRelay.init(value: HomeOutput(items: [], event: nil))
    
    public struct Dependencies {
        let activitiesRepository: ActivitiesRepository
    }
    
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
}

extension HomeViewModelImpl {
    
    func bindViewModel() -> [Disposable] {
        var disposables = [Disposable]()
        disposables.append(self.input
                            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .flatMap{ [unowned self] (input) -> Observable<HomeOutput> in
                                switch input{
                                case .loadData:
                                    return handleDataLoad()
                                case .activityClicked(indexPath: let indexPath):
                                    return handleActivityClick(at: indexPath)
                                case .pullToRefresh:
                                    return handlePullToRefresh()
                                }
                            }.bind(to: output))
        return disposables
    }
    
    func handlePullToRefresh() -> Observable<HomeOutput>{
        return dependencies.activitiesRepository
            .getNewActivity()
            .flatMap {[unowned self] result -> Observable<HomeOutput> in
                self.loaderPublisher.onNext(false)
                switch result{
                case .success(let activity):
                    var activities = UserDefaultsManager.shared.getActivities()
                    activities.append(activity)
                    UserDefaultsManager.shared.saveActivites(activities: activities)
                    let newData = createScreenData(from: activities)
                    return .just(.init(items: newData, event: .reloadData))
                case .failure(let error):
                    return .just(.init(items: output.value.items, event: .error(error.localizedDescription)))
                }
        }
    }
    
    func handleActivityClick(at indexPath: IndexPath) -> Observable<HomeOutput>{
        if let item = output.value.items[indexPath.section].items[indexPath.row] as? HomeItem{
            return .just(.init(items: output.value.items, event: .openDetails(activity: item.item)))
        }
        return .just(.init(items: output.value.items, event: nil))
    }
    
    func handleDataLoad() -> Observable<HomeOutput>{
        self.loaderPublisher.onNext(true)
        let activities = UserDefaultsManager.shared.getActivities()
        self.loaderPublisher.onNext(false)
        return .just(.init(items: createScreenData(from: activities), event: .reloadData))
    }
    
    func createScreenData(from activities: [Activity]) -> [HomeSectionItem]{
        var screenData = [HomeSectionItem]()
        screenData.append(HomeSectionItem(identity: "activities", items: activities.map({ activity -> HomeItem in
            return HomeItem(identity: activity.key, item: ActivityViewItem(name: activity.activity,
                                                                           type: activity.type,
                                                                           key: activity.key,
                                                                           price: activity.price,
                                                                           participants: activity.participants,
                                                                           accessibility: activity.accessibility))
        })))
        return screenData
    }
}

protocol HomeViewModel {
    func bindViewModel() -> [Disposable]
    var loaderPublisher: PublishSubject<Bool> {get}
    var input: ReplaySubject<HomeInput> {get}
    var output: BehaviorRelay<HomeOutput> {get}
}
