//
//  LoaderProtocol.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit

protocol LoaderProtocol {
    var spinner: UIActivityIndicatorView {get set}
    func showLoader()
    func hideLoader()
}

extension LoaderProtocol where Self: UIViewController {
    func showLoader(){
        DispatchQueue.main.async { [unowned self] in
            view.addSubview(spinner)
            
            spinner.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            spinner.startAnimating()
        }
    }
    
    func hideLoader(){
        DispatchQueue.main.async {[unowned self] in
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
}
