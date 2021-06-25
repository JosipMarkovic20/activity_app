//
//  Observable+Extension.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import RxSwift

public extension Observable {
    func handleError() -> Observable<Result<Element, Error>> {
        return self.map { (element) -> Result<Element, Error> in
            return .success(element)
        }.catch { error -> Observable<Result<Element, Error>> in
            return .just(.failure(error))
        }
    }
}
