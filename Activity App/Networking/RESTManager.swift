//
//  RESTManager.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import Alamofire
import RxSwift

class RESTManager{
    func getData<T: Codable>(url: String) -> Observable<T>{
        var parameters = Parameters()
        
        return Observable.create{ observer in
           let request = AF.request(url, parameters: parameters).validate().responseDecodable(of: T.self, decoder: SerilizationManager.jsonDecoder){ networkResponse in
                switch networkResponse.result{
                case .success:
                    do{
                        let response = try networkResponse.result.get()
                        observer.onNext(response)
                        observer.onCompleted()
                    }
                    catch(let error){
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
