//
//  LoginViewModel.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModelImpl: LoginViewModel {
    var input: PublishSubject<LoginInput> = PublishSubject()
    var output: BehaviorRelay<LoginOutput> = BehaviorRelay.init(value: LoginOutput(event: nil))
    private var email: String = ""
    private var password: String = ""
    var loaderPublisher = PublishSubject<Bool>()
    
    public struct Dependencies {
        let activitiesRepository: ActivitiesRepository
    }
    
    var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension LoginViewModelImpl {
    func bindViewModel() -> [Disposable] {
        var disposables = [Disposable]()
        disposables.append(self.input
                            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                            .flatMap{ [unowned self] (input) -> Observable<LoginOutput> in
                                switch input{
                                case .emailInput(text: let text):
                                    return self.handleEmailInput(text: text)
                                case .passwordInput(text: let text):
                                    return self.handlePasswordInput(text: text)
                                case .loginClick:
                                    return self.handleLoginClick()
                                }
                            }.bind(to: output))
        return disposables
    }
    
    func handleLoginClick() -> Observable<LoginOutput> {
        if !ValidationManager.shared.isPasswordValid(password: self.password){
            return .just(LoginOutput(event: .validationError(error: R.string.localizable.min_length())))
        }else if !ValidationManager.shared.isValidEmailAddress(emailAddressString: self.email){
            return .just(LoginOutput(event: .validationError(error: R.string.localizable.email_not_valid())))
        }else{
            return self.handleSuccessfullLogin()
        }
    }
    
    func handleSuccessfullLogin() -> Observable<LoginOutput>{
        self.loaderPublisher.onNext(true)
        return dependencies.activitiesRepository.getInitialActivities()
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .map { result -> LoginOutput in
                switch result{
                case .success(let activities):
                    UserDefaultsManager.shared.saveActivites(activities: activities)
                    UserDefaults.standard.setValue(true, forKey: UserDefaultsManager.loggedInKey)
                    self.loaderPublisher.onNext(false)
                    return LoginOutput(event: .successfullLogin)
                case .failure(let error):
                    return LoginOutput(event: .validationError(error: error.localizedDescription))
                }
            }
    }
    
    func handleEmailInput(text: String?) -> Observable<LoginOutput> {
        self.email = text ?? ""
        return .just(LoginOutput(event: nil))
    }
    
    func handlePasswordInput(text: String?) -> Observable<LoginOutput> {
        self.password = text ?? ""
        return .just(LoginOutput(event: nil))
    }
}

protocol LoginViewModel {
    var input: PublishSubject<LoginInput> {get}
    func bindViewModel() -> [Disposable]
    var output: BehaviorRelay<LoginOutput> {get}
    var loaderPublisher: PublishSubject<Bool> {get}

}
